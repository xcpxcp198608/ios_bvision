//
//  ImageAdInfo.swift
//  BVISION
//
//  Created by patrick on 2018/4/27.
//  Copyright © 2018 wiatec. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ImageAdInfo {
    var id: Int = 0
    var position: Int = 0
    var name: String = ""
    var title: String = ""
    var url: String = ""
    var link: String = ""
    var action: Int = 0
    var flag: Int = 0
    var visible: Bool = false
    
    init(_ jsonData: JSON){
        id = jsonData["id"].intValue
        position = jsonData["position"].intValue
        name = jsonData["name"].stringValue
        title = jsonData["title"].stringValue
        url = jsonData["url"].stringValue
        link = jsonData["link"].stringValue
        action = jsonData["action"].intValue
        flag = jsonData["flag"].intValue
        visible = jsonData["visible"].boolValue
    }
}
