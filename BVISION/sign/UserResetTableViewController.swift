//
//  UserResetTableViewController.swift
//  blive
//
//  Created by patrick on 07/03/2018.
//  Copyright © 2018 许程鹏. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserResetTableViewController: UITableViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var btReset: UIButton!
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        tfUsername.delegate = self
        tfEmail.delegate = self
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        tfUsername.resignFirstResponder()
        tfEmail.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfUsername {
            tfEmail.becomeFirstResponder()
            return false
        }
        if textField == tfEmail {
            reset()
            return false
        }
        return true
    }
    
    func enableButton(){
        btReset.isUserInteractionEnabled = true
        btReset.tintColor = UIColor(red: 25/255.0, green: 44/255.0, blue: 63/255.0, alpha: 0.0)
        btReset.isEnabled = true
    }
    
    func disableButton(){
        btReset.isUserInteractionEnabled = false
        btReset.tintColor = UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 0.0)
        btReset.isEnabled = false
    }
    
    @IBAction func reset(){
        tfEmail.resignFirstResponder()
        if let username = self.tfUsername.text, let email = self.tfEmail.text {
            if username.count <= 0 {
                self.alertError(message: NSLocalizedString("username type in error", comment: ""))
                return
            }
            if email.count <= 0 {
                self.alertError(message: NSLocalizedString("email input error", comment: ""))
                return
            }
            let parameters = ["username": username, "email": email]
            self.disableButton()
            let hud = hudLoading()
            Alamofire.request(Constant.url_user_reset, method: .post, parameters: parameters)
                .validate()
                .responseData { (response) in
                    self.enableButton()
                    switch response.result {
                    case .success:
                        let result = JSON(data: response.data!)
                        if(result["code"].intValue == 200){
                            self.hudSuccess(with: result["message"].stringValue)
                        }else{
                            self.alertError(message: result["message"].stringValue)
                        }
                    case .failure(let error):
                        self.alertError(message: error.localizedDescription)
                    }
                    hud.dismiss()
            }
        }
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
}
