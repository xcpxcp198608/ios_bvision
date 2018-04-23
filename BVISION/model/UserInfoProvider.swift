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
        Alamofire.request(url, method: .get)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    if(result["code"].intValue == 200){
                        let userInfo = UserInfo(result["data"])
                        self.loadDelegate?.loadSuccess(userInfo)
                    }else{
                        self.loadDelegate?.loadFailure(result["message"].stringValue, nil)
                    }
                case .failure(let error):
                    self.loadDelegate?.loadFailure(error.localizedDescription, error)
                }
            }
    }
}
