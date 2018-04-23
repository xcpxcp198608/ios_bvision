//
//  HistoryOperationCell.swift
//  BVISION
//
//  Created by patrick on 2018/4/23.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit

class HistoryOperationCell: UITableViewCell {
    
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var laDescription: UILabel!
    @IBOutlet weak var laTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 24/255, green: 25/255,blue: 27/255, alpha: 1.0)
        backgroundView = selectedView
        let selectedView1 = UIView(frame: CGRect.zero)
        selectedView1.backgroundColor = UIColor(red: 24/255, green: 25/255,blue: 27/255, alpha: 1.0)
        selectedBackgroundView = selectedView1
    }
}
