//
//  PagingMenuControllerCustomizable.swift
//  PagingMenuController
//
//  Created by Zoe on 3/6/17.
//  Copyright © 2017 TokkiTech. All rights reserved.
//

import Foundation
import UIKit

public protocol PagingMenuControllerCustomizable {
    var defaultPage: Int { get }
    var animationDuration: TimeInterval { get }
    var isScrollEnabled: Bool { get }
    var backgroundColor: UIColor { get }
    var lazyLoadingPage: LazyLoadingPage { get }
    var menuControllerSet: MenuControllerSet { get }
    var componentType: ComponentType { get }
}

public extension PagingMenuControllerCustomizable {
    var defaultPage: Int {
        return 1
    }
    var animationDuration: TimeInterval {
        return 0.3
    }
    var isScrollEnabled: Bool {
        return true
    }
    var backgroundColor: UIColor {
        return UIColor.white//pagingMenuGray()//UIColor(netHex: 0x95C2CC)
    }
    var lazyLoadingPage: LazyLoadingPage {
        return LazyLoadingPage.all
    }
    var menuControllerSet: MenuControllerSet {
        return .multiple
    }
}

public enum LazyLoadingPage {
    case one
    case three
    case all
}

public enum MenuControllerSet {
    case single
    case multiple
}

public enum ComponentType {
    case menuView(menuOptions: MenuViewCustomizable)
    case pagingController(pagingControllers: [UIViewController])
    case all(menuOptions: MenuViewCustomizable, pagingControllers: [UIViewController])
}
