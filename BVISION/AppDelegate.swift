//
//  AppDelegate.swift
//  BVISION
//
//  Created by patrick on 2018/4/13.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, JPUSHRegisterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        jpushInit(launchOptions)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    
    //MARK:- JPUSH
    //注册APNs成功并上报DeviceToken
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("极光注册失败",error.localizedDescription)
    }
    
    // iOS 9.0
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo);
        completionHandler(UIBackgroundFetchResult.newData);
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        JPUSHService.handleRemoteNotification(userInfo);
    }
    
    
    
    func jpushInit(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?){
        if #available(iOS 10.0, *) {
            let entity = JPUSHRegisterEntity()
            entity.types = Int(UNAuthorizationOptions.alert.rawValue|UNAuthorizationOptions.badge.rawValue|UNAuthorizationOptions.sound.rawValue)
            JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        }else {
            let types = UIUserNotificationType.badge.rawValue |
                UIUserNotificationType.sound.rawValue |
                UIUserNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: types, categories: nil)
        }
        JPUSHService.setup(withOption: launchOptions, appKey: "dc2b41f40b74d86e3508127b", channel: "App Store", apsForProduction: false)
        // 获取远程推送消息 iOS 10 已取消
        let remote = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? Dictionary<String,Any>;
        // 如果remote不为空，就代表应用在未打开的时候收到了推送消息
        if remote != nil {
            // 收到推送消息实现的方法
//            receivePush(remote!)
        }
        //自定义消息 需要自己在receiveNotification中自己实现消息的展示
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotification), name: NSNotification.Name.jpfNetworkDidReceiveMessage, object: nil)
    }
    
    @objc func receiveNotification(){
        
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }else {
            //本地通知
        }
        //需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }else {
            //本地通知
        }
        //处理通知 跳到指定界面等等
        receivePush(userInfo as! Dictionary<String, Any>)
        completionHandler()
    }
    
    func receivePush(_ userInfo : Dictionary<String, Any>) {
        print(userInfo)
        //根据服务器返回的字段判断
        //        let userInfo = userInfo["key"] as! String
        //        let jsonData:Data = userInfo.data(using: .utf8)!
        //        var dict = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! [String:AnyObject]
        //        let messageJson = JSON(dict ["data"]!)
        //        let message = Message.init(json: messageJson)
        //        if message.type == 2
        //        {
        //            let rootView = getRootViewController()
        //            rootView.pushViewController(MessageViewController.init(type: 2), animated: true)
        //        }
        // 角标变0
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    
    
    
    
    
    
    

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BVISION")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

