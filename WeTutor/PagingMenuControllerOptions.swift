//
//  Created by Zoe on 3/6/17.
//  Copyright © 2017 TokkiTech. All rights reserved.
//


import Foundation
import PagingMenuController

struct MenuItemUsers: MenuItemViewCustomizable {}
struct MenuItemCalendar: MenuItemViewCustomizable {}
struct MenuItemChat: MenuItemViewCustomizable {}


struct PagingMenuOptions1: PagingMenuControllerCustomizable {
    
  
    var defaultPage: Int {
        return 1
    }
    let usersViewController = UsersViewController.instantiateFromStoryboard()
    let calendarViewController = UpcomingEventTableViewController.instantiateFromStoryboard()
    let chatViewController = ChannelListViewController.instantiateFromStoryboard()

    var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: [   chatViewController, usersViewController, calendarViewController])
    }
    var lazyLoadingPage: LazyLoadingPage {
        return .three
    }
    
    struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            /*return .standard(widthMode: .flexible, centerItem: false, scrollingMode: .pagingEnabled)*/
            return .segmentedControl
        }
        
        var focusMode: MenuFocusMode {
            return .underline(height: 3, color: UIColor.white, horizontalPadding: 10, verticalPadding: 3)
        }
       /* var focusMode: MenuFocusMode {
            return .roundRect(radius: 12, horizontalPadding: 8, verticalPadding: 8, selectedColor: UIColor.white/*UIColor.lightGray.lighten(byPercentage: 0.2)!*/)
        }*/

        var defaultPage: Int {
            return 1
            
            
        }
        
        var height: CGFloat {
            return 0
        }
        
        var itemsOptions: [MenuItemViewCustomizable] {
            return [  MenuItemChat(), MenuItemUsers(),  MenuItemCalendar()]
        }
    }
    
    
    
    struct MenuItemUsers: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            
            let title = MenuItemText(text: "Connect")
           // let description = MenuItemText(text: "")
            //return .multilineText(title: title, description: description)
            return .text(title: title)
        }
    }
    struct MenuItemCalendar: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: "Calendar")
           // let description = MenuItemText(text: String(describing: self))
            //return .multilineText(title: title, description: description)
            return .text(title: title)
        }
    }
    struct MenuItemChat: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: "Chat")
          //  let description = MenuItemText(text: String(describing: self))
            //return .multilineText(title: title, description: description)
            return .text(title: title)
        }
    }
  }


