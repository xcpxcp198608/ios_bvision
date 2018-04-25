//
//  FollowViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/13.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import MJRefresh
import Alamofire
import SwiftyJSON
import JGProgressHUD
import Contacts

class FollowViewController: BasicViewController {
    
    @IBOutlet weak var contentView: UIView!
    var collectionView: UICollectionView!
    
    var hud: JGProgressHUD?
    var isFirstLoad = true
    
    var followUserInfos = [FollowUserInfo]()
    lazy var followUserProvider = {
        return FollowUserProvide()
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
            followUserProvider.loadDelegate = self
            followUserProvider.load(userId)
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
        followUserProvider.load(userId)
        self.collectionView!.mj_header.endRefreshing()
    }

}



extension FollowViewController: UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = self.view.frame.width
        return CGSize.init(width: w, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userInfo = followUserInfos[indexPath.row]
        getFollowUserChannelInfo(userInfo.id)
    }
    
    func getFollowUserChannelInfo(_ id: Int){
        let url = "\(Constant.url_channel)\(id)"
        Alamofire.request(url, method: .get)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    if result["code"].intValue == 200{
                        let liveChannelInfo = LiveChannelInfo(result["data"])
                        if liveChannelInfo.available {
                            self.playChannel(liveChannelInfo)
                        }else{
                            self.hudError(with: NSLocalizedString("live has no start", comment: ""))
                        }
                    }else{
                        self.hudError(with: result["message"].stringValue)
                    }
                case .failure(let error):
                    print(error)
                    self.hudError(with: error.localizedDescription)
                }
        }
    }
    
    
    func playChannel(_ liveChannelInfo: LiveChannelInfo){
        let mainBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = mainBoard.instantiateViewController(withIdentifier: "LivePlayViewController") as! LivePlayViewController
        controller.liveChannelInfo = liveChannelInfo
        self.present(controller, animated: false, completion: nil)
    }
    
}



extension FollowViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return followUserInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if followUserInfos.count > 0 {
            let cell: FollowCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FollowCell", for: indexPath) as! FollowCell
            let userInfo = followUserInfos[indexPath.row]
            cell.lUsername.text = userInfo.username
            if userInfo.profile.count > 0{
                cell.lUserProfile.text = userInfo.profile
            }
            cell.ivUserIcon.kf.setImage(with: URL(string: userInfo.icon), placeholder: #imageLiteral(resourceName: "hold_person"))
            if userInfo.channelActive{
                cell.ivUserStatus.image = #imageLiteral(resourceName: "record_green_16")
            }
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
}


extension FollowViewController: FollowUserProvideDelegate{
    
    func loadSuccess(_ followUsers: [FollowUserInfo]) {
        hud?.dismiss()
        isFirstLoad = false
        if followUsers.count > 0{
            self.followUserInfos = followUsers
            self.collectionView.reloadData()
        }
    }
    
    func loadFailure(_ message: String, _ error: Error?) {
        print(message)
    }
    
}

