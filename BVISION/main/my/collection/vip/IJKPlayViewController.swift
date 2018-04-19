//
//  IJKPlayViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/19.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import IJKMediaFramework

class IJKPlayViewController: BasicViewController {
    
    var player: IJKFFMoviePlayerController?
    var playUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let options = IJKFFOptions.byDefault()
        let url = URL(string: playUrl)
        player = IJKFFMoviePlayerController(contentURL: url, with: options)
        //播放页面视图宽高自适应
        let autoresize = UIViewAutoresizing.flexibleWidth.rawValue |
            UIViewAutoresizing.flexibleHeight.rawValue
        player?.view.autoresizingMask = UIViewAutoresizing(rawValue: autoresize)
        
        player?.view.frame = self.view.bounds
        player?.scalingMode = .aspectFit //缩放模式
        player?.shouldAutoplay = true //开启自动播放
        
        self.view.autoresizesSubviews = true
        self.view.addSubview((player?.view)!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        player?.prepareToPlay()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        player?.shutdown()
    }


}



