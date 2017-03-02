
import Foundation
import PagingMenuController

struct MenuItemUsers: MenuItemViewCustomizable {}
struct MenuItemCalendar: MenuItemViewCustomizable {}
struct MenuItemChat: MenuItemViewCustomizable {}
//struct MenuItemOrganization: MenuItemViewCustomizable {}
//struct MenuItemRequest: MenuItemViewCustomizable {}

struct PagingMenuOptions1: PagingMenuControllerCustomizable {
    
    /*!
        @code
     
     func displayAlert(title: String, message: String) {
     SCLAlertView().showInfo(title, subTitle: message)
     
     }
     
     @endcode
     
 
     */
    
    let usersViewController = UsersViewController.instantiateFromStoryboard()
    let calendarViewController = CalendarViewController.instantiateFromStoryboard()
    let chatViewController = ChannelListViewController.instantiateFromStoryboard()
   // let organizationsViewController = OrganizationsViewController.instantiateFromStoryboard()
    //let requestViewController = RequestViewController.instantiateFromStoryboard()
    
    var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: [usersViewController, chatViewController, /*calendarViewController*//*organizationsViewController,*/ /*requestViewController*/])
    }
    var lazyLoadingPage: LazyLoadingPage {
        return .all
    }
    
    struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            /*return .standard(widthMode: .flexible, centerItem: false, scrollingMode: .pagingEnabled)*/
            return .segmentedControl
        }
        
        var focusMode: MenuFocusMode {
            return .underline(height: 3, color: UIColor.blue, horizontalPadding: 10, verticalPadding: 0)
        }
        
        var height: CGFloat {
            return 60
        }
        
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItemUsers(), MenuItemChat(), /*MenuItemCalendar()*//*, MenuItemOrganization()*//*, MenuItemRequest()*/]
        }
    }
    
    /*var displayMode: MenuDisplayMode {
        return .segmentedControl
    }
    var focusMode: MenuFocusMode {
        return .underline(height: 3, color: UIColor.blue, horizontalPadding: 10, verticalPadding: 0)
    }
    var itemsOptions: [MenuItemViewCustomizable] {
        return [MenuItemUsers(), MenuItemCalendar(), MenuItemGists(), MenuItemOrganization()]
    }*/
    
    struct MenuItemUsers: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: "Tutors")
            let description = MenuItemText(text: "")
            //return .multilineText(title: title, description: description)
            return .text(title: title)
        }
    }
    struct MenuItemCalendar: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: "Calendar")
            let description = MenuItemText(text: String(describing: self))
            //return .multilineText(title: title, description: description)
            return .text(title: title)
        }
    }
    struct MenuItemChat: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: "Chat")
            let description = MenuItemText(text: String(describing: self))
            //return .multilineText(title: title, description: description)
            return .text(title: title)
        }
    }
   /* struct MenuItemOrganization: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: "My Hours")
            let description = MenuItemText(text: String(describing: self))
            //return .multilineText(title: title, description: description)
            return .text(title: title)
        }
    }*/
    /*struct MenuItemRequest: MenuItemViewCustomizable {
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: "Requests")
            let description = MenuItemText(text: String(describing: self))
            //return .multilineText(title: title, description: description)
            return .text(title: title)
        }
    }*/
}

/*struct PagingMenuOptions2: PagingMenuControllerCustomizable {
    let usersViewController = UsersViewController.instantiateFromStoryboard()
    let repositoriesViewController = RepositoriesViewController.instantiateFromStoryboard()
    let gistsViewController = GistsViewController.instantiateFromStoryboard()
    let organizationsViewController = OrganizationsViewController.instantiateFromStoryboard()
    
    var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: [usersViewController, repositoriesViewController, gistsViewController, organizationsViewController])
    }
    var menuControllerSet: MenuControllerSet {
        return .single
    }
    
    struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItemUsers(), MenuItemCalendar(), MenuItemChat(), MenuItemOrganization()]
        }
    }
}

struct PagingMenuOptions3: PagingMenuControllerCustomizable {
    let usersViewController = UsersViewController.instantiateFromStoryboard()
    let repositoriesViewController = RepositoriesViewController.instantiateFromStoryboard()
    let gistsViewController = GistsViewController.instantiateFromStoryboard()
    let organizationsViewController = OrganizationsViewController.instantiateFromStoryboard()
    
    var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: [usersViewController, repositoriesViewController, gistsViewController, organizationsViewController])
    }
    var lazyLoadingPage: LazyLoadingPage {
        return .three
    }
    
    struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            return .infinite(widthMode: .fixed(width: 80), scrollingMode: .scrollEnabled)
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItemUsers(), MenuItemCalendar(), MenuItemChat(), MenuItemOrganization()]
        }
    }
}

struct PagingMenuOptions4: PagingMenuControllerCustomizable {
    var componentType: ComponentType {
        return .menuView(menuOptions: MenuOptions())
    }
    
    struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        var focusMode: MenuFocusMode {
            return .underline(height: 3, color: UIColor.blue, horizontalPadding: 10, verticalPadding: 0)
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItemUsers(), MenuItemCalendar(), MenuItemChat(), MenuItemOrganization()]
        }
    }
}

struct PagingMenuOptions5: PagingMenuControllerCustomizable {
    var componentType: ComponentType {
        return .menuView(menuOptions: MenuOptions())
    }
    
    struct MenuOptions: MenuViewCustomizable {
        var displayMode: MenuDisplayMode {
            return .infinite(widthMode: .flexible, scrollingMode: .pagingEnabled)
        }
        var focusMode: MenuFocusMode {
            return .roundRect(radius: 12, horizontalPadding: 8, verticalPadding: 8, selectedColor: UIColor.lightGray)
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItemUsers(), MenuItemCalendar(), MenuItemChat(), MenuItemOrganization()]
        }
    }
}

struct PagingMenuOptions6: PagingMenuControllerCustomizable {
    let usersViewController = UsersViewController.instantiateFromStoryboard()
    let repositoriesViewController = RepositoriesViewController.instantiateFromStoryboard()
    let gistsViewController = GistsViewController.instantiateFromStoryboard()
    let organizationsViewController = OrganizationsViewController.instantiateFromStoryboard()
    
    var componentType: ComponentType {
        return .pagingController(pagingControllers: [usersViewController, repositoriesViewController, gistsViewController, organizationsViewController])
    }
    var defaultPage: Int {
        return 1
    }
}
*/
