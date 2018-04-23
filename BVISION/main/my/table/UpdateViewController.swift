//
//  UpdateViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/18.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import JGProgressHUD

class UpdateViewController: BasicTableViewController, UITextFieldDelegate {

    @IBOutlet weak var tfOldPassword: UITextField!
    @IBOutlet weak var tfNewPassword: UITextField!
    @IBOutlet weak var tfNewPassword1: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)
        tfOldPassword.delegate = self
        tfNewPassword.delegate = self
        tfNewPassword1.delegate = self
        tfOldPassword.becomeFirstResponder()
    }
    
    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        tfOldPassword.resignFirstResponder()
        tfNewPassword.resignFirstResponder()
        tfNewPassword1.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfOldPassword {
            tfNewPassword.becomeFirstResponder()
            return false
        }
        if textField == tfNewPassword {
            tfNewPassword1.becomeFirstResponder()
            return false
        }
        if textField == tfNewPassword1 {
            tfNewPassword1.resignFirstResponder()
            updatePassword()
            return false
        }
        return true
    }
    
    func updatePassword(){
        let userId = UserDefaults.standard.integer(forKey: Constant.key_user_id)
        if userId <= 0 {return}
        if let oldPassword = tfOldPassword.text, let newPassword = tfNewPassword.text, let newPassword1 = tfNewPassword1.text {
            if oldPassword.count < 6 {
                hudError(with: "old password format error")
                return
            }
            if (newPassword.count < 6 || newPassword1.count < 6) {
                 hudError(with: "new password format error")
                return
            }
            if newPassword != newPassword1 {
                 hudError(with: "two input password must be consistent")
                return
            }
            let hud = hudLoading()
            let parameters = ["oldPassword": oldPassword, "newPassword": newPassword] as [String : Any]
            let url = "\(Constant.url_user_update_pw)\(userId)"
            Alamofire.request(url, method: .post, parameters: parameters)
                .validate()
                .responseData { (response) in
                    hud.dismiss()
                    switch response.result {
                    case .success:
                        let result = JSON(data: response.data!)
                        print(result)
                        if(result["code"].intValue == 200){
                            self.hudSuccess(with: result["message"].stringValue)
                            self.tfOldPassword.text = ""
                            self.tfNewPassword.text = ""
                            self.tfNewPassword1.text = ""
                        }else{
                            self.hudError(with: result["message"].stringValue)
                        }
                    case .failure(let error):
                        self.hudError(with: error.localizedDescription)
                    }
            }
        }
    }
    
    
    @IBAction func done(){
        tfNewPassword1.resignFirstResponder()
        updatePassword()
    }


}
