//
//  BvisionCoinViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/24.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import MJRefresh
import StoreKit
import Alamofire
import SwiftyJSON
import JGProgressHUD

class BvisionCoinsViewController: BasicViewController {
    
    let VERIFY_RECEIPT_URL = "https://buy.itunes.apple.com/verifyReceipt"
    let ITMS_SANDBOX_VERIFY_RECEIPT_URL = "https://sandbox.itunes.apple.com/verifyReceipt"
    
    var productDict:NSMutableDictionary!
    
    @IBOutlet weak var laCoins: UILabel!
    @IBOutlet weak var btConsent: UIButton!
    @IBOutlet weak var btCheckBox: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var btBill: UIButton!
    var collectionView: UICollectionView?
    
    var consentChecked = true
    var hud: JGProgressHUD?
    
    lazy var userGetCoinsProvider = {
        return UserGetCoinsProvider()
    }()
    
    var  coinInfos = [CoinInfo]()
    var currentPurchaseCoinInfo: CoinInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        userGetCoinsProvider.loadDelegate = self
        laCoins.text = "\(userCoins)"
        btCheckBox.isSelected = consentChecked
        initIAP()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userGetCoinsProvider.load(userId)
    }
    
    func initCollectionView(){
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumLineSpacing = 1
        collectionLayout.minimumInteritemSpacing = 1
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionLayout)
        collectionView?.backgroundColor = UIColor(rgb: Color.primary)
        collectionView?.showsVerticalScrollIndicator = true
        collectionView?.indicatorStyle = .white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        let cellNib = UINib(nibName: "CoinPurchaseCell", bundle: nil)
        collectionView?.register(cellNib, forCellWithReuseIdentifier: "CoinPurchaseCell")
        self.contentView.addSubview(collectionView!)
        collectionView?.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(contentView)
        }
    }
    
    
    @IBAction func checkSelect(){
        consentChecked = !consentChecked
        btCheckBox.isSelected = consentChecked
    }
    
    @IBAction func showPurchaseConsent(){
        self.showWebView(Constant.link_purchase_consent)
    }
    
    @IBAction func clickBtBill(){
        self.performSegue(withIdentifier: "ShowBillViewController", sender: "")
    }
    
    
    func initIAP(){
        SKPaymentQueue.default().add(self)
        let set = NSSet(array: CoinInfo.getIdentifiers())
        let request = SKProductsRequest.init(productIdentifiers: set as! Set<String>)
        request.delegate = self;
        request.start()
        hud = hudLoading()
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
}



extension BvisionCoinsViewController: UserGetCoinsProviderDelegate{
    
    func loadSuccess(_ coins: Int) {
        laCoins.text = "\(coins)"
        userCoins = coins
    }
    
    func loadFailure(_ message: String, _ error: Error?) {
        
    }
}



//MARK:- UICollectionViewDataSource
extension BvisionCoinsViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coinInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CoinPurchaseCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoinPurchaseCell", for: indexPath) as! CoinPurchaseCell
        self.currentPurchaseCoinInfo = coinInfos[indexPath.row]
        cell.setCoinInfo(coinInfos[indexPath.row])
        return cell
    }
    
}



//MARK:- UICollectionViewDelegateFlowLayout
extension BvisionCoinsViewController: UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = self.view.frame.width
        return CGSize.init(width: w, height: 62)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !consentChecked {
            self.hudError(with: NSLocalizedString("you has no agree purchase consent", comment: ""))
            return
        }
        let coinInfo = self.coinInfos[indexPath.row]
        self.currentPurchaseCoinInfo = coinInfo
        if let product = self.productDict[coinInfo.identifier]{
            buyProduct(product: product as! SKProduct)
        }
    }
    
    func buyProduct(product: SKProduct){
        if(SKPaymentQueue.canMakePayments()){
            self.hud = hudLoading()
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }else{
            hudError(with: NSLocalizedString("do not support IAP", comment: ""))
        }
    }
}



//MARK:- SKProductsRequestDelegate
extension BvisionCoinsViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver{
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if (productDict == nil) {
            productDict = NSMutableDictionary(capacity: response.products.count)
        }
        for product in response.products {
            print("=======Product id=======\(product.productIdentifier)")
//            print("========================\(product.localizedTitle)")
//            print("========================\(product.localizedDescription)")
//            print("========================\(product.price)")
            productDict.setObject(product, forKey: product.productIdentifier as NSCopying)
            var coinInfo = CoinInfo()
            coinInfo.identifier = product.productIdentifier
            coinInfo.name = product.localizedTitle
            coinInfo.amount = Double(product.price)
            self.coinInfos.append(coinInfo)
            coinInfos.sort { (c1, c2) -> Bool in
                return c1.amount < c2.amount
            }
        }
        if productDict.count > 0{
            self.initCollectionView()
            hud?.dismiss()
        }
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if (SKPaymentTransactionState.purchased == transaction.transactionState) {
                print("pay success＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝")
                self.verifyPruchase(transaction)
//                SKPaymentQueue.default().finishTransaction(transaction)
            }else if(SKPaymentTransactionState.failed == transaction.transactionState){
                self.hud?.dismiss()
                print("pay failure＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝")
                self.hudError(with: NSLocalizedString("pay failure", comment: ""))
                SKPaymentQueue.default().finishTransaction(transaction)
            }else if (SKPaymentTransactionState.restored == transaction.transactionState) {
                self.hud?.dismiss()
                SKPaymentQueue.default().finishTransaction(transaction)
            }
            
        }
    }
    
    func verifyPruchase(_ transaction: SKPaymentTransaction){
        let productIdentifier: String = currentPurchaseCoinInfo!.identifier
        // 验证凭据，获取到苹果返回的交易凭据
        // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
        let receiptURL = Bundle.main.appStoreReceiptURL
        // 从沙盒中获取到购买凭据
        let receiptData = NSData(contentsOf: receiptURL!)
        if receiptData == nil{
            self.hudError(with: NSLocalizedString("pay failure", comment: ""))
            SKPaymentQueue.default().finishTransaction(transaction)
            return
        }
        
        let encodeStr = receiptData?.base64EncodedString(options: .endLineWithLineFeed)
        let parameters = ["receiptData": encodeStr!, "platform": "\(getDeviceModel())-\(getSysVersion())", "productIdentifier": productIdentifier]
        let url = "\(Constant.url_coin_purchase_verify)\(userId)"
        Alamofire.request(url, method: .put, parameters: parameters, headers: Constant.urlencodedHeaders)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    print("verify success＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝")
                    let result = JSON(data: response.data!)
                    print(result)
                    if(result["code"].intValue == 200){
                        let coins = result["data"].intValue
                        userCoins = coins
                        self.laCoins.text = "\(coins)"
                        self.hudSuccess(with: NSLocalizedString("purchase successfully", comment: ""))
                        SKPaymentQueue.default().finishTransaction(transaction)
                    }else{
                        self.hudError(with: result["message"].stringValue)
                    }
                case .failure(let error):
                    print(error)
                }
                self.hud?.dismiss()
        }
    
    }
    
    func restorePurchase(){
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
}

