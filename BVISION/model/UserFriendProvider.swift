//
//  File.swift
//  BVISION
//
//  Created by patrick on 2018/4/30.
//  Copyright © 2018 wiatec. All rights reserved.
//



import Foundation
import Alamofire
import SwiftyJSON


protocol UserFriendProviderDelegate {
    func loadSuccess(userInfos: [UserInfo])
    func loadFailure(_ message: String, _ error: Error?)
}

class UserFriendProvider {
    
    var loadDelegate: UserFriendProviderDelegate?
    
    func load(_ userId: Int){
        if userId <= 0 {return}
        let url = "\(Constant.url_friends)\(userId)"
        Alamofire.request(url, method: .get)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    if(result[Constant.code].intValue == 200){
                        var userInfos = [UserInfo]()
                        let dataList = result[Constant.data_list]
                        for i in 0..<dataList.count {
                            userInfos.append(UserInfo(dataList[i]))
                        }
                        self.loadDelegate?.loadSuccess(userInfos: userInfos)
                    }else{
                        self.loadDelegate?.loadFailure(result[Constant.msg].stringValue, nil)
                    }
                case .failure(let error):
                    self.loadDelegate?.loadFailure(error.localizedDescription, error)
                }
        }
    }
}
