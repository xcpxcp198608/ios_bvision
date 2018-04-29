//
//  TrendingImagePreViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/29.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import SDCycleScrollView

class TrendingImagePreViewController: BasicViewController, SDCycleScrollViewDelegate {
    
    var trendingInfo: TrendingInfo?
    
    @IBOutlet weak var scrollView: SDCycleScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if trendingInfo != nil && (trendingInfo?.imgCount)! > 0{
            initScrollView()
        }
        
    }
    
    func initScrollView(){
        scrollView.backgroundColor = UIColor(rgb: Color.primary)
        scrollView.placeholderImage = UIColor(rgb: Color.primary).createImage()
        scrollView.bannerImageViewContentMode = .scaleAspectFit
        scrollView.delegate = self
        scrollView.autoScroll = false
        scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
        var images = [String]()
        if trendingInfo?.imgCount == 1{
            images.append((trendingInfo?.imgUrl)!)
        }else{
            let urls = trendingInfo?.imgUrl.split(separator: "#").map(String.init)
            if urls == nil || urls?.count != trendingInfo?.imgCount{
                return
            }
            for i in 0..<(urls?.count)!{
                images.append(urls![i])
            }
        }
        scrollView.imageURLStringsGroup = images
    }

    
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didScrollTo index: Int) {
        
    }
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        self.dismiss(animated: false, completion: nil)
    }

}
