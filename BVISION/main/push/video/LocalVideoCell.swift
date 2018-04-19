//
//  LocalVideoCell.swift
//  blive
//
//  Created by patrick on 26/03/2018.
//  Copyright © 2018 许程鹏. All rights reserved.
//

import UIKit

class LocalVideoCell: UITableViewCell{
    
    @IBOutlet weak var ivThumbnail: UIImageView!
    @IBOutlet weak var lName: UILabel!
    @IBOutlet weak var lDuration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 5/255, green: 5/255,blue: 5/255, alpha: 0.3)
        selectedBackgroundView = selectedView
    }
    
}
