//
//  PagingMenuViewController.swift
//  PagingMenuControllerDemo
//
//  Created by Yusuke Kita on 5/17/16.
//  Copyright © 2016 kitasuke. All rights reserved.
//

import UIKit
import PagingMenuController
import BTNavigationDropdownMenu
import FirebaseAuth
import Firebase

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

private enum MenuSection {
    case all(content: AllContent)
    case menuView(content: MenuViewContent)
    case menuController(content: MenuControllerContent)
    
    fileprivate enum AllContent: Int { case standard, segmentedControl, infinite }
    fileprivate enum MenuViewContent: Int { case underline, roundRect }
    fileprivate enum MenuControllerContent: Int { case standard }
    
    init?(indexPath: IndexPath) {
        switch ((indexPath as NSIndexPath).section, (indexPath as NSIndexPath).row) {
        case (0, let row):
            guard let content = AllContent(rawValue: row) else { return nil }
            self = .all(content: content)
        case (1, let row):
            guard let content = MenuViewContent(rawValue: row) else { return nil }
            self = .menuView(content: content)
        case (2, let row):
            guard let content = MenuControllerContent(rawValue: row) else { return nil }
            self = .menuController(content: content)
        default: return nil
        }
    }
    
    var options: PagingMenuControllerCustomizable {
        let options: PagingMenuControllerCustomizable
        switch self {
        case .all(let content):
            switch content {
            case .standard:
                options = PagingMenuOptions1()
            case .segmentedControl:
                options = PagingMenuOptions2()
            case .infinite:
                options = PagingMenuOptions3()
            }
        case .menuView(let content):
            switch content {
            case .underline:
                options = PagingMenuOptions4()
            case .roundRect:
                options = PagingMenuOptions5()
            }
        case .menuController(let content):
            switch content {
            case .standard:
                options = PagingMenuOptions6()
            }
        }
        return options
    }
}



class PagingMenuViewController: UIViewController {
    var options: PagingMenuControllerCustomizable!
    var menuView: BTNavigationDropdownMenu!
    
    struct MenuItem1: MenuItemViewCustomizable {}
    struct MenuItem2: MenuItemViewCustomizable {}
    
    struct MenuOptions: MenuViewCustomizable {
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2()]
        }
    }
    

    
    
    struct PagingMenuOptions: PagingMenuControllerCustomizable {
        var componentType: ComponentType {
            return .all(menuOptions: MenuOptions(), pagingControllers: [UIViewController(), UIViewController()])
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("here")
        let sectionType = MenuSection(indexPath: NSIndexPath(row: 0, section: 0) as IndexPath)
        
        options = sectionType?.options
        
        createDropdown()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let pagingMenuController = self.childViewControllers.first as! PagingMenuController
        /*let pagingMenuController = UIApplication.topViewController(base: self) as! PagingMenuController*/
        pagingMenuController.setup(options)
        pagingMenuController.onMove = { state in
            switch state {
            case let .willMoveController(menuController, previousMenuController):
                print(previousMenuController)
                print(menuController)
            case let .didMoveController(menuController, previousMenuController):
                print(previousMenuController)
                print(menuController)
            case let .willMoveItem(menuItemView, previousMenuItemView):
                print(previousMenuItemView)
                print(menuItemView)
            case let .didMoveItem(menuItemView, previousMenuItemView):
                print(previousMenuItemView)
                print(menuItemView)
            }
        }
    }
    
    func createDropdown() {
        let items = ["About This App", "Settings", "Log Out"]
   
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(netHex: 0x51679F)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "TutorMe", items: items as [AnyObject])
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = UIColor.flatSkyBlue
        menuView.shouldKeepSelectedCellColor = false
        menuView.cellTextLabelColor = UIColor.white
        menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
        menuView.cellTextLabelAlignment = .left // .Center // .Right // .Left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.black
        menuView.maskBackgroundOpacity = 0.3
        
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            if indexPath == 0 {
                self.modalTransitionStyle = .flipHorizontal
                let storyboard = UIStoryboard(name: "AboutThisApp", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "aboutThisAppVC") as! AboutThisAppViewController
                controller.modalTransitionStyle = .flipHorizontal
                self.present(controller, animated: true, completion: nil)
                //self.performSegue(withIdentifier: "toAboutThisApp", sender: self)
            } else if indexPath == 1 {
                
            } else if indexPath == 2 {
                try! FIRAuth.auth()!.signOut()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "signupNC") as! UINavigationController
                self.present(controller, animated: true, completion: nil)
            }
    
        }
        
        self.navigationItem.titleView = menuView
    }
}
