//
//  CoinBillInfo.swift
//  BVISION
//
//  Created by patrick on 2018/4/27.
//  Copyright © 2018 wiatec. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CoinBillInfo {
    var action: Int = 0
    var coin: Int = 0
    var amount: Double = 0
    var platform: String = ""
    var description: String = ""
    var createTime: String = ""
    
    init(_ jsonData: JSON){
        action = jsonData["action"].intValue
        coin = jsonData["coin"].intValue
        amount = jsonData["amount"].doubleValue
        platform = jsonData["platform"].stringValue
        description = jsonData["description"].stringValue
        createTime = jsonData["createTime"].stringValue
    }
}
