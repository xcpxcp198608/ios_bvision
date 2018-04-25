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
    
    
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = MMAlertViewConfig.global()
        config?.defaultTextOK = "Confirm"
        config?.defaultTextConfirm = "Confirm"
        config?.defaultTextCancel = "Cancel"
        
        let config1 = MMSheetViewConfig.global()
        config1?.defaultTextCancel = "Cancel"
    }

}
