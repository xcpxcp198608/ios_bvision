//
//  UFUtils.swift
//  blive
//
//  Created by patrick on 2018/4/3.
//  Copyright © 2018 许程鹏. All rights reserved.
//

import Foundation

class UFUtils{
    
    static let userDefaults = UserDefaults.standard
    
    static func set(_ value: Any?, key: String){
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }
    
    static func getString(_ key: String) -> String?{
        return userDefaults.string(forKey: key)
    }
    
    static func getInt(_ key: String) -> Int{
        return userDefaults.integer(forKey: key)
    }
    
    static func getFloat(_ key: String) -> Float{
        return userDefaults.float(forKey: key)
    }
    
    static func getBool(_ key: String) -> Bool{
        return userDefaults.bool(forKey: key)
    }
    
    
    static func remove(_ key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    static func clean(){
        let dics = userDefaults.dictionaryRepresentation()
        for key in dics{
            userDefaults.removeObject(forKey: key.key)
        }
        userDefaults.synchronize()
    }
    
}
