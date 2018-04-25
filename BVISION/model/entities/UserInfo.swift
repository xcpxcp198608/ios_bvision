//
//  UserInfo.swift
//  blive
//
//  Created by patrick on 17/12/2017.
//  Copyright © 2017 许程鹏. All rights reserved.
//

import SwiftyJSON

struct UserInfo {
    var id: Int = 0
    var username: String = ""
    var password :String = ""
    var email: String = ""
    var phone: String = ""
    var icon: String = ""
    var level: Int = 0
    var gender: Int = 1
    var profile: String = ""
    var status: Bool = false
    var publisher: Bool = false
    var token: String = ""
    var registerTime: String = ""
    
    
    init(_ jsonData: JSON){
        id = jsonData["id"].intValue
        level = jsonData["level"].intValue
        gender = jsonData["gender"].intValue
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
    }
}
