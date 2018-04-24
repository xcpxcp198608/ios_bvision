//
//  BlackListViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/23.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import JGProgressHUD
import MJRefresh
import PopupDialog
import MMPopupView

class BlackListViewController: BasicViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var userBlacksProvider = {
        return UserBlacksProvider()
    }()
    
    lazy var userSetBlackProvider = {
        return UserSetBlackProvider()
    }()
    
    var blackListUserInfos = [BlackListUserInfo]()
    var hud: JGProgressHUD?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = MMAlertViewConfig.global()
        config?.defaultTextOK = "Confirm"
        config?.defaultTextConfirm = "Confirm"
        config?.defaultTextCancel = "Cancel"
        
        userBlacksProvider.loadDelegate = self
        userSetBlackProvider.loadDelegate = self
        tableView.delegate = self
        tableView.dataSource = self
        initPullDownRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userBlacksProvider.load(userId)
        hud = hudLoading()
    }
    
    func initPullDownRefresh(){
        let header = MJRefreshNormalHeader()
        header.setTitle("Pull down to refresh", for: MJRefreshState.idle)
        header.setTitle("Release to refresh", for: .pulling)
        header.setTitle("Loading ...", for: .refreshing)
        header.lastUpdatedTimeLabel.isHidden = true
        header.setRefreshingTarget(self, refreshingAction: #selector(pullDownRefresh))
        self.tableView!.mj_header = header
    }
    
    @objc func pullDownRefresh(){
        userBlacksProvider.load(userId)
        self.tableView!.mj_header.endRefreshing()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blackListUserInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlackListCell", for: indexPath)
        cell.contentView.backgroundColor = UIColor(rgb: Color.primary)
        let blackListUserInfo = self.blackListUserInfos[indexPath.row]
        cell.textLabel?.text = blackListUserInfo.blackUsername
        cell.textLabel?.backgroundColor = UIColor(rgb: Color.primary)
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let name = blackListUserInfos[indexPath.row].blackUsername
        removeFromBlackList(name: name, indexPath: indexPath)
    }
    
    func removeFromBlackList(name: String, indexPath: IndexPath){
        self.userSetBlackProvider.load(indexPath: indexPath, action: 0, userId: userId, username: name)
    }
    
}



extension BlackListViewController: UserSetBlackProviderDelegate{
    
    @IBAction func clickAddBlackList(){
//        let inputVC = InputDialogViewController(nibName: "InputDialogViewController", bundle: nil)
//        let popup = PopupDialog(viewController: inputVC, buttonAlignment: .horizontal, transitionStyle: .bounceUp, gestureDismissal: true)
//        let buttonOne = CancelButton(title: "Cancel", height: 44) {
//
//        }
//        let buttonTwo = DefaultButton(title: "Confirm", height: 44) {
//            let username = inputVC.usernameTextField.text
//        }
//        buttonOne.buttonColor = UIColor(rgb: Color.primary)
//        buttonTwo.buttonColor = UIColor(rgb: Color.primary)
//        popup.addButtons([buttonOne, buttonTwo])
//        present(popup, animated: true, completion: nil)
        let alertView = MMAlertView.init(inputTitle: "Add", detail: "type in username add to the black list", placeholder: "username") { (username) in
            if let name = username{
                self.hud = self.hudLoading()
                self.userSetBlackProvider.load(indexPath: nil, action: 1, userId: userId, username: name)
            }
        }
        alertView?.show()
    }
    
    
    func loadSuccess(action: Int, indexPath: IndexPath?) {
        hud?.dismiss()
        if action == 1{
            self.userBlacksProvider.load(userId)
        }
        if action == 0 {
            self.blackListUserInfos.remove(at: indexPath!.row)
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        }
    }

    
}



extension BlackListViewController: UserBlacksProviderDelegate{
    
    func loadSuccess(_ blackListUserInfos: [BlackListUserInfo]) {
        hud?.dismiss()
        if blackListUserInfos.count <= 0{
            return
        }
        self.blackListUserInfos = blackListUserInfos
        self.tableView.reloadData()
    }
    
    func loadFailure(_ message: String, _ error: Error?) {
        hud?.dismiss()
        self.hudError(with: message)
    }
    
}
