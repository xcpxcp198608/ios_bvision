//
//  ChannelsProvider.swift
//  blive
//
//  Created by patrick on 13/03/2018.
//  Copyright © 2018 许程鹏. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol LiveChannelProviderDelegate {
    func loadSuccess(_ liveChannelInfos: [LiveChannelInfo])
    func loadFailure(_ message: String, _ error: Error?)
}


class LiveChannelProvider{
    
    var delegate: LiveChannelProviderDelegate?
    
    func load(){
        Alamofire.request(Constant.url_channel_living, method: .get)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    if result.count <= 0 {
                        self.delegate?.loadFailure("no data", nil)
                        return
                    }
                    var liveChannelInfos = [LiveChannelInfo]()
                    for i in 0..<result.count {
                        let liveChannelInfo = LiveChannelInfo(result[i])
                        liveChannelInfos.append(liveChannelInfo)
                    }
                    self.delegate?.loadSuccess(liveChannelInfos)
                case .failure(let error):
                    self.delegate?.loadFailure(error.localizedDescription, error)
                }
        }
        
    }
    
    
}
