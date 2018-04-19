//
//  MyViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/13.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import Kingfisher

class MyViewController: BasicViewController {
    
    @IBOutlet weak var ivUserIcon: UIImageView!
    @IBOutlet weak var laUsername: UILabel!
    @IBOutlet weak var laVIP: UILabel!
    @IBOutlet weak var laBvisionCoin: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    
    var collectionView: UICollectionView?
    let cellIcons = [#imageLiteral(resourceName: "VIP"), #imageLiteral(resourceName: "bvision_coin30"), #imageLiteral(resourceName: "mall"), #imageLiteral(resourceName: "record_40")]
    let cellTitles = ["VIP", "BvisionCoin", "Mall", ""]
    let cellControllers = ["VIPViewController", "BvisionCoinViewController", "MallViewController", "MallViewController"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMyCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initUserInfo()
    }
    
    func initUserInfo(){
        ivUserIcon.layer.cornerRadius = ivUserIcon.frame.width/2
        ivUserIcon.layer.masksToBounds = true
        if let icon = UFUtils.getString(Constant.key_user_icon){
            ivUserIcon.kf.setImage(with: URL(string: icon), placeholder: #imageLiteral(resourceName: "hold_person"))
        }
        if let username = UFUtils.getString(Constant.key_username){
            laUsername.text = username
        }
        if userLevel >= 6 {
            laVIP.text = "VIP"
            laVIP.textColor = UIColor.yellow
        }
    }
    
    func initMyCollectionView(){
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
        let cellNib = UINib(nibName: "MyCell", bundle: nil)
        collectionView?.register(cellNib, forCellWithReuseIdentifier: "MyCell")
        self.contentView.addSubview(collectionView!)
        collectionView?.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(contentView)
        }
    }

}





extension MyViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellIcons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if cellIcons.count > 0 {
            let cell: MyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCell
            cell.ivIcon.image = cellIcons[indexPath.row]
            cell.laTitle.text = cellTitles[indexPath.row]
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
}



extension MyViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (self.view.frame.width - 3) / 4
        return CGSize.init(width: w, height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        if index <= 1 {
            if userId <= 0 {
                self.showNoticeThenToSignBoard()
                return
            }
            if index == 0 {
                if userLevel < 6{
                    self.hudError(with: "permission denied")
                    return
                }
            }
        }
        showViewController(cellControllers[indexPath.row])
    }
    
    func showViewController(_ controller: String){
        let board: UIStoryboard = UIStoryboard(name: "MyCollection", bundle: nil)
        let navigationController = board.instantiateViewController(withIdentifier: controller) as! UINavigationController
        self.present(navigationController, animated: false, completion: nil)
    }
}
