//
//  ImageAdProvider.swift
//  BVISION
//
//  Created by patrick on 2018/4/27.
//  Copyright © 2018 wiatec. All rights reserved.
//


import Foundation
import SwiftyJSON
import Alamofire

protocol ImageAdProviderDelegate {
    func loadSuccess(_ imageAdInfos: [ImageAdInfo])
    func loadFailure(_ message: String, _ error: Error?)
}


class ImageAdProvider{
    
    var delegate: ImageAdProviderDelegate?
    
    func load(position: Int){
        Alamofire.request("\(Constant.url_images_ad)\(position)", method: .get)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    if result["code"].intValue != 200 {
                        self.delegate?.loadFailure(result["message"].stringValue, nil)
                        return
                    }
                    let dataList = result["dataList"]
                    var imageAdInfos = [ImageAdInfo]()
                    for i in 0..<dataList.count {
                        imageAdInfos.append(ImageAdInfo(dataList[i]))
                    }
                    self.delegate?.loadSuccess(imageAdInfos)
                case .failure(let error):
                    self.delegate?.loadFailure(error.localizedDescription, error)
                }
        }
        
    }
    
}
