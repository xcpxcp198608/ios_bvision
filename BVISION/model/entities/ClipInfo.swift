//
//  ClipInfo.swift
//  BVISION
//
//  Created by patrick on 2018/4/27.
//  Copyright © 2018 wiatec. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ClipInfo {
    var id: Int = 0
    var title: String = ""
    var category: String = ""
    var action: Int = 0
    var flag: Int = 0
    var visible: Bool = false
    
    init(_ jsonData: JSON){
        id = jsonData["id"].intValue
        title = jsonData["title"].stringValue
        category = jsonData["category"].stringValue
        action = jsonData["action"].intValue
        flag = jsonData["flag"].intValue
        visible = jsonData["visible"].boolValue
    }
}
