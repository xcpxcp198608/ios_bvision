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
    func loadSuccess(action: Int, indexPath: IndexPath?)
    func loadFailure(_ message: String, _ error: Error?)
}

class UserSetBlackProvider {
    
    var loadDelegate: UserSetBlackProviderDelegate?
    
    func load(indexPath: IndexPath?, action: Int, userId: Int, username: String){
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
                        self.loadDelegate?.loadSuccess(action: action, indexPath: indexPath)
                    }else if(result["code"].intValue == 555){
                        self.loadDelegate?.loadFailure(NSLocalizedString("Please contact the broadcaster for additional information", comment: ""), nil)
                    }else{
                        self.loadDelegate?.loadFailure(result["message"].stringValue, nil)
                    }
                case .failure(let error):
                    self.loadDelegate?.loadFailure(error.localizedDescription, error)
                }
        }
    }
}
