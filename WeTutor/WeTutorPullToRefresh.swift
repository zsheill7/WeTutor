//
//  WeTutorPullToRefresh.swift
//  WeTutor
//
//  Created by Zoe on 4/17/17.
//  Copyright © 2017 CosmicMind. All rights reserved.
//

import UIKit
import PullToRefresh

class WeTutorPullToRefresh: PullToRefresh {
    
    convenience init() {
        let refreshView = Bundle(for: type(of: self)).loadNibNamed("RefreshView", owner: nil, options: nil)!.first as! RefreshView
        refreshView.imageView.image = #imageLiteral(resourceName: "Loading Pull-down 1")
        let animator = Animator(refreshView: refreshView)
        self.init(height: refreshView.height, position: .top)
    }
}
