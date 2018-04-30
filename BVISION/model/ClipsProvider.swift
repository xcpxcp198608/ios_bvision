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

protocol ClipsProviderDelegate {
    func loadSuccess(_ clipInfos: [ClipInfo])
    func loadFailure(_ message: String, _ error: Error?)
}


class ClipsProvider{
    
    var delegate: ClipsProviderDelegate?
    
    func load(){
        Alamofire.request(Constant.url_clips, method: .get)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    if result[Constant.code].intValue != 200 {
                        self.delegate?.loadFailure(result[Constant.msg].stringValue, nil)
                        return
                    }
                    let dataList = result[Constant.data_list]
                    var clipInfos = [ClipInfo]()
                    for i in 0..<dataList.count {
                        clipInfos.append(ClipInfo(dataList[i]))
                    }
                    self.delegate?.loadSuccess(clipInfos)
                case .failure(let error):
                    self.delegate?.loadFailure(error.localizedDescription, error)
                }
        }
        
    }
    
}
