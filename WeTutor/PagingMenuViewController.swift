//
//  PagingMenuViewController.swift
//  PagingMenuController
//
//  Created by Zoe on 3/6/17.
//  Copyright © 2017 TokkiTech. All rights reserved.
//
//

import UIKit
import PagingMenuController
import BTNavigationDropdownMenu
import FirebaseAuth
import Firebase
import EventKit
import EventKitUI
import Hero
import BubbleTransition

extension UIApplication {
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
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
         options = PagingMenuOptions1()
        return options
       
    }
}


/*extension PagingMenuViewController: UINavigationControllerDelegate {
    
    override func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //Check for the good animation
        return MyAnimation()
    }
}*/

class PagingMenuViewController: UIViewController  {
    
    var options: PagingMenuControllerCustomizable!
    var menuView: BTNavigationDropdownMenu!
    
    struct MenuItem1: MenuItemViewCustomizable {}
    struct MenuItem2: MenuItemViewCustomizable {}
    struct MenuItem3: MenuItemViewCustomizable {}
    
    struct MenuOptions: MenuViewCustomizable {
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2(), MenuItem3()]
        }
    }
    

    
    
    struct PagingMenuOptions: PagingMenuControllerCustomizable {
        var componentType: ComponentType {
            return .all(menuOptions: MenuOptions(), pagingControllers: [UIViewController(), UIViewController(), UIViewController()])
        }
    }
    
    
    var pagingMenuController: PagingMenuController?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("here")
                let view = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width + 20, height: UIScreen.main.bounds.height + 20))
        
        let blackColorImage = UIImage(color: .black)
        view.image = blackColorImage
        self.view.addSubview(view)
        UIView.animate(withDuration: 1.3, animations: {
            view.alpha = 0.0
        })
        let sectionType = MenuSection(indexPath: IndexPath(row: 0, section: 2) as IndexPath)
        // self.view?.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.clear
        options = sectionType?.options
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        pagingMenuController = self.childViewControllers.first as! PagingMenuController
        /*let pagingMenuController = UIApplication.topViewController(base: self) as! PagingMenuController*/
        
        pagingMenuController?.setup(options)
        //pagingMenuController?.move(toPage: 1, animated: false)
        // pagingMenuController?.defaultPage
        //pagingMenuController?.initial
        

        pagingMenuController?.onMove = { state in
            switch state {
            case let .willMoveController(menuController, previousMenuController):
                print("")
                //print(previousMenuController)
                //print(menuController)
            case let .didMoveController(menuController, previousMenuController):
                print("")
                
               // print(previousMenuController)
                //print(menuController)
            case let .willMoveItem(menuItemView, previousMenuItemView):
                print("")
               // print(previousMenuItemView)
               // print(menuItemView)
            case let .didMoveItem(menuItemView, previousMenuItemView):
                print("")
               // print(previousMenuItemView)
               // print(menuItemView)
            }
        }
        createDropdown()
        
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    func createDropdown() {
        let items = ["About This App", "Settings", "Log Out"]
   
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(netHex: 0x51679F)
        //self.navigationController?.title.font
//UIColor(netHex: 0x95C2CC)       self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        //let navigationBarAppearance = self.navigationController?.navigationBar
        
        //navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName: UIFont(name: "Helvetica-Light", size: 20)!]
        
        let rightButtonImg = UIImage(named: "rightButtonCalendar-25")
        let rightButton = UIBarButtonItem(image: rightButtonImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector(openCalendar))
        self.navigationItem.rightBarButtonItem = rightButton
        
        
        let logo = UIImage(named: "WeTutorHat")
        let imageView = UIImageView(image:logo)
        
        //self.navigationItem.contentView = imageView
        let leftButtonImg = UIImage(named: "Speech Bubble Filled-50"/*"leftButtonChat-25"*/)
        let resizedLeftButton = self.resizeImage(image: leftButtonImg!, targetSize: CGSize(width: 25, height: 25))
        let leftButtonImageView = UIImageView(image: leftButtonImg)
        let leftButton = UIBarButtonItem(image: resizedLeftButton, style: UIBarButtonItemStyle.plain, target: self, action: #selector(openChat))
        
      //  let leftButton = UIBarButtonItem(
        
        self.navigationItem.leftBarButtonItem = leftButton
        
        
       
        self.navigationItem.titleView = imageView
        
        let menuImage = UIImage(named: "Menu 2-25")
       // let resizedMenu
        menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view,
                                            title: "EcoFriends", items: items as [AnyObject])
        
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = UIColor.flatSkyBlue
        menuView.shouldKeepSelectedCellColor = false
        menuView.cellTextLabelColor = UIColor.white
        menuView.cellTextLabelFont = UIFont(name: "Helvetica-Light", size: 18)!//UIFont(name: "Avenir-Heavy", size: 17)
        menuView.navigationBarTitleFont = UIFont(name: "Helvetica-Light", size: 20)!
        
        menuView.cellTextLabelAlignment = .left // .Center // .Right // .Left
        //menuView.arrowImage = UIImage(named: "Settings Filled-25")
        menuView.arrowImage = menuImage
       // menuView.arrowImage = UIImage(named: "More Filled-25")
        menuView.arrowPadding = 25
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.black
        menuView.maskBackgroundOpacity = 0.3
        menuView.menuTitleColor = UIColor.white
        //menuView.backgroundColor = UIColor(patternImage: logo!)
       // menuView.titleView.
       
        
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            if indexPath == 0 {
                self.modalTransitionStyle = .flipHorizontal
                let storyboard = UIStoryboard(name: "AboutThisApp", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "aboutUsNC") as! UINavigationController
                //let controller = storyboard.instantiateViewController(withIdentifier: "AboutUsTableViewController") as! AboutUsTableViewController
                             // controller.modalTransitionStyle = .flipHorizontal
                //controller.modalPresentationStyle = .zoom
               // Hero.shared.setDefaultAnimationForNextTransition(.zoom)
                
                
                // Hero.shared.setContainerColorForNextTransition(.lightGray)
                //self.hero_replaceViewController(with: controller)
                self.present(controller, animated: true, completion: nil)
                //self.performSegue(withIdentifier: "toAboutThisApp", sender: self)
            } else if indexPath == 1 {
                let storyboard = UIStoryboard(name: "Settings", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "settingsNC") as! UINavigationController
                self.present(controller, animated: true, completion: nil)

            } else if indexPath == 2 {
                try! FIRAuth.auth()!.signOut()
                let userDefaults = UserDefaults.standard
                userDefaults.removeObject(forKey: "isTutor")
                userDefaults.removeObject(forKey: "languages")
                userDefaults.removeObject(forKey: "description")
               
                userDefaults.synchronize()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "loginNC") as! UINavigationController
                self.present(controller, animated: true, completion: nil)
            }
    
        }
        
        self.navigationItem.titleView = menuView
    }
    
    
    // MARK: UIViewControllerTransitioningDelegate
    
    public override func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = BubbleTransition()
        transition.transitionMode = .present
        transition.startingPoint = self.view.center
        transition.bubbleColor = UIColor.blue//addEventButton.backgroundColor!
        return transition
    }
    
    public override func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = BubbleTransition()
        transition.transitionMode = .dismiss
        transition.startingPoint = self.view.center//addEventButton.center
        transition.bubbleColor =  UIColor.blue//addEventButton.backgroundColor!
        return transition
    }

    
    //let transition = BubbleTransition()
    
    func openChat() {
        //pagingMenuController?.move(toPage: 0, animated: true)
        pagingMenuController?.move(toPage: 0, animated: true)
    }
    
    func openCalendar() {
        pagingMenuController?.move(toPage: 2, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
    }
    /*public override func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = CGPoint(x: self.view.frame.width / 2, y: 25)
        transition.bubbleColor = (self.navigationController?.navigationBar.barTintColor)!
        return transition
    }
    
    public override func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = CGPoint(x: self.view.frame.width / 2, y: 25)
        transition.bubbleColor = (self.navigationController?.navigationBar.barTintColor)!
        return transition
    }*/
}
