//
//  ContactInfo.swift
//  BVISION
//
//  Created by patrick on 2018/4/25.
//  Copyright © 2018 wiatec. All rights reserved.
//

import SwiftyJSON

struct ContactInfo {
    
    var firstName: String = ""
    var lastName :String = ""
    var phones = [String]()
    var emails = [String]()
    var bvision: Bool = false
    var followed: Bool = false
    
}
