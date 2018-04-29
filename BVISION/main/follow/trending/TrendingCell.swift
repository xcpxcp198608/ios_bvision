//
//  TrendingCell.swift
//  BVISION
//
//  Created by patrick on 2018/4/29.
//  Copyright © 2018 wiatec. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

protocol TrendingCellDelegate {
    func imagePress(trendingInfo: TrendingInfo)
}


class TrendingCell: UITableViewCell {
    
    var delegate: TrendingCellDelegate?
    
    var trendingInfo: TrendingInfo!
    var imgViews = [UIImageView]()
    
    var ivIcon: UIImageView!
    var laName: UILabel!
    var laContent: UILabel!
    var laTime: UILabel!
    var laLine: UILabel!
    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style:UITableViewCellStyle, reuseIdentifier:String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    func setData(_ trendingInfo: TrendingInfo){
        self.trendingInfo = trendingInfo
        self.createUI();
    }
    
    func createUI(){
        self.createIconUI()
        self.createUsernameUI()
        self.createContentUI()
        self.createImageUI()
    }
    
    func createIconUI(){
        ivIcon = UIImageView.init()
        ivIcon.kf.setImage(with: URL(string: trendingInfo.icon), placeholder: #imageLiteral(resourceName: "hold_person"))
        contentView.addSubview(ivIcon)
        ivIcon.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(10)
            $0.left.equalTo(contentView).offset(16)
            $0.width.equalTo(40)
            $0.height.equalTo(40)
        }
    }
    
    
    func createUsernameUI(){
        laName = UILabel.init()
        laName.numberOfLines = 1
        laName.text = trendingInfo.username
        laName.font = UIFont.boldSystemFont(ofSize: 18)
        laName.textColor = UIColor(rgb: 0x032424)
        contentView.addSubview(laName)
        laName.snp.makeConstraints {
            $0.left.equalTo(contentView).offset(64)
            $0.right.equalTo(contentView).offset(-8)
            $0.top.equalTo(contentView).offset(10)
        }
    }
    
    func createContentUI(){
        laContent = UILabel.init()
        laContent.numberOfLines = 0
        laContent.textAlignment = .left
        laContent.adjustsFontSizeToFitWidth = true
        laContent.text = trendingInfo.content
        laContent.font = UIFont.systemFont(ofSize: 15)
        laContent.textColor = UIColor.black
        contentView.addSubview(laContent)
        laContent.snp.makeConstraints {
            $0.left.equalTo(contentView).offset(64)
            $0.right.equalTo(contentView).offset(-8)
            $0.top.equalTo(laName.snp.bottom)
        }
    }
    
    func createImageUI(){
        if trendingInfo.imgCount <= 0{
            createTimeUI(dependentView: laContent)
        }else if trendingInfo.imgCount == 1{
            let ivImg = UIImageView.init()
            ivImg.kf.setImage(with: URL(string: trendingInfo.imgUrl))
            ivImg.contentMode = .scaleAspectFit
            ivImg.clipsToBounds = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickImage(_:imgIndex:)))
            ivImg.addGestureRecognizer(tapGesture)
            ivImg.isUserInteractionEnabled = true
            self.contentView.addSubview(ivImg)
            ivImg.snp.makeConstraints {
                $0.left.equalTo(contentView).offset(64)
                $0.top.equalTo(laContent.snp.bottom).offset(8)
                $0.width.equalTo(150)
                $0.height.equalTo(150)
            }
            createTimeUI(dependentView: ivImg)
        }else{
            for i in 0..<trendingInfo.imgCount{
                let img = UIImageView.init()
                let urls = trendingInfo.imgUrl.split(separator: "#").map(String.init)
                if trendingInfo.imgCount != urls.count{
                    return
                }
                img.kf.setImage(with: URL(string: urls[i]))
                img.contentMode = .scaleAspectFill
                img.clipsToBounds = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickImage(_:imgIndex:)))
                img.addGestureRecognizer(tapGesture)
                img.isUserInteractionEnabled = true
                self.contentView.addSubview(img)
                
                let w = Int((contentView.frame.width - 56) / 3)
                let leftOffset = (i % 3) * w + (i % 3) * 3
                img.snp.makeConstraints {
                    $0.left.equalTo(laContent.snp.left).offset(leftOffset)
                    if i <= 2{
                        $0.top.equalTo(laContent.snp.bottom).offset(4)
                    }else{
                        $0.top.equalTo(laContent.snp.bottom).offset(w + 8)
                    }
                    $0.width.equalTo(w)
                    $0.height.equalTo(w)
                }
                imgViews.append(img)
            }
            createTimeUI(dependentView: imgViews[imgViews.count - 1])
        }
    }
    
    
    func createTimeUI(dependentView: UIView){
        laTime = UILabel.init()
        laTime.numberOfLines = 1
        laTime.text = trendingInfo.createTime
        laTime.font = UIFont.systemFont(ofSize: 12)
        laTime.textColor = UIColor.lightGray
        contentView.addSubview(laTime)
        laTime.snp.makeConstraints {
            $0.left.equalTo(contentView).offset(18)
            $0.right.equalTo(contentView).offset(-8)
            $0.height.equalTo(20)
            $0.top.equalTo(dependentView.snp.bottom).offset(8)
        }
        createBottomLineUI()
    }
    
    func createBottomLineUI(){
        laLine = UILabel.init()
        laLine.backgroundColor = UIColor.lightGray
        contentView.addSubview(laLine)
        laLine.snp.makeConstraints {
            $0.left.equalTo(contentView).offset(16)
            $0.right.equalTo(contentView)
            $0.height.equalTo(0.5)
            $0.top.equalTo(laTime.snp.bottom)
            $0.bottom.equalTo(contentView)
        }
    }
    
    @objc func clickImage(_ gesture: UIGestureRecognizer, imgIndex: Int){
        print(imgIndex)
        self.trendingInfo.imgIndex = imgIndex
        self.delegate?.imagePress(trendingInfo: trendingInfo)
    }
    
}
