//
//  YBTPlayViewController.swift
//  blive
//
//  Created by patrick on 18/03/2018.
//  Copyright © 2018 许程鹏. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class YTBPlayViewController: BasicViewController {
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var tvDescription: UITextView!
    var channelInfo: YTBChannelInfo?
    var videoID: String!


    override func viewDidLoad() {
        super.viewDidLoad()
        tvDescription.text = channelInfo?.description
        playerView.load(withVideoId: (channelInfo?.videoId)!)
    }
}
