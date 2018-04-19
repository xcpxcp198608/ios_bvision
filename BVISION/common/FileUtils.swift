//
//  FileUtils.swift
//  blive
//
//  Created by patrick on 30/03/2018.
//  Copyright © 2018 许程鹏. All rights reserved.
//

import Foundation

class FileUtils {
    
    static func getDocmentsPath() -> String{
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
    
    static func isDicExists(_ dicName: String) -> Bool{
        let path = "\(getDocmentsPath())/\(dicName)"
        return FileManager.default.fileExists(atPath: path)
    }
    
    static func createDic(_ dicName: String) -> String{
        let path = "\(getDocmentsPath())/\(dicName)"
        if isDicExists(dicName){
            return path
        }
        do{
        try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
        }catch{
            print("dic create failure")
        }
        return path
    }
    
    static func deleteDic(_ dicName: String) -> Bool{
        var isSuccess = false
        let path = "\(getDocmentsPath())/\(dicName)"
        do{
            try FileManager.default.removeItem(atPath: path)
            isSuccess = true
        }catch{
            print("dic create failure")
        }
        return isSuccess
    }
    
    
    static func isExists(_ filePath: String) -> Bool{
        return FileManager.default.fileExists(atPath: filePath)
    }
    
    static func createFile(_ filePath: String) -> Bool{
        return createFile(filePath, contents: nil)
    }
    
    static func createFile(_ filePath: String, contents data: Data?) -> Bool{
        do{
            try FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
        }catch{
            print("dic create failure")
            return false
        }
        return  true
    }
    
    
    static func deleteFile(_ filePath: String) -> Bool{
        do{
            try FileManager.default.removeItem(atPath: filePath) }
        catch{
            print("dic create failure")
            return false
        }
        return true
    }
}
