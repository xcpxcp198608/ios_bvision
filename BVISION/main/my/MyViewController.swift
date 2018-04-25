//
//  MyViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/13.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import Kingfisher

class MyViewController: BasicViewController {
    
    @IBOutlet weak var ivUserIcon: UIImageView!
    @IBOutlet weak var laUsername: UILabel!
    @IBOutlet weak var laVIP: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initUserInfo()
    }
    
    func initUserInfo(){
        ivUserIcon.layer.cornerRadius = ivUserIcon.frame.width/2
        ivUserIcon.layer.masksToBounds = true
        if let icon = UFUtils.getString(Constant.key_user_icon){
            ivUserIcon.kf.setImage(with: URL(string: icon), placeholder: #imageLiteral(resourceName: "hold_person"))
        }
        if let username = UFUtils.getString(Constant.key_username){
            laUsername.text = username
        }
        if userLevel >= 6 {
            laVIP.text = "PRO"
            laVIP.textColor = UIColor.yellow
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if userId <= 0{
            self.showNoticeThenToSignBoard()
            return false
        }
        return true
    }

}





