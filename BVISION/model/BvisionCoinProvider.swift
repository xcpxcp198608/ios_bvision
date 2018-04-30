//
//  BvisionCoinProvider.swift
//  BVISION
//
//  Created by patrick on 2018/4/24.
//  Copyright © 2018 wiatec. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol BvisionCoinProviderDelegate {
    func loadSuccess(_ number: Int)
    func loadFailure(_ message: String, _ error: Error?)
}

class BvisionCoinProvider {
    
    var loadDelegate: BvisionCoinProviderDelegate?
    
    func load(_ userId: Int){
        if userId <= 0 {return}
        let url = "\(Constant.url_coin_get)\(userId)"
        Alamofire.request(url, method: .get)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    if(result[Constant.code].intValue == 200){
                        
                    }else{
                        self.loadDelegate?.loadFailure(result[Constant.msg].stringValue, nil)
                    }
                case .failure(let error):
                    self.loadDelegate?.loadFailure(error.localizedDescription, error)
                }
        }
    }
}
