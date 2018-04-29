//
//  MyGroupProvider.swift
//  BVISION
//
//  Created by patrick on 2018/4/28.
//  Copyright © 2018 wiatec. All rights reserved.
//


import Foundation
import Alamofire
import SwiftyJSON

protocol MyGroupsProviderDelegate {
    func loadSuccess(groupInfos: [GroupInfo])
    func loadFailure(_ message: String, _ error: Error?)
}

class MyGroupsProvider {
    
    var loadDelegate: MyGroupsProviderDelegate?
    
    func load(_ userId: Int){
        if userId <= 0 {return}
        let url = "\(Constant.url_groups)\(userId)"
        Alamofire.request(url, method: .get)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    if(result[Constant.code].intValue == 200){
                        var groupInfos = [GroupInfo]()
                        let dataList = result[Constant.data_list]
                        for i in 0..<dataList.count {
                            groupInfos.append(GroupInfo(dataList[i]))
                        }
                        self.loadDelegate?.loadSuccess(groupInfos: groupInfos)
                    }else{
                        self.loadDelegate?.loadFailure(result[Constant.msg].stringValue, nil)
                    }
                case .failure(let error):
                    self.loadDelegate?.loadFailure(error.localizedDescription, error)
                }
        }
    }
}
