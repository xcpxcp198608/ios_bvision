//
//  FollowCell.swift
//  blive
//
//  Created by patrick on 10/03/2018.
//  Copyright © 2018 许程鹏. All rights reserved.
//

import UIKit

class FollowCell: UICollectionViewCell {
    
    @IBOutlet weak var ivUserIcon: UIImageView!
    @IBOutlet weak var lUsername: UILabel!
    @IBOutlet weak var lUserProfile: UILabel!
    @IBOutlet weak var ivUserStatus: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ivUserIcon.layer.cornerRadius = ivUserIcon.frame.width / 2
        self.ivUserIcon.layer.masksToBounds = true
//        let selectedView = UIView(frame: CGRect.zero)
//        selectedView.backgroundColor = UIColor(red: 70/255, green: 85/255,blue: 110/255, alpha: 0.3)
//        selectedBackgroundView = selectedView
    }
    
    
}
