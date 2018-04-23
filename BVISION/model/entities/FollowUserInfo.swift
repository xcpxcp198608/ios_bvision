//
//  FollowUserInfo.swift
//  BVISION
//
//  Created by patrick on 2018/4/23.
//  Copyright © 2018 wiatec. All rights reserved.
//

import SwiftyJSON

struct FollowUserInfo {
    var id: Int = 0
    var username: String = ""
    var password :String = ""
    var email: String = ""
    var phone: String = ""
    var icon: String = ""
    var level: Int = 0
    var profile: String = ""
    var status: Bool = false
    var publisher: Bool = false
    var token: String = ""
    var registerTime: String = ""
    var channelActive = false
    
    
    init(_ jsonData: JSON){
        id = jsonData["id"].intValue
        level = jsonData["level"].intValue
        username = jsonData["username"].stringValue
        password = jsonData["password"].stringValue
        email = jsonData["email"].stringValue
        phone = jsonData["phone"].stringValue
        icon = jsonData["icon"].stringValue
        profile = jsonData["profile"].stringValue
        status = jsonData["status"].boolValue
        publisher = jsonData["publisher"].boolValue
        token = jsonData["token"].stringValue
        registerTime = jsonData["registerTime"].stringValue
        channelActive = jsonData["channelActive"].boolValue
    }
}
