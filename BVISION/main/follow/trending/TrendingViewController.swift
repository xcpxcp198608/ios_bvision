//
//  ViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/27.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import SDCycleScrollView
import MJRefresh

class TrendingViewController: BasicViewController {
    
    
    @IBOutlet weak var scrollView: SDCycleScrollView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    private var tableView: UITableView!

    
    var imageAdInfos = [ImageAdInfo]()
    var trendingInfos = [TrendingInfo]()
    var start = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trendingProvider.loadDelegate = self
        imageAdProvider.delegate = self
        imageAdProvider.load(position: 2)
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        
        scrollView.backgroundColor = UIColor(rgb: Color.primary)
        scrollView.placeholderImage = #imageLiteral(resourceName: "hold_banner_16_9")
        scrollView.delegate = self
        scrollView.autoScrollTimeInterval = 6
        scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        
        tableView = UITableView.init()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(self.scrollView.snp.bottom)
            $0.bottom.equalTo(0)
            $0.left.equalTo(0)
            $0.right.equalTo(0)
        }
        
        initPullDownRefresh()
        trendingProvider.load(userId, start: start)
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
        trendingProvider.load(userId, start: start)
        self.tableView!.mj_header.endRefreshing()
    }
    
}



extension TrendingViewController: UITableViewDataSource{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trendingInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TrendingCell.init(style: .default, reuseIdentifier: "TrendingCell")
        cell.setData(self.trendingInfos[indexPath.row])
        cell.delegate = self
        return cell
    }
    
}



extension TrendingViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension TrendingViewController: TrendingCellDelegate{
    
    func imagePress(trendingInfo: TrendingInfo) {
        self.performSegue(withIdentifier: "ShowTrendingImagePreViewController", sender: trendingInfo)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTrendingImagePreViewController"{
            let trendingInfo = sender as! TrendingInfo
            let controller = segue.destination as! TrendingImagePreViewController
            controller.trendingInfo = trendingInfo
        }
    }
    
}




extension TrendingViewController: TrendingProviderDelegate{
    
    func loadSuccess(trendingInfos: [TrendingInfo]) {
        //        print(trendingInfos)
        self.trendingInfos.removeAll()
        self.trendingInfos = trendingInfos
        tableView.reloadData()
    }
    
}




extension TrendingViewController: ImageAdProviderDelegate{
    
    func loadSuccess(_ imageAdInfos: [ImageAdInfo]) {
        self.imageAdInfos = imageAdInfos
        var images = [String]()
        var titles = [String]()
        for imageAdInfo in imageAdInfos{
            images.append(imageAdInfo.url)
            titles.append(imageAdInfo.title)
        }
        scrollView.imageURLStringsGroup = images
        scrollView.titlesGroup = titles
    }
    
    func loadFailure(_ message: String, _ error: Error?) {
        print(message)
    }
}




extension TrendingViewController: SDCycleScrollViewDelegate{
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didScrollTo index: Int) {
        
    }
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        let imageAdInfo = self.imageAdInfos[index]
        if imageAdInfo.action == 0 {
            self.showWebView(imageAdInfo.link)
        }
    }
}
