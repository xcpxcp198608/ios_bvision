//
//  GroupsViewController.swift
//  BVISION
//
//  Created by patrick on 2018/4/27.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import Segmentio

class GroupsViewController: BasicViewController {
    
    
    @IBOutlet weak var sg: Segmentio!
    @IBOutlet weak var myGroupsContainer: UIView!
    @IBOutlet weak var joinedGroupsContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSegment()
    }
    
    func initSegment(){
        var content = [SegmentioItem]()
        let myGroupsItem = SegmentioItem(
            title: NSLocalizedString("MyGroups", comment: ""),
            image: #imageLiteral(resourceName: "groups_gray_40"),
            selectedImage: #imageLiteral(resourceName: "groups_red_40")
        )
        let joinedGroupsItem = SegmentioItem(
            title: NSLocalizedString("JoinedGroups", comment: ""),
            image: #imageLiteral(resourceName: "groups_gray_40"),
            selectedImage: #imageLiteral(resourceName: "groups_red_40")
        )
        content.append(myGroupsItem)
        content.append(joinedGroupsItem)
        sg.setup(
            content: content,
            style: .imageOverLabel,
            options: SegmentioOptions(
                backgroundColor: UIColor(rgb: Color.primary),
                segmentPosition: .fixed(maxVisibleItems: 2),
                scrollEnabled: true,
                indicatorOptions: SegmentioIndicatorOptions(
                    type: .bottom,
                    ratio: 1,
                    height: 3,
                    color: .red
                ),
                horizontalSeparatorOptions: SegmentioHorizontalSeparatorOptions(
                    type: SegmentioHorizontalSeparatorType.topAndBottom, // Top, Bottom, TopAndBottom
                    height: 0,
                    color: .gray
                ),
                verticalSeparatorOptions: SegmentioVerticalSeparatorOptions(
                    ratio: 0.6, // from 0.1 to 1
                    color: .gray
                ),
                imageContentMode: .center,
                labelTextAlignment: .center,
                segmentStates: SegmentioStates(
                    defaultState: SegmentioState(
                        backgroundColor: .clear,
                        titleFont: UIFont.systemFont(ofSize: UIFont.systemFontSize),
                        titleTextColor: .gray
                    ),
                    selectedState: SegmentioState(
                        backgroundColor: .clear,
                        titleFont: UIFont.systemFont(ofSize: UIFont.systemFontSize),
                        titleTextColor: .red
                    ),
                    highlightedState: SegmentioState(
                        backgroundColor: UIColor.lightGray.withAlphaComponent(0.6),
                        titleFont: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize),
                        titleTextColor: .red
                    )
                )
            )
        )
        sg.selectedSegmentioIndex = 0
        sg.valueDidChange = { segmentio, segmentIndex in
            if segmentIndex == 0{
                self.myGroupsContainer.isHidden = false
                self.joinedGroupsContainer.isHidden = true
            }
            if segmentIndex == 1{
                self.myGroupsContainer.isHidden = true
                self.joinedGroupsContainer.isHidden = false
            }
        }
    }

}
