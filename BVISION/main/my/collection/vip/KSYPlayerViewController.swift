//
//  KSYPlayerViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/19.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import AVKit
import libksygpulive

class KSYPlayerViewController: BasicViewController {
    
    @IBOutlet weak var playView: UIView!
    var player: KSYMoviePlayerController?
    var playUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPlayer()
        setNotifacation()
    }
    
    func initPlayer(){
        let url = URL(string: playUrl)
        player = KSYMoviePlayerController.init(contentURL: url)
        player?.controlStyle = .fullscreen
        player?.view.frame = playView.bounds
        playView.addSubview((player?.view)!)
        playView.autoresizesSubviews = true
        player?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        player?.shouldEnableVideoPostProcessing = true
        player?.shouldAutoplay = true
        player?.scalingMode = .fill
        player?.videoDecoderMode = .AUTO
        player?.prepareToPlay()
    }
    
    func setNotifacation(){
        NotificationCenter.default.addObserver(self, selector: #selector(stateChange), name: Notification.Name.MPMoviePlayerPlaybackStatus, object: nil)
    }
    
    @objc func stateChange(){
        switch (player?.playbackState)! {
        case MPMoviePlaybackState.playing:
            print("playing")
            break
        case MPMoviePlaybackState.paused:
            print("paused")
            break
        case MPMoviePlaybackState.stopped:
            print("stopped")
            break
            
        case MPMoviePlaybackState.interrupted:
            print("interrupted")
            break
        default:
            break
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        player?.stop()
    }

}
