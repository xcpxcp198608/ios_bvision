//
//  UserCheckBlackProvider.swift
//  BVISION
//
//  Created by patrick on 2018/4/24.
//  Copyright © 2018 wiatec. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol UserCheckBlackProviderDelegate {
    func loadSuccess()
    func loadFailure(_ message: String, _ error: Error?)
}

class UserCheckBlackProvider {
    
    var loadDelegate: UserCheckBlackProviderDelegate?
    
    func load(_ userId: Int, playerId: Int){
        if userId <= 0 {return}
        let url = "\(Constant.url_user_set_black)\(playerId)/\(userId)"
        Alamofire.request(url, method: .get)
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
