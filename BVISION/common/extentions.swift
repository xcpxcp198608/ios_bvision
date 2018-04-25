////
////  extentions.swift
////  blive
////
////  Created by patrick on 18/12/2017.
////  Copyright © 2017 许程鹏. All rights reserved.
////
//
import UIKit
import JGProgressHUD

extension UIViewController{
    
    //MARK:- show
    func showSignBoard(){
        showViewController("Sign", controller: "SignInViewController")
    }
    
    func showMainBoard(){
        showViewController("Main", controller: "BasicTabBarController")
    }
    
    func showPushWithCamera(){
        showViewController("Push", controller: "PushViewController")
    }
    
    func showPushWithVideo(){
        showViewControllerWithNavigation("Push", controller: "PushVideoViewController")
    }
    
    func showLocalPushViewController(_ url: URL?){
        let authBoard: UIStoryboard = UIStoryboard(name: "Push", bundle: nil)
        let controller = authBoard.instantiateViewController(withIdentifier: "LocalPushViewController") as! LocalPushViewController
        controller.videoUrl = url
        self.present(controller, animated: false, completion: nil)
    }
    
    func showScanViewController(){
        showViewController("Scan", controller: "ScanViewController")
    }
    
    func showWebView(_ url: String){
        let board: UIStoryboard = UIStoryboard(name: "Web", bundle: nil)
        let navigationController = board.instantiateViewController(withIdentifier: "WebViewController") as! UINavigationController
        let controller = navigationController.topViewController as! WebViewController
        controller.url = url
        self.present(navigationController, animated: false, completion: nil)
    }
    
    fileprivate func showViewController(_ board: String, controller view: String){
        let board: UIStoryboard = UIStoryboard(name: board, bundle: nil)
        let controller = board.instantiateViewController(withIdentifier: view)
        self.present(controller, animated: false, completion: nil)
    }
    
    fileprivate func showViewControllerWithNavigation(_ board: String, controller view: String){
        let board: UIStoryboard = UIStoryboard(name: board, bundle: nil)
        let navigationController = board.instantiateViewController(withIdentifier: view) as! UINavigationController
        self.present(navigationController, animated: false, completion: nil)
    }
    
    
    
    //MARK:- hud
    func hudNotice(with message: String = ""){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = message
        hud.indicatorView = JGProgressHUDImageIndicatorView.init(image: #imageLiteral(resourceName: "notice_orange_30"))
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 2.0)
    }
    
    func hudError(with message: String = "Error"){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = message
        hud.indicatorView = JGProgressHUDImageIndicatorView.init(image: #imageLiteral(resourceName: "error_red_30"))
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 2.0)
    }
    
    
    func hudSuccess(with message: String = "Success"){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = message
        hud.indicatorView = JGProgressHUDImageIndicatorView.init(image: #imageLiteral(resourceName: "right_green"))
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 2.0)
    }
    
    func hudLoading(_ message: String = "Loading...") -> JGProgressHUD{
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading..."
        hud.show(in: self.view)
        return hud
    }
    
    
    
    //MARK:- system alert
    func alertError(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func showNoticeThenToSignBoard(message: String = "has no sign in"){
        let alert = UIAlertController(
            title: "Notice",
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .default) { (_) in
            self.dismiss(animated: false, completion: nil)
            self.showSignBoard()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func alertSuccess(message: String) {
        let alert = UIAlertController(
            title: "Successfully",
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            self.dismiss(animated: false, completion: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showOpenAuthDialog(_ message: String){
        let alert = UIAlertController(
            title: "Permission denied",
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
