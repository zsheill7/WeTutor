//
//  PullToRefresh.swift
//  WeTutor
//
//  Created by Zoe on 4/17/17.
//  Copyright © 2017 TokkiTech. All rights reserved.
//

import UIKit

class RefreshView: UIView {
    
   
    
    @IBOutlet var imageView: UIImageView!
    // and others
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView.image = #imageLiteral(resourceName: "Loading Pull-down 1")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       // fatalError("init(coder:) has not been implemented")
    }
}
