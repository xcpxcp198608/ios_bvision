//
//  BillViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/26.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import MJRefresh
import JGProgressHUD

class BillViewController: BasicViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var userGetCoinsBillProvider = {
        return UserGetCoinsBillProvider()
    }()
    
    var coinBillInfos = [CoinBillInfo]()
    var hud: JGProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userGetCoinsBillProvider.loadDelegate = self
        tableView.dataSource = self
        tableView.delegate = self
        let cell = UINib.init(nibName: "CoinBillCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "CoinBillCell")
        initPullDownRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userGetCoinsBillProvider.load(userId)
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
        userGetCoinsBillProvider.load(userId)
        hud = hudLoading()
        self.tableView!.mj_header.endRefreshing()
    }


}


extension BillViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coinBillInfos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinBillCell", for: indexPath) as! CoinBillCell
        cell.setCoinBillInfo(coinBillInfo: self.coinBillInfos[indexPath.row])
        return cell
    }
}



extension BillViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}



extension BillViewController: UserGetCoinsBillProviderDelegate{
    
    func loadSuccess(coinBillInfos: [CoinBillInfo]) {
        self.hud?.dismiss()
        self.coinBillInfos = coinBillInfos
        self.tableView.reloadData()
    }
    
    func loadFailure(_ message: String, _ error: Error?) {
        self.hud?.dismiss()
        print(message)
    }
}
