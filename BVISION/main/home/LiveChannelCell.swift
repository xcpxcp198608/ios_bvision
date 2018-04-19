//
//  LiveChannelCell.swift
//  BVISION
//
//  Created by patrick on 2018/4/13.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit

class LiveChannelCell: UICollectionViewCell{
    
    @IBOutlet weak var ivThumbnail: UIImageView!
    @IBOutlet weak var ivRating: UIImageView!
    @IBOutlet weak var ivUserIcon: UIImageView!
    @IBOutlet weak var laTitle: UILabel!
    @IBOutlet weak var laUsername: UILabel!
    @IBOutlet weak var laTime: UILabel!
    @IBOutlet weak var btMore: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        let selectedView = UIView(frame: CGRect.zero)
//        selectedView.backgroundColor = UIColor(red: 70/255, green: 85/255,blue: 110/255, alpha: 0.3)
//        selectedBackgroundView = selectedView
        
        self.ivUserIcon.layer.cornerRadius = ivUserIcon.frame.width / 2
        self.ivUserIcon.layer.masksToBounds = true
    }
    
}
