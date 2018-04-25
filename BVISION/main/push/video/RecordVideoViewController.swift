//
//  RecordVideoViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/19.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import AVKit
import MJRefresh

class RecordVideoViewController: BasicViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var videoNames = [String]()
    var videoPaths = [String]()
    var thumbnailSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: "LocalVideoCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "LocalVideoCell")
        loadRecordVideos()
        initPullDownRefresh()
    }
    
    
    func loadRecordVideos(){
        do{
            let path =  FileUtils.createDic("video")
            videoNames = try FileManager.default.contentsOfDirectory(atPath: path).reversed()
            if videoNames.count > 0{
                for name in videoNames{
                    let path = "\(path)/\(name)"
                    videoPaths.append(path)
                }
                print(videoPaths)
                tableView.reloadData()
            }
        }catch{
            
        }
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
        loadRecordVideos()
        self.tableView!.mj_header.endRefreshing()
    }
    
    
    func getMp4Thumbnail(_ path: String) -> UIImage{
        let pathUrl = URL(fileURLWithPath: path)
        let asset = AVURLAsset.init(url: pathUrl)
        let assetGenerator = AVAssetImageGenerator.init(asset: asset)
        assetGenerator.appliesPreferredTrackTransform = true
        assetGenerator.apertureMode = AVAssetImageGeneratorApertureMode.encodedPixels
        
        let time = CMTime.init(seconds: 2, preferredTimescale: 1)
        do{
            let image = try assetGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage.init(cgImage: image)
        }catch{
            return #imageLiteral(resourceName: "hold_bvision")
        }
    }
    
    func getMp4Duration(_ path: String) -> String{
        let pathUrl = URL(fileURLWithPath: path)
        let asset = AVURLAsset.init(url: pathUrl)
        let time = asset.duration
        let duration = Int(round(CMTimeGetSeconds(time)))
        return TimeUtil.getMediaTime(from: duration)
    }
    
}


extension RecordVideoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoPaths.count
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
        let index = indexPath.row
        cell.lName.text = videoNames[index]
        let path = videoPaths[index]
        let thumbnail = self.getMp4Thumbnail(path)
        cell.lDuration.text = getMp4Duration(path)
        cell.ivThumbnail.image = thumbnail
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showLocalPushViewController(URL.init(fileURLWithPath: videoPaths[indexPath.row]))
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        FileUtils.deleteFile(videoPaths[indexPath.row])
        videoNames.remove(at: indexPath.row)
        videoPaths.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
}
