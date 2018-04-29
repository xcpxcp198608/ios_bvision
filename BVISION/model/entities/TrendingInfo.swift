//
//  TrendingInfo.swift
//  BVISION
//
//  Created by patrick on 2018/4/28.
//  Copyright © 2018 wiatec. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TrendingInfo {
    var id: Int = 0
    var userId: Int = 0
    var username: String = ""
    var icon: String = ""
    var content: String = ""
    var imgIndex: Int = 0
    var imgCount: Int = 0
    var imgUrl: String = ""
    var link: String = ""
    var createTime: String = ""
    
    init(_ jsonData: JSON){
        id = jsonData["id"].intValue
        userId = jsonData["userId"].intValue
        username = jsonData["username"].stringValue
        icon = jsonData["icon"].stringValue
        content = jsonData["content"].stringValue
        imgIndex = jsonData["imgIndex"].intValue
        imgCount = jsonData["imgCount"].intValue
        imgUrl = jsonData["imgUrl"].stringValue
        link = jsonData["link"].stringValue
        createTime = jsonData["createTime"].stringValue
    }
}
