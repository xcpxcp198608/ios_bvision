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
import Kingfisher
import SDCycleScrollView

class FollowViewController: BasicViewController {
    
    @IBOutlet weak var scrollView: SDCycleScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentView1: UIView!
    var collectionView: UICollectionView!
    var collectionView1: UICollectionView!
    
    var imageAdInfos = [ImageAdInfo]()
    
    let c1Icons = [#imageLiteral(resourceName: "trending"), #imageLiteral(resourceName: "friends_30"), #imageLiteral(resourceName: "groups_30"), #imageLiteral(resourceName: "contacts_30")]
    let c1Names = [NSLocalizedString("Trending", comment: ""), NSLocalizedString("Friends", comment: ""), NSLocalizedString("Groups", comment: ""), NSLocalizedString("Contacts", comment: "")]
    
    var hud: JGProgressHUD?
    var isFirstLoad = true
    
    var followUserInfos = [FollowUserInfo]()
    lazy var followUserProvider = {
        return FollowUserProvide()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageAdProvider.delegate = self
        imageAdProvider.load(position: 1)
        scrollView.backgroundColor = UIColor(rgb: Color.primary)
        scrollView.contentMode = .scaleAspectFill
        scrollView.placeholderImage = #imageLiteral(resourceName: "hold_banner")
        scrollView.delegate = self
        scrollView.autoScrollTimeInterval = 6
        scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
        if userId > 0{
            initCollectionView()
            initCollectionView1()
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
    
    func initCollectionView1(){
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumLineSpacing = 0
        collectionLayout.minimumInteritemSpacing = 1
        collectionView1 = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionLayout)
        collectionView1?.backgroundColor = UIColor.clear
        collectionView1?.showsVerticalScrollIndicator = true
        collectionView1?.indicatorStyle = .white
        collectionView1?.delegate = self
        collectionView1?.dataSource = self
        let cellNib = UINib(nibName: "CollectionCell", bundle: nil)
        collectionView1?.register(cellNib, forCellWithReuseIdentifier: "CollectionCell")
        self.contentView1.addSubview(collectionView1!)
        collectionView1?.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(contentView1)
        }
    }

}



extension FollowViewController: UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView{
            let w = self.view.frame.width
            return CGSize.init(width: w, height: 70)
        }else{
            let w = (self.view.frame.width - 3) / 4
            return CGSize.init(width: w, height: 105)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView{
            let userInfo = followUserInfos[indexPath.row]
            getFollowUserChannelInfo(userInfo.id)
        }else{
            showRelation(index: indexPath.row)
        }
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
    
    func showRelation(index: Int){
        var identifier = "ShowContactsViewController"
        switch index {
        case 0:
            identifier = "ShowTrendingViewController"
            break
        case 1:
            identifier = "ShowFriendsViewController"
            break
        case 2:
            identifier = "ShowGroupsViewController"
            break
        case 3:
            identifier = "ShowContactsViewController"
            break
        default:
            break
        }
        self.performSegue(withIdentifier: identifier, sender: nil)
    }
}



extension FollowViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         if collectionView == self.collectionView{
            return followUserInfos.count
         }else{
            return c1Icons.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView{
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
        }else{
            let cell: CollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
            cell.laName.text = c1Names[indexPath.row]
            cell.btAction.setImage(c1Icons[indexPath.row], for: .normal)
            return cell
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
        hud?.dismiss()
        print(message)
    }
    
}



extension FollowViewController: ImageAdProviderDelegate, SDCycleScrollViewDelegate{
    
    func loadSuccess(_ imageAdInfos: [ImageAdInfo]) {
        self.imageAdInfos = imageAdInfos
        var images = [String]()
        var titles = [String]()
        for imageAdInfo in imageAdInfos{
            images.append(imageAdInfo.url)
            titles.append(imageAdInfo.title)
        }
        scrollView.imageURLStringsGroup = images
//        scrollView.titlesGroup = titles
    }
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didScrollTo index: Int) {
        
    }
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        let imageAdInfo = self.imageAdInfos[index]
        if imageAdInfo.action == 0 {
            self.showWebView(imageAdInfo.link)
        }
    }
    
}

