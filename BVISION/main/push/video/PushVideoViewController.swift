//
//  PushVideoViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/16.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit

class PushVideoViewController: BasicViewController {

    @IBOutlet weak var scVideos: UISegmentedControl!
    @IBOutlet weak var cnvSysVideos: UIView!
    @IBOutlet weak var cnvRecordVideos: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if index == 0{
            self.cnvSysVideos.isHidden = false
            self.cnvRecordVideos.isHidden = true
        }
        if index == 1{
            self.cnvSysVideos.isHidden = true
            self.cnvRecordVideos.isHidden = false
        }
    }

}
