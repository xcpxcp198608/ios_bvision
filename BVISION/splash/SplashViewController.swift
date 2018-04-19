//
//  SplashViewController.swift
//  blive
//
//  Created by patrick on 19/12/2017.
//  Copyright © 2017 许程鹏. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import CoreData

class SplashViewController: UIViewController{
    
    override func viewDidAppear(_ animated: Bool) {
        let username: String? = UFUtils.getString(Constant.key_username)
        let token: String? = UFUtils.getString(Constant.key_token)
        if let name = username, let toke = token {
            if userId > 0 && name.count > 0 && toke.count > 0{
                validateToken(toke, userId)
            }else{
                self.showSignBoard()
            }
        }else{
            self.showSignBoard()
        }
    }
    
    func validateToken(_ token: String, _ userId: Int){
        Alamofire.request("\(Constant.url_token_validate)\(userId)/\(token)", method: .post)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    if(result["code"].intValue == 200){
                        self.getUerChannelInfo(userId)
                    }else{
                        self.cleanUserData()
                        self.showSignBoard()
                    }
                case .failure(let error):
                    print(error)
                    self.showMainBoard()
                }
        }
    }
    
    func getUerChannelInfo(_ userId: Int){
        let url = "\(Constant.url_channel)\(userId)"
        Alamofire.request(url, method: .get)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)["data"]
                    let channelInfo = LiveChannelInfo(result)
                    UFUtils.set(channelInfo.title, key: Constant.key_channel_title)
                    UFUtils.set(channelInfo.message, key: Constant.key_channel_message)
                    UFUtils.set(channelInfo.price, key: Constant.key_channel_price)
                    UFUtils.set(channelInfo.rating, key: Constant.key_channel_rating)
                    UFUtils.set(channelInfo.url, key: Constant.key_channel_push_url)
                    UFUtils.set(channelInfo.playUrl, key: Constant.key_channel_play_url)
                    UFUtils.set(channelInfo.preview, key: Constant.key_channel_preview)
                    UFUtils.set(channelInfo.link, key: Constant.key_channel_link)
                    self.showMainBoard()
                case .failure(let error):
                    print(error)
                    self.showMainBoard()
                }
            }
    }
    
    func cleanUserData(){
        UFUtils.clean()
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
}
