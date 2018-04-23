//
//  UserSignInViewController.swift
//  blive
//
//  Created by patrick on 07/03/2018.
//  Copyright © 2018 许程鹏. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView
import JGProgressHUD

class UserSignInViewController: UIViewController, UITextFieldDelegate{
    
    lazy var userChannelProvider = {
        return UserChannelProvider()
    }()
    
    var signInTableView: UserSignInTableViewController?
    @IBOutlet weak var btSignIn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidLoad() {
        userChannelProvider.loadDelegate = self
        let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
        statusBarWindow.isHidden = false
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sign_in" {
            signInTableView = segue.destination as? UserSignInTableViewController
        }
    }
    
    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        signInTableView?.hideKeyboard(gestureRecognizer)
    }
    
    @IBAction func skip(){
        showMainBoard()
    }
    
    func enableButton(){
        btSignIn.isUserInteractionEnabled = true
        btSignIn.isEnabled = true
    }
    
    func disableButton(){
        btSignIn.isUserInteractionEnabled = false
        btSignIn.isEnabled = false
    }
    
    
    @IBAction func siginIn(){
        if let username: String = signInTableView?.tfUsername.text, let password: String = signInTableView?.tfPassword.text {
            if(username.count <= 0){
                self.alertError(message: "username type in error")
                return
            }
            if(password.count <= 0){
                alertError(message: "password type in error")
                return
            }
            let hud = hudLoading()
            btSignIn.backgroundColor = UIColor(rgb: Color.disable, alpha: 1.0)
            
            let deviceModel: String = UIDevice.current.model
            let sysVersion: String = UIDevice.current.systemVersion
            let deviceUUID: String = (UIDevice.current.identifierForVendor?.uuidString)!
            
            let parameters = ["username": username, "password": password,
                              "deviceModel": deviceModel, "romVersion": sysVersion,
                              "uiVersion": deviceUUID]
            self.disableButton()
            Alamofire.request(Constant.url_user_signin, method: .post, parameters: parameters)
                .validate()
                .responseData { (response) in
                    switch response.result {
                    case .success:
                        let result = JSON(data: response.data!)
                        if(result["code"].intValue == 200){
                            let userInfo = UserInfo(result["data"])
                            UFUtils.set(userInfo.id, key: Constant.key_user_id)
                            UFUtils.set(userInfo.username, key: Constant.key_username)
                            UFUtils.set(userInfo.icon, key: Constant.key_user_icon)
                            UFUtils.set(userInfo.token, key: Constant.key_token)
                            UFUtils.set(userInfo.level, key: Constant.key_user_level)
                            self.userChannelProvider.load(userInfo.id)
                        }else{
                            self.alertError(message: result["message"].stringValue)
                            self.enableButton()
                        }
                    case .failure(let error):
                        self.alertError(message: error.localizedDescription)
                        self.enableButton()
                    }
                    self.btSignIn.backgroundColor = UIColor(rgb: Color.primary, alpha: 1.0)
                    hud.dismiss()
            }
        }
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
}


extension UserSignInViewController: UserChannelProviderDelegate{
    
    func loadSuccess(_ liveChannelInfo: LiveChannelInfo) {
        self.showMainBoard()
    }
    
    func loadFailure(_ message: String, _ error: Error?) {
        print(error)
        self.showMainBoard()
    }
    
    
}
