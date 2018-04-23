//
//  UserSignUpViewController.swift
//  blive
//
//  Created by patrick on 07/03/2018.
//  Copyright © 2018 许程鹏. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserSignUpViewController: UIViewController{
    
    var signUpTableView:UserSignUpTableViewController?
    @IBOutlet weak var btSignUp: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sign_up" {
            signUpTableView = segue.destination as? UserSignUpTableViewController
        }
    }
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        signUpTableView?.hideKeyboard(gestureRecognizer)
    }
    
    
    func enableButton(){
        btSignUp.isUserInteractionEnabled = true
        btSignUp.isEnabled = true
    }
    
    func disableButton(){
        btSignUp.isUserInteractionEnabled = false
        btSignUp.isEnabled = false
    }
    
    
    @IBAction func signUp() {
        if let username = signUpTableView?.tfUsername.text, let email = signUpTableView?.tfEmail.text, let phone = signUpTableView?.tfPhone.text, let password = signUpTableView?.tfPassword.text {
            if username.count <= 0 {
                self.alertError(message: "username input error")
                return
            }
            if email.count <= 0 {
                self.alertError(message: "email input error")
                return
            }
            let predicate = NSPredicate(format: "SELF MATCHES %@", Constant.regex_email)
            if !predicate.evaluate(with: email) {
                self.alertError(message: "email format error")
                return
            }
            if phone.count <= 8 {
                self.alertError(message: "phone input error")
                return
            }
            if password.count < 6 {
                self.alertError(message: "password count must >= 6")
                return
            }
            let parameters = ["username": username, "email": email, "phone": phone, "password": password]
            self.disableButton()
            let hud = hudLoading()
            self.btSignUp.backgroundColor = UIColor(rgb: Color.disable, alpha: 1.0)
            Alamofire.request(Constant.url_user_signup, method: .post, parameters: parameters)
                .validate()
                .responseData { (response) in
                    self.enableButton()
                    switch response.result {
                    case .success:
                        let result = JSON(data: response.data!)
                        if(result["code"].intValue == 200){
                            self.alertSuccess(message: result["message"].stringValue)
                        }else{
                            self.hudError(with: result["message"].stringValue)
                        }
                    case .failure(let error):
                        self.alertError(message: error.localizedDescription)
                    }
                    self.btSignUp.backgroundColor = UIColor(rgb: Color.primary, alpha: 1.0)
                    hud.dismiss()
            }
        }
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
}
