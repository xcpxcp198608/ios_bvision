//
//  VLCPlayerViewController.swift
//  blive
//
//  Created by patrick on 20/03/2018.
//  Copyright © 2018 许程鹏. All rights reserved.
//

import UIKit


class VLCPlayerViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return UIInterfaceOrientation.portrait
    }
    
    override var shouldAutorotate: Bool{
        return true
    }
    
    var player: VLCMediaPlayer?
    var playUrl: String?
    
    @IBOutlet weak var playView: UIView!
    
    fileprivate var maskShowing = true
    open var delayItem: DispatchWorkItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapGestureTapped))
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)
        if let url = playUrl {
            initPlayer(url)
        }
    }
    
    func initPlayer(_ url: String){
        print(url)
        player = VLCMediaPlayer()
        player?.drawable = playView
        player?.media = VLCMedia(url: URL.init(string: url))
        player?.play()
        player?.delegate = self
    }
    
    
    @objc open func onTapGestureTapped(_ gesture: UITapGestureRecognizer) {
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        releasePlayer()
    }
    
    func releasePlayer(){
        player?.stop()
    }
    
    deinit {
        releasePlayer()
    }
    
}


extension VLCPlayerViewController: VLCMediaPlayerDelegate{
    
    func mediaPlayerTimeChanged(_ aNotification: Notification!) {
//        print("****************\(aNotification)")
//        print("****************\(player.position)")
//        print("****************\(player.rate)")
//        print("****************\(player.time)")
    }
    
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        print("****************state change**************")
        let player = aNotification.object as! VLCMediaPlayer
        print(player.media.state.rawValue)
        
//        VLCMediaPlayerStateStopped,        //< Player has stopped
//        VLCMediaPlayerStateOpening,        //< Stream is opening
//        VLCMediaPlayerStateBuffering,      //< Stream is buffering
//        VLCMediaPlayerStateEnded,          //< Stream has ended
//        VLCMediaPlayerStateError,          //< Player has generated an error
//        VLCMediaPlayerStatePlaying,        //< Stream is playing
//        VLCMediaPlayerStatePaused          //< Stream is paused
        
//        let duration = self.player.media.length.intValue
//        print(duration)
        
        
    }
    
    
}

