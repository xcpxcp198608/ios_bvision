//
//  KSYPlayerViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/19.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
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
        let url = URL(string: "http://ooyalahd2-f.akamaihd.net/i/globalradio02_delivery@156522/index_656_av-p.m3u8?sd=10&rebase=on")
        player = KSYMoviePlayerController.init(contentURL: url)
        player?.controlStyle = .none
        player?.view.frame = playView.bounds
        playView.addSubview((player?.view)!)
        playView.autoresizesSubviews = true
        player?.view.autoresizingMask = .flexibleHeight
        player?.shouldAutoplay = true
        player?.scalingMode = .aspectFit
        player?.prepareToPlay()
    }
    
    func setNotifacation(){
        NotificationCenter.default.addObserver(self, selector: #selector(stateChange), name: Notification.Name.MPMoviePlayerPlaybackStatus, object: nil)
    }
    
    @objc func stateChange(){
        print(player?.playbackState)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        player?.stop()
    }

}
