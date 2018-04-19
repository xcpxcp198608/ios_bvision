//
//  PLPlayerViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/19.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import PLPlayerKit

class PLPlayerViewController: BasicViewController {
    
    var player: PLPlayer?
    var playUrl = ""
    @IBOutlet weak var playView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPlayer()
    }
    
    func initPlayer(){
        print(playUrl)
        let option = PLPlayerOption.default()
        let url = URL(string: playUrl)
        player = PLPlayer.init(url: url, option: option)
        player?.delegate = self
        self.playView.addSubview((player?.playerView)!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.player?.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.player?.stop()
    }

}



extension PLPlayerViewController: PLPlayerDelegate{
    
    func player(_ player: PLPlayer, statusDidChange state: PLPlayerStatus) {
        switch state {
        case .statusCaching:
            print("statusCaching")
            break
        case .statusOpen:
            print("statusOpen")
            break
        case .statusError:
            print("statusError")
            break
        case .statusPaused:
            print("statusPaused")
            break
        case .statusPlaying:
            print("statusPlaying")
            break
        case .statusCompleted:
            print("statusCompleted")
            break
        default:
            break
        }
    }
    
    func player(_ player: PLPlayer, stoppedWithError error: Error?) {
        print(error)
    }
}
