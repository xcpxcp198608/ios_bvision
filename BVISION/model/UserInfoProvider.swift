//
//  UserInfoProvider.swift
//  BVISION
//
//  Created by patrick on 2018/4/23.
//  Copyright © 2018 wiatec. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol UserInfoProviderDelegate {
    func loadSuccess(_ userInfo: UserInfo)
    func loadFailure(_ message: String, _ error: Error?)
}

class UserInfoProvider {

    var loadDelegate: UserInfoProviderDelegate?
    
    func load(_ userId: Int){
        if userId <= 0 {return}
        let url = "\(Constant.url_user_details)\(userId)"
        Alamofire.request(url, method: .post)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    if(result[Constant.code].intValue == 200){
                        let userInfo = UserInfo(result[Constant.data])
                        UFUtils.set(userInfo.icon, key: Constant.key_user_icon)
                        UFUtils.set(userInfo.token, key: Constant.key_token)
                        UFUtils.set(userInfo.level, key: Constant.key_user_level)
                        UFUtils.set(userInfo.gender, key: Constant.key_user_gender)
                        UFUtils.set(userInfo.profile, key: Constant.key_user_profile)
                        self.loadDelegate?.loadSuccess(userInfo)
                    }else{
                        self.loadDelegate?.loadFailure(result[Constant.msg].stringValue, nil)
                    }
                case .failure(let error):
                    self.loadDelegate?.loadFailure(error.localizedDescription, error)
                }
            }
    }
}
