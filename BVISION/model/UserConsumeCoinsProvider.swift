//
//  UserConsumeCoinsProvider.swift
//  BVISION
//
//  Created by patrick on 2018/4/26.
//  Copyright © 2018 wiatec. All rights reserved.
//

import Foundation

import Foundation
import Alamofire
import SwiftyJSON

protocol UserConsumeCoinsProviderDelegate {
    func loadSuccess(_ coins: Int)
    func loadFailure(_ message: String, _ error: Error?)
}

class UserConsumeCoinsProvider {
    
    var loadDelegate: UserConsumeCoinsProviderDelegate?
    
    func load(_ userId: Int, targetUserId: Int, numbers: Int, platform: String, description: String){
        if userId <= 0 {return}
        let url = "\(Constant.url_coin_consume)\(userId)/\(targetUserId)/\(numbers)"
        let parameters = ["description": description, "platform": platform]
        Alamofire.request(url, method: .put, parameters: parameters, headers: Constant.urlencodedHeaders)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    if(result["code"].intValue == 200){
                        self.loadDelegate?.loadSuccess(result["data"].intValue)
                    }else{
                        self.loadDelegate?.loadFailure(result["message"].stringValue, nil)
                    }
                case .failure(let error):
                    self.loadDelegate?.loadFailure(error.localizedDescription, error)
                }
        }
    }
}
