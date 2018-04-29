//
//  TrendingProvider.swift
//  BVISION
//
//  Created by patrick on 2018/4/28.
//  Copyright © 2018 wiatec. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


protocol TrendingProviderDelegate {
    func loadSuccess(trendingInfos: [TrendingInfo])
    func loadFailure(_ message: String, _ error: Error?)
}

class TrendingProvider {
    
    var loadDelegate: TrendingProviderDelegate?
    
    func load(_ userId: Int, start: Int){
        if userId <= 0 {return}
        let url = "\(Constant.url_trending)\(userId)/\(start)"
        Alamofire.request(url, method: .get)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    if(result[Constant.code].intValue == 200){
                        var trendingInfos = [TrendingInfo]()
                        let dataList = result[Constant.data_list]
                        for i in 0..<dataList.count {
                            trendingInfos.append(TrendingInfo(dataList[i]))
                        }
                        self.loadDelegate?.loadSuccess(trendingInfos: trendingInfos)
                    }else{
                        self.loadDelegate?.loadFailure(result[Constant.msg].stringValue, nil)
                    }
                case .failure(let error):
                    self.loadDelegate?.loadFailure(error.localizedDescription, error)
                }
        }
    }
}
