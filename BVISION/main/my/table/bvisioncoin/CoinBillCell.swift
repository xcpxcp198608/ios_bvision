//
//  CoinBillCell.swift
//  BVISION
//
//  Created by patrick on 2018/4/27.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit

class CoinBillCell: UITableViewCell {
    
    @IBOutlet weak var ivAction: UIImageView!
    @IBOutlet weak var laDescription: UILabel!
    @IBOutlet weak var laCoin: UILabel!
    @IBOutlet weak var laTime: UILabel!
    
    var coinBillInfo: CoinBillInfo?

    func setCoinBillInfo(coinBillInfo: CoinBillInfo){
        self.coinBillInfo = coinBillInfo
        laDescription.text = coinBillInfo.description
        laCoin.text = "\(coinBillInfo.coin)"
        laTime.text = coinBillInfo.createTime
        if coinBillInfo.action == 1{
            ivAction.image = #imageLiteral(resourceName: "op_add_30")
            laCoin.textColor = UIColor.green
        }else if coinBillInfo.action == 0{
            ivAction.image = #imageLiteral(resourceName: "op_delete_30")
            laCoin.textColor = UIColor.red
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 24/255, green: 25/255,blue: 27/255, alpha: 1.0)
        backgroundView = selectedView
        let selectedView1 = UIView(frame: CGRect.zero)
        selectedView1.backgroundColor = UIColor(red: 24/255, green: 25/255,blue: 27/255, alpha: 1.0)
        selectedBackgroundView = selectedView1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
