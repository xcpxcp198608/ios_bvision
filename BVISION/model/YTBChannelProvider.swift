//
//  YTBChannelProvider.swift
//  BVISION
//
//  Created by patrick on 2018/4/16.
//  Copyright © 2018 wiatec. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol YTBChannelProviderDelegate {
    func loadSuccess(_ liveChannelInfos: [YTBChannelInfo])
    func loadFailure(_ message: String, _ error: Error?)
}


class YTBChannelProvider{
    
    var delegate: YTBChannelProviderDelegate?
    
    func load(){
        Alamofire.request(Constant.url_channel, method: .get)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    if result.count <= 0 {
                        self.delegate?.loadFailure("no data", nil)
                        return
                    }
                case .failure(let error):
                    self.delegate?.loadFailure(error.localizedDescription, error)
                }
        }
        
    }
    
    
}
