//
//  UILabelExtensions.swift
//  WeTutor
//
//  Created by Zoe on 4/24/17.
//  Copyright © 2017 CosmicMind. All rights reserved.
//

import Foundation

extension UILabel {
    
    func isTruncated() -> Bool {
        
        if let string = self.text {
            
            let size: CGSize = (string as NSString).boundingRect(
                with: CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude),
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: [NSFontAttributeName: self.font],
                context: nil).size
            print("in if let string =")
            print("size.width \(size.width) self.bounds.size.width \(self.bounds.size.width)")
            print("size.width > self.bounds.size.width\(size.width > self.bounds.size.width)")
            return (size.width > 137.0/*self.bounds.size.width*/)
        }
        
        return false
    }
    
}
