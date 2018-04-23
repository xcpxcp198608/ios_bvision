//
//  UserChannelProvider.swift
//  BVISION
//
//  Created by patrick on 2018/4/23.
//  Copyright © 2018 wiatec. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol UserChannelProviderDelegate {
    func loadSuccess(_ liveChannelInfo: LiveChannelInfo)
    func loadFailure(_ message: String, _ error: Error?)
}

class UserChannelProvider {
    
    var loadDelegate: UserChannelProviderDelegate?
    
    func load(_ userId: Int){
        if userId <= 0 {return}
        let url = "\(Constant.url_channel)\(userId)"
        Alamofire.request(url, method: .get)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    if(result["code"].intValue == 200){
                        let liveChannelInfo = LiveChannelInfo(result["data"])
                        UFUtils.set(liveChannelInfo.title, key: Constant.key_channel_title)
                        UFUtils.set(liveChannelInfo.message, key: Constant.key_channel_message)
                        UFUtils.set(liveChannelInfo.price, key: Constant.key_channel_price)
                        UFUtils.set(liveChannelInfo.rating, key: Constant.key_channel_rating)
                        UFUtils.set(liveChannelInfo.url, key: Constant.key_channel_push_url)
                        UFUtils.set(liveChannelInfo.playUrl, key: Constant.key_channel_play_url)
                        UFUtils.set(liveChannelInfo.preview, key: Constant.key_channel_preview)
                        UFUtils.set(liveChannelInfo.link, key: Constant.key_channel_link)
                        self.loadDelegate?.loadSuccess(liveChannelInfo)
                    }else{
                        self.loadDelegate?.loadFailure(result["message"].stringValue, nil)
                    }
                case .failure(let error):
                    self.loadDelegate?.loadFailure(error.localizedDescription, error)
                }
        }
    }
}
