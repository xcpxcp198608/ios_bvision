//
//  UserDetailsViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/30.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import Kingfisher

class UserDetailsViewController: BasicViewController {
    
    var targetUserId = 0
    
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var ivGender: UIImageView!
    @IBOutlet weak var laUsername: UILabel!
    @IBOutlet weak var laPhone: UILabel!
    @IBOutlet weak var laEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ivIcon.layer.cornerRadius = ivIcon.frame.width / 6
        ivIcon.layer.masksToBounds = true
        if targetUserId <= 0 {
            return
        }
        userInfoProvider.loadDelegate = self
        userInfoProvider.load(targetUserId)
        
    }

}



extension UserDetailsViewController: UserInfoProviderDelegate{
    
    func loadSuccess(_ userInfo: UserInfo) {
        ivIcon.kf.setImage(with: makeURL(userInfo.icon), placeholder: #imageLiteral(resourceName: "hold_person"))
        if userInfo.gender == 0{
            ivGender.image = #imageLiteral(resourceName: "male_20")
        }else{
            ivGender.image = #imageLiteral(resourceName: "female_20")
        }
        laUsername.text = userInfo.username
        laPhone.text = userInfo.phone
        laEmail.text = userInfo.email
    }
    
    func loadFailure(_ message: String, _ error: Error?) {
        
    }
}
