//
//  BasicViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/13.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import MMPopupView

class BasicViewController: UIViewController {
    
    lazy var imageAdProvider = {
        return ImageAdProvider()
    }()
    
    lazy var trendingProvider = {
        return TrendingProvider()
    }()
    
    lazy var myGroupsProvider = {
        return MyGroupsProvider()
    }()
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = MMAlertViewConfig.global()
        config?.defaultTextOK = NSLocalizedString("OK", comment: "")
        config?.defaultTextConfirm = NSLocalizedString("Confirm", comment: "")
        config?.defaultTextCancel = NSLocalizedString("Cancel", comment: "")
        
        let config1 = MMSheetViewConfig.global()
        config1?.defaultTextCancel = NSLocalizedString("Cancel", comment: "")
    }

}
