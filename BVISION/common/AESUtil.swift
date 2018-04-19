//
//  AESUtil.swift
//  blive
//
//  Created by patrick on 18/03/2018.
//  Copyright © 2018 许程鹏. All rights reserved.
//

import Foundation
import CryptoSwift


class AESUtil: NSObject {
    
    static let KEY = "www.wiatec.com".md5();
    static let IV = "1269571569321021";
    
    static func encrypt(_ s: String) -> String? {
        do {
            let aes = try AES(key: KEY.bytes, blockMode: .CBC(iv: IV.bytes), padding: .pkcs5)
            let encrypted = try aes.encrypt(s.bytes)
            return encrypted.toHexString()
        } catch {
            return ""
        }
    }
    
    static func decrypt(_ hexString: String) -> String? {
        do {
            let aes = try AES(key: KEY.bytes, blockMode: .CBC(iv: IV.bytes), padding: .pkcs5)
            let s = bytes(from: hexString)
            let decrypted = try aes.decrypt(s)
            let result = String(data: Data(decrypted), encoding: .utf8)
            return result!
        } catch {
            return ""
        }
    }
    
    
    static func bytes(from hexStr: String) -> [UInt8] {
        assert(hexStr.count % 2 == 0, "输入字符串格式不对，8位代表一个字符")
        var bytes = [UInt8]()
        var sum = 0
        // 整形的 utf8 编码范围
        let intRange = 48...57
        // 小写 a~f 的 utf8 的编码范围
        let lowercaseRange = 97...102
        // 大写 A~F 的 utf8 的编码范围
        let uppercasedRange = 65...70
        for (index, c) in hexStr.utf8CString.enumerated() {
            var intC = Int(c.byteSwapped)
            if intC == 0 {
                break
            } else if intRange.contains(intC) {
                intC -= 48
            } else if lowercaseRange.contains(intC) {
                intC -= 87
            } else if uppercasedRange.contains(intC) {
                intC -= 55
            } else {
                assertionFailure("输入字符串格式不对，每个字符都需要在0~9，a~f，A~F内")
            }
            sum = sum * 16 + intC
            if index % 2 != 0 {
                bytes.append(UInt8(sum))
                sum = 0
            }
        }
        return bytes
    }
    
    
}



