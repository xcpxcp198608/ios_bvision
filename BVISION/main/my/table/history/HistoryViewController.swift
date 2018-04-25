//
//  HistoryViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/18.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import JGProgressHUD
import MJRefresh

class HistoryViewController: BasicViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var userOperationProvider = {
        return UserOperationProvider()
    }()
    
    var hud: JGProgressHUD?
    var userOperationInfos = [UserOperationInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor(rgb: Color.primary)
        let cellNib = UINib(nibName: "HistoryOperationCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "HistoryOperationCell")
        tableView.delegate = self
        tableView.dataSource = self
        userOperationProvider.loadDelegate = self
        initPullDownRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userOperationProvider.load(userId)
        hud = hudLoading()
    }
    
    func initPullDownRefresh(){
        let header = MJRefreshNormalHeader()
        header.setTitle(NSLocalizedString("Pull down to refresh", comment: ""), for: MJRefreshState.idle)
        header.setTitle(NSLocalizedString("Release to refresh", comment: ""), for: .pulling)
        header.setTitle(NSLocalizedString("Loading...", comment: ""), for: .refreshing)
        header.lastUpdatedTimeLabel.isHidden = true
        header.setRefreshingTarget(self, refreshingAction: #selector(pullDownRefresh))
        self.tableView!.mj_header = header
    }
    
    @objc func pullDownRefresh(){
        userOperationProvider.load(userId)
        self.tableView!.mj_header.endRefreshing()
    }

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userOperationInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryOperationCell", for: indexPath) as! HistoryOperationCell
        cell.contentView.backgroundColor = UIColor(rgb: Color.primary)
        let operationInfo = self.userOperationInfos[indexPath.row]
        switch operationInfo.type {
        case 1:
            cell.ivIcon.image = #imageLiteral(resourceName: "op_add_30")
            break
        case 2:
            cell.ivIcon.image = #imageLiteral(resourceName: "op_delete_30")
            break
        case 3:
            cell.ivIcon.image = #imageLiteral(resourceName: "op_select_30")
            break
        case 4:
            cell.ivIcon.image = #imageLiteral(resourceName: "op_update_30")
            break
        default:
            cell.ivIcon.image = #imageLiteral(resourceName: "op_select_30")
            break
        }
        cell.laDescription.text = operationInfo.description
        cell.laTime.text = operationInfo.createTime
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }

}


//MARK:- UserOperationProviderDelegate
extension HistoryViewController: UserOperationProviderDelegate{
    
    func loadSuccess(_ userOperationInfos: [UserOperationInfo]) {
        hud?.dismiss()
        if userOperationInfos.count <= 0{
            return
        }
        self.userOperationInfos = userOperationInfos
        tableView.reloadData()
    }
    
    func loadFailure(_ message: String, _ error: Error?) {
        hud?.dismiss()
        print(message)
    }
    
}

