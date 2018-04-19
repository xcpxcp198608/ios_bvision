//
//  LiveChannelInfo.swift
//  BVISION
//
//  Created by patrick on 2018/4/16.
//  Copyright © 2018 wiatec. All rights reserved.
//

import SwiftyJSON

struct LiveChannelInfo {
    var id: Int = 0
    var userId: Int = 0
    var username: String = ""
    var rating: Int = 0
    var price: Float = 0
    var type: Int = 0
    var category: String = ""
    var preview: String = ""
    var title: String = ""
    var message: String = ""
    var startTime: String = ""
    var url: String = ""
    var playUrl: String = ""
    var link: String = ""
    var userIcon: String = ""
    var available: Bool = false
    
    init(_ jsonData: JSON) {
        id = jsonData["id"].intValue
        userId = jsonData["userId"].intValue
        username = jsonData["username"].stringValue
        rating = jsonData["rating"].intValue
        price = jsonData["price"].floatValue
        type = jsonData["type"].intValue
        category = jsonData["category"].stringValue
        preview = jsonData["preview"].stringValue
        title = jsonData["title"].stringValue
        message = jsonData["message"].stringValue
        startTime = jsonData["startTime"].stringValue
        url = jsonData["url"].stringValue
        playUrl = jsonData["playUrl"].stringValue
        link = jsonData["link"].stringValue
        userIcon = jsonData["userIcon"].stringValue
        available = jsonData["available"].boolValue
    }
}

func < (lhs: LiveChannelInfo, rhs: LiveChannelInfo) -> Bool {
    return lhs.title.localizedStandardCompare(rhs.title) == .orderedAscending
}

