//
//  ChannelToken.swift
//  BVISION
//
//  Created by patrick on 2018/4/18.
//  Copyright © 2018 wiatec. All rights reserved.
//

import Foundation
import CryptoSwift
import Alamofire
import SwiftyJSON

class ChannelToken{
    
    static let TOKEN_URL = "http://apius.protv.company/v1/get_token.do?"
    static let PRE = "BTVi35C41E7"
    static let PWD = "Ho2oMcqUZMMvFzqb"
    
    static func execute(){
        let time = TimeUtil.getUnixTimestamp()
        let t = "\(PRE)\(PWD)\(time)".md5()
        let url = "\(TOKEN_URL)reg_date=\(time)&token=\(t)";
        
        Alamofire.request(url, method: .get).validate().responseData { (response) in
            switch response.result {
            case .success:
                let result = JSON(data: response.data!)
                print(result)
                let token = result["data"]["token"].stringValue
                let userDefaults = UserDefaults.standard
                userDefaults.set(token, forKey: Constant.key_live_play_channel_token)
                
            case .failure(let error):
                print("error")
                print(error.localizedDescription)
            }
        }
    }
    
}
