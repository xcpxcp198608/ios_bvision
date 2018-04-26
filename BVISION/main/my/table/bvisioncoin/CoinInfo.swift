//
//  CoinInfo.swift
//  BVISION
//
//  Created by patrick on 2018/4/26.
//  Copyright © 2018 wiatec. All rights reserved.
//

import Foundation

struct CoinInfo {
    
    var name: String = ""
    var identifier: String = ""
    var number: Int = 0
    var amount: Double = 0.00
    
    
    static let names = ["B·VISION COIN 100", "B·VISION COIN 200", "B·VISION COIN 500", "B·VISION COIN 1000", "B·VISION COIN 5000", "B·VISION COIN 10000"]
    static let identifiers = ["com.legacy.bvision.bc100", "com.legacy.bvision.bc200", "com.legacy.bvision.bc500", "com.legacy.bvision.bc1000", "com.legacy.bvision.bc5000", "com.legacy.bvision.bc10000"]
    static let amounts = [9.99, 18.99, 48.99, 94.99, 449.99, 899.99]
    static let numbers = [100, 200, 500, 1000, 5000, 10000]
    
    static func generate() -> [CoinInfo]{
        var coins = [CoinInfo]()
        for i in 0..<names.count {
            var coin = CoinInfo()
            coin.name = names[i]
            coin.identifier = identifiers[i]
            coin.number = numbers[i]
            coin.amount = amounts[i]
            coins.append(coin)
        }
        return coins
    }
    
    static func getIdentifiers() -> [String]{
        return identifiers
    }
}
