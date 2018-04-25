//
//  UserSetGenderProvider.swift
//  BVISION
//
//  Created by patrick on 2018/4/25.
//  Copyright © 2018 wiatec. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol UserSetGenderProviderDelegate {
    func loadSuccess(gender: Int)
    func loadFailure(_ message: String, _ error: Error?)
}

class UserSetGenderProvider {
    
    var loadDelegate: UserSetGenderProviderDelegate?
    
    func load(gender: Int){
        if userId <= 0 {return}
        let url = "\(Constant.url_user_gender)\(userId)/\(gender)"
        Alamofire.request(url, method: .put)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    if(result["code"].intValue == 200){
                        self.loadDelegate?.loadSuccess(gender: gender)
                    }else{
                        self.loadDelegate?.loadFailure(result["message"].stringValue, nil)
                    }
                case .failure(let error):
                    self.loadDelegate?.loadFailure(error.localizedDescription, error)
                }
        }
    }
}
