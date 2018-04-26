//
//  UserGetCoinBillProvider.swift
//  BVISION
//
//  Created by patrick on 2018/4/27.
//  Copyright © 2018 wiatec. All rights reserved.
//

import Foundation

import Foundation
import Alamofire
import SwiftyJSON

protocol UserGetCoinsBillProviderDelegate {
    func loadSuccess(coinBillInfos: [CoinBillInfo])
    func loadFailure(_ message: String, _ error: Error?)
}

class UserGetCoinsBillProvider {
    
    var loadDelegate: UserGetCoinsBillProviderDelegate?
    
    func load(_ userId: Int){
        if userId <= 0 {return}
        let url = "\(Constant.url_coin_bill)\(userId)"
        Alamofire.request(url, method: .get)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    if(result["code"].intValue == 200){
                        var coinBillInfos = [CoinBillInfo]()
                        let dataList = result["dataList"]
                        for i in 0..<dataList.count {
                            coinBillInfos.append(CoinBillInfo(dataList[i]))
                        }
                        self.loadDelegate?.loadSuccess(coinBillInfos: coinBillInfos)
                    }else{
                        self.loadDelegate?.loadFailure(result["message"].stringValue, nil)
                    }
                case .failure(let error):
                    self.loadDelegate?.loadFailure(error.localizedDescription, error)
                }
        }
    }
}
