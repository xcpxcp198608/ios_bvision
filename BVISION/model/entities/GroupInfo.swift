//
//  GroupInfo.swift
//  BVISION
//
//  Created by patrick on 2018/4/28.
//  Copyright © 2018 wiatec. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GroupInfo {
    var groupId: Int = 0
    var ownerId: Int = 0
    var numbers: Int = 0
    var name: String = ""
    var description: String = ""
    var icon: String = ""
    var createTime: String = ""
    
    init(_ jsonData: JSON){
        groupId = jsonData["groupId"].intValue
        ownerId = jsonData["ownerId"].intValue
        numbers = jsonData["numbers"].intValue
        name = jsonData["name"].stringValue
        description = jsonData["description"].stringValue
        icon = jsonData["icon"].stringValue
        createTime = jsonData["createTime"].stringValue
    }
}
