//
//  UserOperationInfo.swift
//  BVISION
//
//  Created by patrick on 2018/4/23.
//  Copyright © 2018 wiatec. All rights reserved.
//

import SwiftyJSON

struct UserOperationInfo {
    var userId: Int = 0
    var type :Int = 0
    var description: String = ""
    var createTime: String = ""
    
    
    init(_ jsonData: JSON){
        userId = jsonData["userId"].intValue
        type = jsonData["type"].intValue
        description = jsonData["description"].stringValue
        createTime = jsonData["createTime"].stringValue
    }
}
