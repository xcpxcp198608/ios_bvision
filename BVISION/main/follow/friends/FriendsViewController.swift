//
//  FriendsViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/27.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit

class FriendsViewController: BasicViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if userId <= 0 {
            return
        }
        userFriendProvider.loadDelegate = self
        userFriendProvider.load(userId)
    }

}








extension FriendsViewController: UserFriendProviderDelegate{
    
    func loadSuccess(userInfos: [UserInfo]) {
        print(userInfos)
    }
    
    func loadFailure(_ message: String, _ error: Error?) {
        
    }
}
