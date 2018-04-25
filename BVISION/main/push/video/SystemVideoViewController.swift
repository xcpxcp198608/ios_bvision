//
//  SystemVideoViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/19.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import Photos
import AVKit
import MJRefresh

class SystemVideoViewController: BasicViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var fetchResults: PHFetchResult<PHAsset>!
    var imageManager: PHCachingImageManager!
    var thumbnailSize: CGSize!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: "LocalVideoCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "LocalVideoCell")
        fetchResults = PHAsset.fetchAssets(with: .video, options: nil)
        if fetchResults.count > 0 {
            tableView.reloadData()
        }
        self.imageManager = PHCachingImageManager()
        self.imageManager.stopCachingImagesForAllAssets()
        initPullDownRefresh()
    }
    
    func initPullDownRefresh(){
        let header = MJRefreshNormalHeader()
        header.setTitle(NSLocalizedString("Pull down to refresh", comment: ""), for: MJRefreshState.idle)
        header.setTitle(NSLocalizedString("Release to refresh", comment: ""), for: .pulling)
        header.setTitle(NSLocalizedString("Loading...", comment: ""), for: .refreshing)
        header.lastUpdatedTimeLabel.isHidden = true
        header.setRefreshingTarget(self, refreshingAction: #selector(pullDownRefresh))
        self.tableView!.mj_header = header
    }
    
    @objc func pullDownRefresh(){
        fetchResults = PHAsset.fetchAssets(with: .video, options: nil)
        if fetchResults.count > 0 {
            tableView.reloadData()
        }
        self.tableView!.mj_header.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        thumbnailSize = CGSize.init(width: view.frame.width - 16, height: (view.frame.width - 16)/4 * 3)
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocalVideoCell", for: indexPath) as! LocalVideoCell
        cell.backgroundColor = UIColor.black
        let fetchResult = fetchResults[indexPath.row]
        cell.lName.text = fetchResult.value(forKey: "filename") as? String
        let seconds = Int(round(fetchResult.duration))
        cell.lDuration.text = TimeUtil.getMediaTime(from: seconds)
        
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: fetchResult, targetSize: CGSize(width: 320, height: 240), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        cell.ivThumbnail.image = thumbnail
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        self.performSegue(withIdentifier: "PlayLocalVideo", sender: indexPath)
        startLocaPush(indexPath.row)
    }
    
    func startLocaPush(_ index: Int){
        let assent = fetchResults.object(at: index)
        if let path = getVideoPathFromAssent(assent){
            print(path)
            self.showLocalPushViewController(URL.init(fileURLWithPath: path))
        }
    }
    
    func getVideoPathFromAssent(_ assent: PHAsset) -> String?{
        let resources = PHAssetResource.assetResources(for: assent)
        var res = PHAssetResource()
        for resource in resources{
            if resource.type == .pairedVideo || resource.type == .video {
                res = resource
            }
        }
        let fileName = res.originalFilename
        if assent.mediaType == .video || assent.mediaSubtypes == .photoLive{
            let options = PHVideoRequestOptions.init()
            options.version = .current
            options.deliveryMode = .highQualityFormat
            let path = NSTemporaryDirectory().appending(fileName)
            do{
                //                try FileManager.default.removeItem(atPath: path)
                PHAssetResourceManager.default().writeData(for: res, toFile: URL.init(fileURLWithPath: path), options: nil) { (error) in
                    if error != nil{
                        print(error)
                    }
                }
            }catch{
                return nil
            }
            return path
        }else{
            return nil
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = sender as! IndexPath
        let fetchResult = fetchResults.object(at: indexPath.row)
        let orgFileName = fetchResult.value(forKey: "filename") as? String
        let fileExt = (orgFileName! as NSString).pathExtension
        var identifier = fetchResult.localIdentifier as NSString
        let range = identifier.range(of: "/")
        identifier = identifier.substring(to: range.location) as NSString
        let appendedString = String(format: "%@%@%@%@%@%@", "assets-library://asset/asset.", fileExt, "?id=", identifier, "&ext=", fileExt)
        let destination = segue.destination as! AVPlayerViewController
        destination.player = AVPlayer(url: URL(string: appendedString)!)
        destination.player?.play()
    }
    
}
