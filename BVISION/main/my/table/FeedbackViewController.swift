//
//  FeedbackViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/18.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import JGProgressHUD

class FeedbackViewController: BasicViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var tfSubject: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfSubject.becomeFirstResponder()
        tfSubject.delegate = self
        tvDescription.delegate = self
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func hideKeyboard(){
        tfSubject.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfSubject {
            tvDescription.becomeFirstResponder()
            return false
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n"){
            tvDescription.resignFirstResponder()
            return false;
        }
        return true;
    }
    
    @IBAction func sendFeedback(){
        self.submitFeedback()
    }
    

    
}

extension FeedbackViewController{
    
    func submitFeedback(){
        let userId = UserDefaults.standard.integer(forKey: Constant.key_user_id)
        if let subject = tfSubject.text,let description = tvDescription.text {
            if userId <= 0 {
                self.hudError(with: "no signin")
                return
            }
            if subject.count <= 0 || subject.count > 100 {
                self.hudError(with: "subject text length error")
                return
            }
            
            if description.count <= 0 {
                self.hudError(with: "description text length error")
                return
            }
            
            let parameters = ["userId": userId, "subject": subject,
                              "description": description] as [String : Any]
            print(parameters)
            let hud = self.hudLoading()
            Alamofire.request(Constant.url_user_feedback, method: .post, parameters: parameters)
                .validate()
                .responseData { (response) in
                    switch response.result {
                    case .success:
                        hud.dismiss()
                        let result = JSON(data: response.data!)
                        if(result["code"].intValue == 200){
                            self.hudSuccess(with: result["message"].stringValue)
                            self.tfSubject.text = ""
                            self.tvDescription.text = ""
                        }else{
                            self.hudError(with: result["message"].stringValue)
                        }
                    case .failure(let error):
                        hud.dismiss()
                        self.hudError(with: error.localizedDescription)
                    }
            }
        }
    }
}
