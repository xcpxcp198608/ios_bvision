//
//  Color.swift
//  blive
//
//  Created by patrick on 11/03/2018.
//  Copyright © 2018 许程鹏. All rights reserved.
//

import Foundation
import UIKit

struct Color {
    
    static let primary: UInt = 0x18191B
    static let accent: UInt = 0x18191B
    static let disable: UInt = 0xDDDDDD
    static let grey: UInt = 0xDDDDDD
    
    
}

extension UIColor{
    
    convenience init(rgb: UInt, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgb & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    func createImage() -> UIImage{
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(self.cgColor)
        context!.fill(rect)
        let theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage!
    }
}
