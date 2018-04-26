//
//  CoinPuchaseCell.swift
//  BVISION
//
//  Created by patrick on 2018/4/24.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit


class CoinPurchaseCell: UICollectionViewCell{
    
    @IBOutlet weak var laDescription: UILabel!
    @IBOutlet weak var btPurchase: UIButton!
    
    var coinInfo: CoinInfo?
    
    override func awakeFromNib() {
        btPurchase.layer.cornerRadius = btPurchase.frame.height / 4
        btPurchase.layer.masksToBounds = true
    }
    
    func setCoinInfo(_ coinInfo: CoinInfo){
        self.coinInfo = coinInfo
        laDescription.text = coinInfo.name
        btPurchase.setTitle("\(NSLocalizedString("currency", comment: ""))\(coinInfo.amount)", for: .normal)
    }
    
}
