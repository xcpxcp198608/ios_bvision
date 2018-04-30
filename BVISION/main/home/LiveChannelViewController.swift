//
//  LiveChannelViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/13.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import MJRefresh
import JGProgressHUD
import EFQRCode


class LiveChannelViewController: BasicViewController {
    
    
    lazy var liveChannelProvider = {
        return LiveChannelProvider()
    }()
    
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var contentView: UIView!
    var collectionView: UICollectionView?
    
    var liveChannleInfos = [LiveChannelInfo]()
    var hud: JGProgressHUD?
    
    override func viewDidLoad() {
        liveChannelProvider.delegate = self
        liveChannelProvider.load()
        hud = self.hudLoading()
        initCollectionView()
        initPullDownRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userInfoProvider.load(userId)
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
        let cellNib = UINib(nibName: "LiveChannelCell", bundle: nil)
        collectionView?.register(cellNib, forCellWithReuseIdentifier: "LiveChannelCell")
        self.contentView.addSubview(collectionView!)
        collectionView?.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(contentView)
        }
    }
    
    
    
    func initPullDownRefresh(){
        let header = MJRefreshNormalHeader()
        header.setTitle(NSLocalizedString("Pull down to refresh", comment: ""), for: MJRefreshState.idle)
        header.setTitle(NSLocalizedString("Release to refresh", comment: ""), for: .pulling)
        header.setTitle(NSLocalizedString("Loading ...", comment: ""), for: .refreshing)
        header.lastUpdatedTimeLabel.isHidden = true
        header.setRefreshingTarget(self, refreshingAction: #selector(pullDownRefresh))
        self.collectionView!.mj_header = header
    }
    
    @objc func pullDownRefresh(){
        liveChannelProvider.load()
        self.collectionView!.mj_header.endRefreshing()
    }

}


extension LiveChannelViewController: UICollectionViewDelegateFlowLayout{
    
    //动态设置每个cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = self.view.frame.width
        let h = w/16 * 9 + 70
        return CGSize.init(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if userId <= 0{
            showNoticeThenToSignBoard()
            return
        }
        self.performSegue(withIdentifier: "SegueLivePlay", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueLivePlay" {
            let indexPath = sender as! IndexPath
            let liveChannelInfo = liveChannleInfos[indexPath.row]
            let controller = segue.destination as! LivePlayViewController
            controller.liveChannelInfo = liveChannelInfo
        }
    }
    
}



extension LiveChannelViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return liveChannleInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if liveChannleInfos.count > 0 {
            let cell: LiveChannelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LiveChannelCell", for: indexPath) as! LiveChannelCell
            let channel = liveChannleInfos[indexPath.row]
            cell.laTitle.text = channel.title
            let time = channel.startTime
            if time.count >= 10{
                cell.laTime.text = time.substring(to: time.index(time.startIndex, offsetBy: 10))
            }
            cell.ivThumbnail.kf.setImage(with: URL(string: channel.preview), placeholder: #imageLiteral(resourceName: "hold_bvision"))
            cell.ivRating.image = Constant.ratingIcons[channel.rating]
            cell.laUsername.text = channel.username
            cell.ivUserIcon.kf.setImage(with: URL(string: channel.userIcon), placeholder: #imageLiteral(resourceName: "hold_person"))
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
}



extension LiveChannelViewController: LiveChannelProviderDelegate{
    
    func loadSuccess(_ liveChannelInfos: [LiveChannelInfo]) {
        hud?.dismiss()
        self.liveChannleInfos = liveChannelInfos
        self.collectionView?.reloadData()
    }
    
    func loadFailure(_ message: String, _ error: Error?) {
        hud?.dismiss()
        print(message)
    }
    
}


//MARK:- action
extension LiveChannelViewController{
    
    @IBAction func scan(){
        self.showScanViewController()
    }
    
    
    @IBAction func share(){
        let inviteCode = AESUtil.encrypt("\(TimeUtil.getUnixTimestamp())\(userId)")!
        if let tryImage = EFQRCode.generate(content: "\(Constant.link_app_qrcode)\(inviteCode)", watermark: #imageLiteral(resourceName: "bvision2").toCGImage()) {
            let title = NSString.init(string: "B·VISION")
            let image = UIImage.init(cgImage: tryImage)
            let url = NSURL(string: "\(Constant.link_app_qrcode)\(inviteCode)")
            let items = [title, image, url]
            let activityViewController = UIActivityViewController.init(activityItems: items, applicationActivities: nil)
            activityViewController.excludedActivityTypes = []
            self.present(activityViewController, animated: true) {
                // share result
            }
        }
    }
    
    
}
