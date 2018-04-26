//
//  Functions.swift
//  blive
//
//  Created by patrick on 20/12/2017.
//  Copyright © 2017 许程鹏. All rights reserved.
//


import Foundation
import Dispatch


/**
 * 主线程延时任务，阻塞主线程在指定seconds后执行closure中的代码
 * eg:
 * afterDelay(0.6) {
 *   self.dismiss(animated: true, completion: nil)
 * }
 */
func afterDelay(_ seconds: Double, closure: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: closure)
}


// 获取系统文件 documents 路径
let documentsDirectory: URL = {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
}()

// core data save error notification
let MyManagedObjectContextSaveDidFailNotification = Notification.Name(
    rawValue: "MyManagedObjectContextSaveDidFailNotification")
func fatalCoreDataError(_ error: Error) {
    print("*** Fatal error: \(error)")
    NotificationCenter.default.post(
        name: MyManagedObjectContextSaveDidFailNotification, object: nil)
}

var userId: Int{
    get{
        return UFUtils.getInt(Constant.key_user_id)
    }
    set(id){
        UFUtils.set(id, key: Constant.key_user_id)
    }
}

var userCoins: Int{
    get{
        return UFUtils.getInt(Constant.key_user_coins)
    }
    set(coins){
        UFUtils.set(coins, key: Constant.key_user_coins)
    }
}

var userLevel: Int{
    get{
        return UFUtils.getInt(Constant.key_user_level)
    }
    set(level){
        UFUtils.set(level, key: Constant.key_user_level)
    }
}
