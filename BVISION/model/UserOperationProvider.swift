//
//  UserOperationProvider.swift
//  BVISION
//
//  Created by patrick on 2018/4/23.
//  Copyright © 2018 wiatec. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol UserOperationProviderDelegate {
    func loadSuccess(_ userOperationInfos: [UserOperationInfo])
    func loadFailure(_ message: String, _ error: Error?)
}

class UserOperationProvider {
    
    var loadDelegate: UserOperationProviderDelegate?
    
    func load(_ userId: Int){
        if userId <= 0 {return}
        let url = "\(Constant.url_user_operations)\(userId)"
        Alamofire.request(url, method: .get)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    if(result[Constant.code].intValue == 200){
                        let dataList = result[Constant.data_list]
                        var userOperationInfos = [UserOperationInfo]()
                        for i in 0..<dataList.count {
                            userOperationInfos.append(UserOperationInfo(dataList[i]))
                        }
                        self.loadDelegate?.loadSuccess(userOperationInfos)
                    }else{
                        self.loadDelegate?.loadFailure(result[Constant.msg].stringValue, nil)
                    }
                case .failure(let error):
                    self.loadDelegate?.loadFailure(error.localizedDescription, error)
                }
        }
    }
}
