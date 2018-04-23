//
//  SplashViewController.swift
//  blive
//
//  Created by patrick on 19/12/2017.
//  Copyright © 2017 许程鹏. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import CoreData

class SplashViewController: UIViewController{
    
    
    lazy var userChannelProvider = {
        return UserChannelProvider()
    }()
    
    
    override func viewDidAppear(_ animated: Bool) {
        userChannelProvider.loadDelegate = self
        let username: String? = UFUtils.getString(Constant.key_username)
        let token: String? = UFUtils.getString(Constant.key_token)
        if let name = username, let toke = token {
            if userId > 0 && name.count > 0 && toke.count > 0{
                validateToken(toke, userId)
            }else{
                self.showSignBoard()
            }
        }else{
            self.showSignBoard()
        }
    }
    
    
    func validateToken(_ token: String, _ userId: Int){
        Alamofire.request("\(Constant.url_token_validate)\(userId)/\(token)", method: .post)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success:
                    let result = JSON(data: response.data!)
                    if(result["code"].intValue == 200){
                        self.userChannelProvider.load(userId)
                    }else{
                        self.cleanUserData()
                        self.showSignBoard()
                    }
                case .failure(let error):
                    print(error)
                    self.showMainBoard()
                }
        }
    }
    
    func cleanUserData(){
        UFUtils.clean()
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
}


extension SplashViewController: UserChannelProviderDelegate{
    
    func loadSuccess(_ liveChannelInfo: LiveChannelInfo) {
        self.showMainBoard()
    }
    
    func loadFailure(_ message: String, _ error: Error?) {
        print(error)
        self.showMainBoard()
    }
    
    
}
