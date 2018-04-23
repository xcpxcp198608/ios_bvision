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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.contentView.backgroundColor = UIColor(rgb: Color.primary)
        let blackListUserInfo = self.blackListUserInfos[indexPath.row]
        cell.textLabel?.text = blackListUserInfo.blackUsername
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func removeFromBlackList(){
        
    }
    
}



extension BlackListViewController: UserSetBlackProviderDelegate{
    
    @IBAction func clickAddBlackList(){
        
        
    }
    
    
    func loadSuccess() {
        self.userBlacksProvider.load(userId)
    }

    
}



extension BlackListViewController: UserBlacksProviderDelegate{
    
    func loadSuccess(_ blackListUserInfos: [BlackListUserInfo]) {
        if blackListUserInfos.count <= 0{
            return
        }
        self.blackListUserInfos = blackListUserInfos
        self.tableView.reloadData()
    }
    
    func loadFailure(_ message: String, _ error: Error?) {
        self.hudError(with: message)
    }
    
}
