//
//  UserSetProfileProvider.swift
//  BVISION
//
//  Created by patrick on 2018/4/25.
//  Copyright © 2018 wiatec. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol UserSetProfileProviderDelegate {
    func loadSuccess(profile: String)
    func loadFailure(_ message: String, _ error: Error?)
}

class UserSetProfileProvider {
    
    var loadDelegate: UserSetProfileProviderDelegate?
    
    func load(profile: String){
        if userId <= 0 {return}
        let url = "\(Constant.url_user_profile)\(userId)"
        let parameters = ["profile": profile]
        Alamofire.request(url, method: .put, parameters: parameters, headers: Constant.urlencodedHeaders)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    if(result["code"].intValue == 200){
                        self.loadDelegate?.loadSuccess(profile: profile)
                    }else{
                        self.loadDelegate?.loadFailure(result["message"].stringValue, nil)
                    }
                case .failure(let error):
                    self.loadDelegate?.loadFailure(error.localizedDescription, error)
                }
        }
    }
}
