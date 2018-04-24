//
//  InputDialogViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/24.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit

class InputDialogViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }

}

extension InputDialogViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
}
