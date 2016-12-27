//
//  UIColorExtensions.swift
//  TutorMe
//
//  Created by Zoe on 12/24/16.
//  Copyright © 2016 CosmicMind. All rights reserved.
//

import Foundation


extension UIColor {
    class func alertViewBlue() -> UIColor {
        return UIColor(red:0.17, green:0.41, blue:0.74, alpha:1.0)
    }
    class func textGray() -> UIColor {
        return UIColor(red:0.51, green:0.57, blue:0.61, alpha:1.0)
    }
    class func newSkyBlue() -> UIColor {
        return UIColor(red:0.76, green:0.91, blue:0.95, alpha:1.0)
    }
    class func flatDarkBlue() -> UIColor {
        return UIColor(red:0.58, green:0.69, blue:0.76, alpha:1.0)
    }
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
}
