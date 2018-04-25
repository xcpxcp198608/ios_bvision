//
//  FollowersViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/22.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import JGProgressHUD
import MJRefresh

class FollowersViewController: BasicViewController {

    @IBOutlet weak var contentView: UIView!
    var collectionView: UICollectionView!
    
    var hud: JGProgressHUD?
    var isFirstLoad = true
    
    var followerUserInfos = [FollowUserInfo]()
    lazy var followerProvider = {
        return FollowerUserProvide()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userId > 0{
            initCollectionView()
            initPullDownRefresh()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userId > 0{
            followerProvider.loadDelegate = self
            followerProvider.load(userId)
            if isFirstLoad{
                hud = self.hudLoading()
            }
        }
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
        let cellNib = UINib(nibName: "FollowCell", bundle: nil)
        collectionView?.register(cellNib, forCellWithReuseIdentifier: "FollowCell")
        self.contentView.addSubview(collectionView!)
        collectionView?.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(contentView)
        }
    }
    
    func initPullDownRefresh(){
        let header = MJRefreshNormalHeader()
        header.setTitle(NSLocalizedString("Pull down to refresh", comment: ""), for: MJRefreshState.idle)
        header.setTitle(NSLocalizedString("Release to refresh", comment: ""), for: .pulling)
        header.setTitle(NSLocalizedString("Loading...", comment: ""), for: .refreshing)
        header.lastUpdatedTimeLabel.isHidden = true
        header.setRefreshingTarget(self, refreshingAction: #selector(pullDownRefresh))
        self.collectionView!.mj_header = header
    }
    
    @objc func pullDownRefresh(){
        followerProvider.load(userId)
        self.collectionView!.mj_header.endRefreshing()
    }
    
}



extension FollowersViewController: UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = self.view.frame.width
        return CGSize.init(width: w, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userInfo = followerUserInfos[indexPath.row]
        
    }
    
    
    

    
}



extension FollowersViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return followerUserInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if followerUserInfos.count > 0 {
            let cell: FollowCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowCell", for: indexPath) as! FollowCell
            let userInfo = followerUserInfos[indexPath.row]
            cell.lUsername.text = userInfo.username
            if userInfo.profile.count > 0{
                cell.lUserProfile.text = userInfo.profile
            }
            cell.ivUserIcon.kf.setImage(with: URL(string: userInfo.icon), placeholder: #imageLiteral(resourceName: "hold_person"))
            cell.ivUserStatus.isHidden = true
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
}


extension FollowersViewController: FollowerUserProvideDelegate{
    
    func loadSuccess(_ followers: [FollowUserInfo]) {
        hud?.dismiss()
        isFirstLoad = false
        if followers.count > 0{
            self.followerUserInfos = followers
            self.collectionView.reloadData()
        }
    }
    
    func loadFailure(_ message: String, _ error: Error?) {
        hud?.dismiss()
        self.hudError(with: message)
        print(message)
    }
    
    
}
