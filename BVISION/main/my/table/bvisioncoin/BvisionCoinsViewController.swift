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
    
    let items = ["BVISION COIN 100", "BVISION COIN 200", "BVISION COIN 500", "BVISION COIN 1000"]
    let itemIds = ["com.legacy.bvision.bc100", "com.legacy.bvision.bc200", "com.legacy.bvision.bc500", "com.legacy.bvision.bc1000"]
    let prices = [9.99, 18.99, 48.99, 94.99]
    let coins = [100, 200, 500, 1000]
    var productDict:NSMutableDictionary!
    
    @IBOutlet weak var laCoins: UILabel!
    @IBOutlet weak var btConsent: UIButton!
    @IBOutlet weak var btCheckBox: UIButton!
    @IBOutlet weak var contentView: UIView!
    var collectionView: UICollectionView?
    
    var checked = true
    
    var hud: JGProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btCheckBox.isSelected = checked
        initCollectionView()
        initIAP()
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
        checked = !checked
        btCheckBox.isSelected = checked
    }
    
    @IBAction func showPurchaseConsent(){
        self.showWebView(Constant.link_purchase_consent)
    }
    
    
    func initIAP(){
        SKPaymentQueue.default().add(self)
        var set = NSSet(array: itemIds)
        let request = SKProductsRequest.init(productIdentifiers: set as! Set<String>)
        request.delegate = self;
        request.start()
        hud = hudLoading()
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
}


//MARK:- UICollectionViewDataSource
extension BvisionCoinsViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CoinPurchaseCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoinPurchaseCell", for: indexPath) as! CoinPurchaseCell
        let index = indexPath.row
        cell.laDescription.text = items[index]
        cell.btPurchase.setTitle("$\(prices[index])", for: .normal)
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
        if !checked {
            self.hudError(with: NSLocalizedString("you has no agree purchase consent", comment: ""))
            return
        }
        let productId = itemIds[indexPath.row]
        let product = self.productDict[productId]
        buyProduct(product: product as! SKProduct)
    }
    
    func buyProduct(product: SKProduct){
        if(SKPaymentQueue.canMakePayments()){
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
            print("========================\(product.localizedTitle)")
            print("========================\(product.localizedDescription)")
            print("========================\(product.price)")
            productDict.setObject(product, forKey: product.productIdentifier as NSCopying)
        }
        hud?.dismiss()
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if (SKPaymentTransactionState.purchased == transaction.transactionState) {
                print("pay success＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝")
                self.verifyPruchase(transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
            }else if(SKPaymentTransactionState.failed == transaction.transactionState){
                print("pay failure＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝")
                SKPaymentQueue.default().finishTransaction(transaction)
            }else if (SKPaymentTransactionState.restored == transaction.transactionState) {
                
                SKPaymentQueue.default().finishTransaction(transaction)
            }
            
        }
    }
    
    func verifyPruchase(_ productIdentifier: String){
        // 验证凭据，获取到苹果返回的交易凭据
        // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
        let receiptURL = Bundle.main.appStoreReceiptURL
        // 从沙盒中获取到购买凭据
        let receiptData = NSData(contentsOf: receiptURL!)
        let encodeStr = receiptData?.base64EncodedString(options: .endLineWithLineFeed)
        
        let parameters = ["receipt-data": encodeStr]
        Alamofire.request(ITMS_SANDBOX_VERIFY_RECEIPT_URL, method: .post, parameters: parameters)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    print("verify success＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝")
                    let result = JSON(data: response.data!)
                    print(result)
                    
                    let index = self.itemIds.index(of: productIdentifier)
                    let x = Int(self.laCoins.text!)! + self.coins[index!]
                    self.laCoins.text = "\(x)"
                case .failure(let error):
                    print(error)
                }
        }
    
    }
    
    func restorePurchase(){
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
}

