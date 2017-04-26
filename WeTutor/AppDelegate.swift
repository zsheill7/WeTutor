//
//  Created by Zoe on 3/6/17.
//  Copyright © 2017 TokkiTech. All rights reserved.
//


import UIKit
import Material
import Firebase
import FirebaseDatabase
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging
//import FBSDKCoreKit
import DropDown
import Stripe
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
     let gcmMessageIDKey = "gcm.message_id"
    func applicationDidFinishLaunching(_ application: UIApplication) {
        
        FIRApp.configure()
        
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = UIColor(netHex: 0x51679F/*0x959595*/)
        navigationBarAppearance.tintColor = UIColor.white
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName: UIFont(name: "Helvetica-Light", size: 20)!]
       // UIFont(
     //  UIApplication.shared.statusBarStyle = .lightContent
        
        var currentUser: User?
        
        let userDefaults = UserDefaults.standard
        
     /*  let mainStoryboard: UIStoryboard = UIStoryboard(name: "Tutor", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tutorPagingMenuNC") as! UINavigationController
        self.window?.rootViewController = viewController*/

       if FIRAuth.auth()?.currentUser?.uid != nil {
            FriendSystem.system.getCurrentUser { (user) in
                currentUser = user
                if let isTutor = currentUser?.isTutor as? Bool,
                    
                    let hasDescription = currentUser?.isTutor as? String,
                    let availableDays = currentUser?.availableDaysArray,
                    let uid = FIRAuth.auth()?.currentUser?.uid {
                    
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Tutor", bundle: nil)
                    let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tutorPagingMenuNC") as! UINavigationController
                    self.window?.rootViewController = viewController
                    
                    /* if isTutor == true {
                     //self.present(viewController, animated: true, completion: nil)
                     } else {
                     let mainStoryboard: UIStoryboard = UIStoryboard(name: "Tutee", bundle: nil)
                     let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tuteePagingMenuNC") as! UINavigationController
                     window?.rootViewController = viewController
                     // self.present(viewController, animated: true, completion: nil)
                     }*/
                }
                
            }
        }
        
        
        
        //print(userDefaults.value(forKey: "isTutor") as? Bool)
       // print(userDefaults.value(forKey: "languages") as? [String])
       // print(userDefaults.value(forKey: "description") as? String)
        print(FIRAuth.auth()?.currentUser?.uid)
        
        IQKeyboardManager.shared().isEnabled = true
        DropDown.startListeningToKeyboard()
        
        
        //Stripe payments
        STPPaymentConfiguration.shared().publishableKey = "pk_test_yov6ZvesIp3jqqP0lSplDmkF"
        
        STPPaymentConfiguration.shared().appleMerchantIdentifier = "merchant.com.wetutor"
              // DropDown.appearance().selectionBackgroundColor = UIColor.flatBlue
       // DropDown.appearance().backgroundColor = UIColor.flatBlue
        
       /* let mainStoryboard: UIStoryboard = UIStoryboard(name: "MenuViewController", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "ProfilePictureViewController") as! UIViewController
        window?.rootViewController = viewController*/

        /*let mainStoryboard: UIStoryboard = UIStoryboard(name: "MenuViewController", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "MoreInfoViewControllerTest") as! UIViewController
        window?.rootViewController = viewController*/
        
        /*let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TutorSignUpViewControllerTwoNC") as! UINavigationController
        window?.rootViewController = viewController*/
        
        
        /*let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TutorOrTuteeViewController") as! UIViewController
        window?.rootViewController = viewController  */
        
       
        
        // iOS 10 support
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    
    
  /*  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url as URL!,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }*/
    
    //let ref = Firebase(url:"https://tutorme-e7292.firebaseio.com/users")
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
       // FBSDKAppEvents.activateApp()
    }

}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
    
    /*func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }*/
}
// [END ios_10_message_handling]
// [START ios_10_data_message_handling]
extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}
