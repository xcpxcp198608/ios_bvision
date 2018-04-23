//
//  UserBlacksProvider.swift
//  BVISION
//
//  Created by patrick on 2018/4/23.
//  Copyright © 2018 wiatec. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol UserBlacksProviderDelegate {
    func loadSuccess(_ blackListUserInfos: [BlackListUserInfo])
    func loadFailure(_ message: String, _ error: Error?)
}

class UserBlacksProvider {
    
    var loadDelegate: UserBlacksProviderDelegate?
    
    func load(_ userId: Int){
        if userId <= 0 {return}
        let url = "\(Constant.url_user_list_blacks)\(userId)"
        Alamofire.request(url, method: .get)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    if(result["code"].intValue == 200){
                        let dataList = result["dataList"]
                        var blackListUserInfos = [BlackListUserInfo]()
                        for i in 0..<dataList.count {
                            blackListUserInfos.append(BlackListUserInfo(dataList[i]))
                        }
                        self.loadDelegate?.loadSuccess(blackListUserInfos)
                    }else{
                        self.loadDelegate?.loadFailure(result["message"].stringValue, nil)
                    }
                case .failure(let error):
                    self.loadDelegate?.loadFailure(error.localizedDescription, error)
                }
        }
    }
}
