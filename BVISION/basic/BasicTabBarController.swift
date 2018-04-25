//
//  BasicTabBar.swift
//  BVISION
//
//  Created by patrick on 2018/4/13.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import PopupDialog
import Photos

class BasicTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    var userId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        let item = self.tabBar.items![2]
        item.image = item.image?.withRenderingMode(.alwaysOriginal)
        item.selectedImage = item.selectedImage?.withRenderingMode(.alwaysOriginal)
        item.imageInsets = UIEdgeInsets.init(top: 6, left: 0, bottom: -6, right: 0)
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == tabBarController.viewControllers![2]{
            userId = UFUtils.getInt(Constant.key_user_id)
            showPushAlertDialog()
            return false
        }
        return true
    }
    
    fileprivate func showPushAlertDialog(){
        let title = "CHOOSE ACTION"
        let message = ""
        let popup = PopupDialog(title: title, message: message)
        
        
        let buttonTwo = DefaultButton(title: "PUSH BY CAMERA", dismissOnTap: true) {
            self.requestAccessForVideo()
        }
        let buttonThree = DefaultButton(title: "PUSH BY LOCAL(PRO)", height: 60) {
            self.requestAccessForPhoto()
        }
        popup.addButtons([buttonTwo, buttonThree])
        
        
        let dialogAppearance = PopupDialogDefaultView.appearance()
        dialogAppearance.backgroundColor = UIColor(rgb: Color.accent)
        dialogAppearance.titleFont    = UIFont(name: "HelveticaNeue-Light", size: 16)!
        dialogAppearance.titleColor   = .white
        dialogAppearance.messageFont  = UIFont(name: "HelveticaNeue", size: 14)!
        dialogAppearance.messageColor = UIColor(white: 0.8, alpha: 1)
        
        
        let db = DefaultButton.appearance()
        db.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 14)!
        db.titleColor     = .white
        db.buttonColor    = UIColor(red:0.25, green:0.25, blue:0.29, alpha:1.00)
        db.separatorColor = UIColor(red:0.20, green:0.20, blue:0.25, alpha:1.00)
        
        buttonTwo.titleColor = .red
        
        self.present(popup, animated: true, completion: nil)
    }
    
}


extension BasicTabBarController{
    
    //MARK:- AccessAuth
    func requestAccessForVideo() -> Void {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video);
        switch status  {
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if(granted){
                    self.requestAccessForAudio()
                }
            })
            break;
        case AVAuthorizationStatus.authorized:
            self.requestAccessForAudio()
            break;
        case AVAuthorizationStatus.denied:
            showOpenAuthDialog("Camera permission denied, open setting -> B·VISION, turn on the Camera")
            break
        case AVAuthorizationStatus.restricted:
            showOpenAuthDialog("Camera permission denied, open setting -> B·VISION, turn on the Camera")
            break;
        }
    }
    
    func requestAccessForAudio() -> Void {
        let status = AVCaptureDevice.authorizationStatus(for:AVMediaType.audio)
        switch status  {
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (granted) in
                if(granted){
                    DispatchQueue.main.async {
                        self.startPush()
                    }
                }
            })
            break;
        case AVAuthorizationStatus.authorized:
            DispatchQueue.main.async {
                self.startPush()
            }
            break;
        case AVAuthorizationStatus.denied:
            self.showOpenAuthDialog("Microphone permission denied, open setting -> B·VISION, turn on the Microphone")
            break
        case AVAuthorizationStatus.restricted:
            self.showOpenAuthDialog("Microphone permission denied, open setting -> B·VISION, turn on the Microphone")
            break;
        }
    }
    
    
    func requestAccessForPhoto() -> Void {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus  {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization{ (status:PHAuthorizationStatus) -> Void in
                if status == PHAuthorizationStatus.authorized{
                    DispatchQueue.main.async {
                        self.startLocalPush()
                    }
                }
            }
        case .authorized:
            DispatchQueue.main.async {
                self.startLocalPush()
            }
            break;
        case .denied:
            self.showOpenAuthDialog("Photo permission denied, open setting -> B·VISION, turn on the Photo")
            break
        case .restricted:
            self.showOpenAuthDialog("Photo permission denied, open setting -> B·VISION, turn on the Photo")
            break;
        }
    }
    
    
    
    func startPush(){
        if userId <= 0 {
            self.showSignBoard()
        }else{
            self.showPushWithCamera()
        }
    }
    
    func startLocalPush(){
        if self.userId <= 0 {
            self.showSignBoard()
            return
        }
        let userLevel = UserDefaults.standard.integer(forKey: Constant.key_user_level)
        if userLevel >= 6{
            self.showPushWithVideo()
        }else{
            self.hudError(with: "permission denied")
        }
    }
    
}
