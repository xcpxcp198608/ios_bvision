//
//  YTBTableViewController.swift
//  blive
//
//  Created by patrick on 17/03/2018.
//  Copyright © 2018 许程鹏. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import JGProgressHUD
import MJRefresh
import SnapKit

class YTBChannelsViewController: UIViewController{
    
    @IBOutlet weak var contentView: UIView!
    var collectionView: UICollectionView?
    
    var ytbChannels = [YTBChannelInfo]()
    
    var clipInfo: ClipInfo!
    var category = ""
    var pageToken = ""
    var totalResult = 0
    var isLd = false
    
    var footer: MJRefreshAutoNormalFooter?
    
    override func viewDidLoad() {
        initCollectionView()
        initPullDownRefresh()
        initPullUpLoadMore()
        if clipInfo.action == 1{
            isLd = true
        }
        category = clipInfo.category
        if(isLd){
            loadLdChannels(category, loadMore: false)
        }else{
            loadChannels(category, loadMore: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if ytbChannels.count <= 0 {
            if(isLd){
                self.loadLdChannels(category, loadMore: false)
            }else{
                self.loadChannels(category, loadMore: false)
            }
        }
    }
    
    
    func initCollectionView(){
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumLineSpacing = 1
        collectionLayout.minimumInteritemSpacing = 1
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: collectionLayout)
        collectionView?.showsVerticalScrollIndicator = true
        collectionView?.indicatorStyle = .white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor(rgb: Color.primary)
        let cellNib = UINib(nibName: "YTBChannelCell", bundle: nil)
        collectionView?.register(cellNib, forCellWithReuseIdentifier: "YTBChannelCell")
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
        if(isLd){
            loadLdChannels(category, loadMore: false)
        }else{
            loadChannels(category, loadMore: false)
        }
        self.collectionView!.mj_header.endRefreshing()
    }

    func initPullUpLoadMore(){
        footer = MJRefreshAutoNormalFooter()
        footer?.setTitle(NSLocalizedString("Drag up to refresh", comment: ""), for: .idle)
        footer?.setTitle(NSLocalizedString("Loading more ...", comment: ""), for: .refreshing)
        footer?.setTitle(NSLocalizedString("No more data", comment: ""), for: .noMoreData)
        footer?.setRefreshingTarget(self, refreshingAction: #selector(pullUpLoadMore))
        self.collectionView!.mj_footer = footer
        footer?.isHidden = true
    }
    
    @objc func pullUpLoadMore(){
        if(isLd){
            loadLdChannels(category, loadMore: true)
        }else{
            loadChannels(category, loadMore: true)
        }
        self.collectionView!.mj_footer.endRefreshing()
    }
    
}


extension YTBChannelsViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ytbChannels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if ytbChannels.count > 0 {
            let cell: YTBChannelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "YTBChannelCell", for: indexPath) as! YTBChannelCell
            let channel = ytbChannels[indexPath.row]
            cell.lTitle.text = channel.title
            let date = channel.publishedAt
            cell.lDate.text = date.substring(to: date.index(date.startIndex, offsetBy: 10))
            let url = URL(string: channel.thumbnails)
            cell.ivPreview.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "hold_bvision_4_3"))
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
}



extension YTBChannelsViewController: UICollectionViewDelegateFlowLayout{
    
    //动态设置每个cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = self.view.frame.width
        return CGSize.init(width: w, height: (w/422) * 364)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SegueYTBPlay", sender: ytbChannels[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueYTBPlay" {
            let channelInfo = sender as! YTBChannelInfo
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! YTBPlayViewController
            controller.channelInfo = channelInfo
        }
    }
    
}


extension YTBChannelsViewController {
    
    func loadChannels(_ category: String, loadMore isLoadMore: Bool){
        let hud = hudLoading()
        if(!isLoadMore){
            self.pageToken = ""
        }
        let url = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(category)&maxResults=50&type=video&order=date&key=\(Constant.youtube_api_key)&pageToken=\(self.pageToken)"
        
        Alamofire.request(url, method: .get).validate().responseData { (response) in
            switch response.result {
            case .success:
                let result = JSON(data: response.data!)
                self.pageToken = result["nextPageToken"].stringValue
                let items = result["items"]
                if(!isLoadMore){
                    self.ytbChannels.removeAll()
                }
                for i in 0..<items.count {
                    let item = items[i]
                    var channel = YTBChannelInfo()
                    channel.videoId = item["id"]["videoId"].stringValue
                    channel.title = item["snippet"]["title"].stringValue
                    channel.description = item["snippet"]["description"].stringValue
                    channel.publishedAt = item["snippet"]["publishedAt"].stringValue
                    channel.channelTitle = item["snippet"]["channelTitle"].stringValue
                    channel.thumbnails = item["snippet"]["thumbnails"]["high"]["url"].stringValue
                    self.ytbChannels.append(channel)
                }
                if self.ytbChannels.count > 0 {
                    self.footer?.isHidden = false
                }
                self.collectionView?.reloadData()
            case .failure(let error):
                print("error")
                print(error.localizedDescription)
                hud.dismiss()
                self.hudError(with: NSLocalizedString("net connection error", comment: ""))
            }
            hud.dismiss()
        }
    }
    
    
    func loadLdChannels(_ category: String, loadMore isLoadMore: Bool){
        let hud = hudLoading()
        if totalResult > 0 && ytbChannels.count >= totalResult {
            hud.dismiss()
            return
        }
        if(!isLoadMore){
            self.pageToken = ""
        }
        let url = "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=\(category)&maxResults=50&type=video&order=date&key=\(Constant.youtube_api_key)&pageToken=\(self.pageToken)"
        
        Alamofire.request(url, method: .get).validate().responseData { (response) in
            switch response.result {
            case .success:
                let result = JSON(data: response.data!)
                self.pageToken = result["nextPageToken"].stringValue
                self.totalResult = result["pageInfo"]["totalResults"].intValue
                let items = result["items"]
                if(!isLoadMore){
                    self.ytbChannels.removeAll()
                }
                for i in 0..<items.count {
                    let item = items[i]
                    var channel = YTBChannelInfo()
                    channel.videoId = item["id"]["videoId"].stringValue
                    channel.title = item["snippet"]["title"].stringValue
                    channel.description = item["snippet"]["description"].stringValue
                    channel.publishedAt = item["snippet"]["publishedAt"].stringValue
                    channel.channelTitle = item["snippet"]["channelTitle"].stringValue
                    channel.thumbnails = item["snippet"]["thumbnails"]["high"]["url"].stringValue
                    self.ytbChannels.append(channel)
                }
                if self.ytbChannels.count > 0 {
                    self.footer?.isHidden = false
                }
                self.collectionView?.reloadData()
            case .failure(let error):
                print("error")
                print(error.localizedDescription)
                hud.dismiss()
                self.hudError(with: NSLocalizedString("net connection error", comment: ""))
            }
            hud.dismiss()
        }
    }
}
