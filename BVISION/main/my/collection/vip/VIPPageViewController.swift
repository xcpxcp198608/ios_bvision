//
//  VIPPageViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/18.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class VIPPageViewController: TabmanViewController, PageboyViewControllerDataSource {
    
    
    static let categorys = ["LD", "NET"]
    
    let pageControllers: [UIViewController] = {
        let storyboard = UIStoryboard(name: "MyCollection", bundle: Bundle.main)
        var viewControllers = [UIViewController]()
        let ldViewControllers = storyboard.instantiateViewController(withIdentifier: "LDViewController") as! LDViewController
        ldViewControllers.category = "UCKdQylYy0HrANWEi2CWkn-g"
        let netViewControllers = storyboard.instantiateViewController(withIdentifier: "NetViewController") as! NetViewController
        viewControllers.append(ldViewControllers)
        viewControllers.append(netViewControllers)
        return viewControllers
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        var items = [Item]()
        for category in VIPPageViewController.categorys {
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

