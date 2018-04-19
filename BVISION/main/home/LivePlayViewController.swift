//
//  LivePlayViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/16.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import SnapKit
import BMPlayer

class LivePlayViewController: BasicViewController {
    
    var livePlayDetailViewController:LivePlayDetailViewController?
    var liveChannelInfo: LiveChannelInfo?
    
    @IBOutlet weak var player: BMCustomPlayer!
    @IBOutlet weak var containerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let liveChannel = liveChannelInfo else{ fatalError("channel error")}
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(applicationWillEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        initPlayer(liveChannel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueLivePlayDetail" {
            livePlayDetailViewController = segue.destination as? LivePlayDetailViewController
            livePlayDetailViewController?.liveChannelInfo = liveChannelInfo
        }
    }
    
    
    @objc func applicationWillEnterForeground() {
        player.autoPlay()
    }
    
    @objc func applicationDidEnterBackground() {
        player.pause(allowAutoPlay: false)
    }
    
    func initPlayer(_ liveChannel: LiveChannelInfo){
        player.backBlock = { [unowned self] (isFullScreen) in
            if isFullScreen == true {
                return
            }else{
                self.dismiss(animated: true, completion: nil)
            }
            let _ = self.navigationController?.popViewController(animated: true)
        }
        print(liveChannel.playUrl)
        let asset = BMPlayerResource(url: URL(string: liveChannel.playUrl)!, name: liveChannel.title, cover: nil, subtitle: nil)
        player.setVideo(resource: asset)
        player.delegate = self
    }
    
    deinit {
        player.prepareToDealloc()
    }

}

// MARK:- BMPlayerDelegate
extension LivePlayViewController: BMPlayerDelegate {
    
    // Call when player orinet changed
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
        if(isFullscreen){
            containerView.isHidden = true
        }else{
            containerView.isHidden = false
        }
        player.snp.remakeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            if isFullscreen {
                make.bottom.equalTo(view.snp.bottom)
            } else {
                make.height.equalTo(view.snp.width).multipliedBy(9.0/16.0).priority(500)
            }
        }
    }
    
    // Call back when playing state changed, use to detect is playing or not
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
        print("| BMPlayerDelegate | playerIsPlaying | playing - \(playing)")
    }
    
    // Call back when playing state changed, use to detect specefic state like buffering, bufferfinished
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
        print("| BMPlayerDelegate | playerStateDidChange | state - \(state)")
    }
    
    // Call back when play time change
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        //                print("| BMPlayerDelegate | playTimeDidChange | \(currentTime) of \(totalTime)")
    }
    
    // Call back when the video loaded duration changed
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        //        print("| BMPlayerDelegate | loadedTimeDidChange | \(loadedDuration) of \(totalDuration)")
    }
}
