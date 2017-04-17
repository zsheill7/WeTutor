//
//  RefreshAnimator.swift
//  WeTutor
//
//  Created by Zoe on 4/17/17.
//  Copyright © 2017 CosmicMind. All rights reserved.
//

import UIKit
import PullToRefresh

class Animator: RefreshViewAnimator {
    
    private let refreshView: RefreshView
    
    init(refreshView: RefreshView) {
        self.refreshView = refreshView
    }
    
    func animate(_ state: State) {
        // animate refreshView according to state
    }
}
