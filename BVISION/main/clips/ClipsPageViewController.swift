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

class ClipsPageViewController: TabmanViewController, PageboyViewControllerDataSource {
    
    
    static let categorys = ["LD Eufonico", "Funny", "NBA", "F1", "NFL", "MLB", "WWE", "UEFA", "News", "Technology", "Music", "Car", "Girls"]
    
    let pageControllers: [UIViewController] = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewControllers = [UIViewController]()
        for category in categorys {
            let ybtViewControllers = storyboard.instantiateViewController(withIdentifier: "YTBChannelsViewController") as! YTBChannelsViewController
            ybtViewControllers.category = category
            if category == "LD Eufonico"{
                ybtViewControllers.isLd = true
                ybtViewControllers.category = "UC5FrSOnuTpltVCUUB2lrB1g"
            }
            viewControllers.append(ybtViewControllers)
        }
        return viewControllers
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        var items = [Item]()
        for category in ClipsPageViewController.categorys {
            let item = Item(title: category)
            items.append(item)
        }
        self.bar.items = items
        self.bar.appearance = TabmanBar.Appearance({ (appearance) in
                // customize appearance here
                appearance.style.background = .blur(style: .dark)
                appearance.indicator.color = UIColor.red
                appearance.state.color = UIColor.gray
                appearance.state.selectedColor = UIColor.red
                appearance.text.font = .systemFont(ofSize: 16.0)
            })
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
    
}


