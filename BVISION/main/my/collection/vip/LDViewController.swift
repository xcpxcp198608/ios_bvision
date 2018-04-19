//
//  LDViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/18.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import JGProgressHUD
import MJRefresh
import SnapKit

class LDViewController: BasicViewController {

    @IBOutlet weak var contentView: UIView!
    var collectionView: UICollectionView?
    
    var ytbChannels = [YTBChannelInfo]()
    var category = "UCKdQylYy0HrANWEi2CWkn-g"
    var pageToken = ""
    var totalResult = 0
    var isLd = true
    
    override func viewDidLoad() {
        initCollectionView()
        initPullDownRefresh()
        initPullUpLoadMore()
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
                self.loadChannels(self.category, loadMore: false)
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
        let cellNib = UINib(nibName: "YTBChannelCell", bundle: nil)
        collectionView?.register(cellNib, forCellWithReuseIdentifier: "YTBChannelCell")
        self.contentView.addSubview(collectionView!)
        collectionView?.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(contentView)
        }
    }
    
    func initPullDownRefresh(){
        let header = MJRefreshNormalHeader()
        header.setTitle("Pull down to refresh", for: MJRefreshState.idle)
        header.setTitle("Release to refresh", for: .pulling)
        header.setTitle("Loading ...", for: .refreshing)
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
        let footer = MJRefreshAutoNormalFooter()
        footer.setTitle("Drag up to refresh", for: .idle)
        footer.setTitle("Loading more ...", for: .refreshing)
        footer.setTitle("No more data", for: .noMoreData)
        footer.setRefreshingTarget(self, refreshingAction: #selector(pullUpLoadMore))
        self.collectionView!.mj_footer = footer
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


extension LDViewController: UICollectionViewDataSource{
    
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
            cell.ivPreview.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "hold_bvision"))
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
}

extension LDViewController: UICollectionViewDelegateFlowLayout{
    
    //动态设置每个cell的大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = self.view.frame.width
        return CGSize.init(width: w, height: (w/418) * 293)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ytbPlayer(ytbChannels[indexPath.row])
    }
    
    func ytbPlayer(_ channelInfo: YTBChannelInfo){
        let board: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = board.instantiateViewController(withIdentifier: "YTBPlayViewController") as! UINavigationController
        let controller = navigationController.topViewController as! YTBPlayViewController
        controller.channelInfo = channelInfo
        self.present(navigationController, animated: false, completion: nil)
    }
    
}


extension LDViewController {
    
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
                self.collectionView?.reloadData()
            case .failure(let error):
                print("error")
                print(error.localizedDescription)
                hud.dismiss()
                self.hudError(with: "net connection error")
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
                self.collectionView?.reloadData()
            case .failure(let error):
                print("error")
                print(error.localizedDescription)
                hud.dismiss()
                self.hudError(with: "net connection error")
            }
            hud.dismiss()
        }
    }

}
