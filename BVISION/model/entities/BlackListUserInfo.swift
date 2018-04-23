//
//  BlackListUserInfo.swift
//  BVISION
//
//  Created by patrick on 2018/4/23.
//  Copyright © 2018 wiatec. All rights reserved.
//


import SwiftyJSON

struct BlackListUserInfo {
    var id: Int = 0
    var userId: Int = 0
    var blackId :Int = 0
    var blackUsername: String = ""
    var createTime: String = ""
    
    
    init(_ jsonData: JSON){
        id = jsonData["id"].intValue
        userId = jsonData["userId"].intValue
        blackId = jsonData["blackId"].intValue
        blackUsername = jsonData["blackUsername"].stringValue
        createTime = jsonData["createTime"].stringValue
    }
}
