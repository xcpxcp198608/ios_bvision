//
//  FollowUserProvider.swift
//  BVISION
//
//  Created by patrick on 2018/4/18.
//  Copyright © 2018 wiatec. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol FollowUserProvideDelegate {
    func loadSuccess(_ followUsers:  [UserInfo])
    func loadFailure(_ message: String, _ error: Error?)
}

class FollowUserProvide {
    
    var loadDelegate: FollowUserProvideDelegate?
    
    func load(_ userId: Int){
        if userId <= 0 {return}
        let url = "\(Constant.url_user_follows)\(userId)"
        Alamofire.request(url, method: .get)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    if(result["code"].intValue == 200){
                        let dataList = result["dataList"]
                        var followUsers = [UserInfo]()
                        for i in 0..<dataList.count {
                            followUsers.append(UserInfo(dataList[i]))
                        }
                        
                        self.loadDelegate?.loadSuccess(followUsers)
                    }else{
                        self.loadDelegate?.loadFailure(result["message"].stringValue, nil)
                    }
                case .failure(let error):
                    self.loadDelegate?.loadFailure(error.localizedDescription, error)
                }
        }
    }
}
