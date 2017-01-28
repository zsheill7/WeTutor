/*
 * Copyright (c) 2017 Zoe Sheill
 *
 */

import UIKit
import Material
import Firebase
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        
        FIRApp.configure()
        
        var navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = UIColor(netHex: 0x51679F)
        navigationBarAppearance.tintColor = UIColor.white
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 18)!]
        
        
        let userDefaults = UserDefaults.standard
        if let isTutor = userDefaults.value(forKey: "isTutor") as? Bool,
            let hasLanguages = userDefaults.value(forKey: "languages") as? [String],
            let uid = FIRAuth.auth()?.currentUser?.uid {
            if isTutor == true {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Tutor", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tutorPagingMenuNC") as! UINavigationController
                window?.rootViewController = viewController
                //self.present(viewController, animated: true, completion: nil)
            } else {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Tutee", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tuteePagingMenuNC") as! UINavigationController
                window?.rootViewController = viewController
               // self.present(viewController, animated: true, completion: nil)
            }
        }
        let userID = FIRAuth.auth()?.currentUser?.uid
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let userObject = User(snapshot: snapshot )
            
            let value = snapshot.value as? NSDictionary
            let languages = userObject.languages
            let isTutor = userObject.isTutor
            
            if languages != nil && isTutor != nil {
                if isTutor == true {
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Tutor", bundle: nil)
                    let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tutorPagingMenuNC") as! UINavigationController
                    self.window?.rootViewController = viewController
                    //self.present(viewController, animated: true, completion: nil)
                } else {
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Tutee", bundle: nil)
                    let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tuteePagingMenuNC") as! UINavigationController
                    self.window?.rootViewController = viewController
                    // self.present(viewController, animated: true, completion: nil)
                }
            }
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    //let ref = Firebase(url:"https://tutorme-e7292.firebaseio.com/users")
}
