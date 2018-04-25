//
//  ContactCell.swift
//  BVISION
//
//  Created by patrick on 2018/4/25.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit

protocol ContactCellDelegate {
    func sendMessage(_ contactInfo: ContactInfo)
}

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var laName: UILabel!
    @IBOutlet weak var btAction: UIButton!
    var contactInfo: ContactInfo!
    var delegate: ContactCellDelegate?
    
    override func awakeFromNib() {
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 24/255, green: 25/255,blue: 27/255, alpha: 1.0)
        backgroundView = selectedView
//        let selectedView1 = UIView(frame: CGRect.zero)
//        selectedView1.backgroundColor = UIColor(red: 24/255, green: 25/255,blue: 27/255, alpha: 1.0)
//        selectedBackgroundView = selectedView1
        btAction.layer.cornerRadius = btAction.frame.height / 4
        btAction.layer.masksToBounds = true
    }
    
    func setContactInfo(_ contactInfo: ContactInfo){
        self.contactInfo = contactInfo
        laName.text = "\(contactInfo.lastName)\(contactInfo.firstName)"
    }
    
    @IBAction func clickButton(){
        delegate?.sendMessage(contactInfo)
    }
    
}

