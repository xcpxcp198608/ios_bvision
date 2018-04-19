//
//  TimeUtil.swift
//  blive
//
//  Created by patrick on 12/03/2018.
//  Copyright © 2018 许程鹏. All rights reserved.
//

import Foundation

class TimeUtil{
    
    
    static func getUnixTimestamp() -> Int{
        let now = NSDate()
        return Int(now.timeIntervalSince1970)
    }
    
    static func getTime(from timeStamp: Int) -> String{
        let timeInterval:TimeInterval = TimeInterval(timeStamp)
        let date = NSDate(timeIntervalSince1970: timeInterval) as Date
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let time = dateformatter.string(from: date)
        return time
    }
    
    static func getDate(from dateString: String) -> Date?{
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "en_US")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: dateString)
        return date
    }
    
    static func getDateString(from date: Date) -> String?{
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "en_US")
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: date)
        return date.components(separatedBy: " ").first!
    }
    
    static func getTimeString(from date: Date) -> String?{
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "en_US")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.string(from: date)
        return date.components(separatedBy: " ").first!
    }
    
    static func getMediaTime(from seconds: Int) -> String{
        if seconds <= 0{
            return "00:00"
        }
        var min = Int(seconds / 60)
        let sec = Int(seconds % 60)
        var hour = 0
        if min >= 60 {
            hour = Int(min / 60)
            min = min - hour*60
            return String(format: "%02d:%02d:%02d", hour, min, sec)
        }
        return String(format: "00:%02d:%02d", min, sec)
    }
    
    static func getSeconds(from mediaTime: String) -> Int{
//        if mediaTime.isEmpty {
//            return 0
//        }
//
//        let timeArry = mediaTime.replacingOccurrences(of: "：", with: ":").components(separatedBy: ":")
//        var seconds:Int = 0
//
//        if timeArry.count > 0 && isPurnInt(string: timeArry[0]){
//            let hh = Int(timeArry[0])
//            if hh! > 0 {
//                seconds += hh!*60*60
//            }
//        }
//        if timeArry.count > 1 && isPurnInt(string: timeArry[1]){
//            let mm = Int(timeArry[1])
//            if mm! > 0 {
//                seconds += mm!*60
//            }
//        }
//
//        if timeArry.count > 2 && isPurnInt(string: timeArry[2]){
//            let ss = Int(timeArry[2])
//            if ss! > 0 {
//                seconds += ss!
//            }
//        }
//
//        return seconds
        return 0
    }
    
}
