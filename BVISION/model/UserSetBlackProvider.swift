//
//  UserBlackProvider.swift
//  BVISION
//
//  Created by patrick on 2018/4/23.
//  Copyright © 2018 wiatec. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol UserSetBlackProviderDelegate {
    func loadSuccess()
    func loadFailure(_ message: String, _ error: Error?)
}

class UserSetBlackProvider {
    
    var loadDelegate: UserSetBlackProviderDelegate?
    
    func load(_ action: Int, _ userId: Int, username: String){
        if userId <= 0 {return}
        let url = "\(Constant.url_user_set_black)\(action)/\(userId)"
        let parameters = ["username": username]
        Alamofire.request(url, method: .post, parameters: parameters)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    if(result["code"].intValue == 200){
                        self.loadDelegate?.loadSuccess()
                    }else{
                        self.loadDelegate?.loadFailure(result["message"].stringValue, nil)
                    }
                case .failure(let error):
                    self.loadDelegate?.loadFailure(error.localizedDescription, error)
                }
        }
    }
}
