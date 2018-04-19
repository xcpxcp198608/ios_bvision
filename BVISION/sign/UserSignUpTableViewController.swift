//
//  UserSignUpTableViewController.swift
//  blive
//
//  Created by patrick on 07/03/2018.
//  Copyright © 2018 许程鹏. All rights reserved.
//

import UIKit

class UserSignUpTableViewController: UITableViewController, UITextFieldDelegate{
    
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        tfUsername.delegate = self
        tfEmail.delegate = self
        tfPhone.delegate = self
        tfPassword.delegate = self
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        tfUsername.resignFirstResponder()
        tfEmail.resignFirstResponder()
        tfPhone.resignFirstResponder()
        tfPassword.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfUsername {
            tfEmail.becomeFirstResponder()
            return false
        }
        if textField == tfEmail {
            tfPhone.becomeFirstResponder()
            return false
        }
        if textField == tfPhone {
            tfPassword.becomeFirstResponder()
            return false
        }
        if textField == tfPassword {
            tfPassword.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " "{
            return false
        }
        return true
    }
    
}
