//
//  VideoPageViewController.swift
//  blive
//
//  Created by patrick on 17/03/2018.
//  Copyright © 2018 许程鹏. All rights reserved.
//

import UIKit
import Pageboy
import Tabman

class ClipsPageViewController: TabmanViewController, PageboyViewControllerDataSource, ClipsProviderDelegate {
    
    lazy var clipsProvider = {
        return ClipsProvider()
    }()
    
    static let categorys = ["LD Eufonico", "Funny", "NBA", "F1", "NFL", "MLB", "WWE", "UEFA", "News", "Technology", "Music", "Car", "Girls"]
    
    var pageControllers = [UIViewController]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clipsProvider.delegate = self
        clipsProvider.load()
        self.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if pageControllers.count <= 0 {
            clipsProvider.load()
        }
    }
    
    func loadSuccess(_ clipInfos: [ClipInfo]) {
        initPage(clipInfos: clipInfos)
    }
    
    func initPage(clipInfos: [ClipInfo]){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var items = [Item]()
        for clipInfo in clipInfos {
            let ybtViewControllers = storyboard.instantiateViewController(withIdentifier: "YTBChannelsViewController") as! YTBChannelsViewController
            ybtViewControllers.clipInfo = clipInfo
            pageControllers.append(ybtViewControllers)
            let item = Item(title: clipInfo.title)
            items.append(item)
        }
        
        self.bar.items = items
        self.bar.appearance = TabmanBar.Appearance({ (appearance) in
            appearance.style.background = .blur(style: .dark)
            appearance.indicator.color = UIColor.red
            appearance.state.color = UIColor.gray
            appearance.state.selectedColor = UIColor.red
            appearance.text.font = .systemFont(ofSize: 16.0)
        })
        self.reloadPages()
    }
    
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return pageControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return pageControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func loadFailure(_ message: String, _ error: Error?) {
        print(message)
    }
    
}


