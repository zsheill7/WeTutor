//
//  SettingsTableViewController.swift
//  WeTutor
//
//  Created by Zoe Sheill on 7/18/16.
//  Copyright © 2016 TokkiTech. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView


extension UIColor {

    
    class func maroon() -> UIColor {
        return UIColor(red:0.55, green:0.09, blue:0.09, alpha:1.0)
    }
    
    class func titleGreen() -> UIColor {
        return UIColor(red: 145.0/255, green: 193.0/255, blue: 100.0/255, alpha: 1)
    }
    
    class func buttonBlue() -> UIColor {
        return UIColor(red:0.19, green:0.54, blue:0.98, alpha:1.0)
    }
    
    class func lightGray() -> UIColor {
        return UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
    }
}

class SettingsTableViewController: UITableViewController {

    
    func displayAlert(title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)
        
    }
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    @IBOutlet var table: UITableView!
   
    @IBOutlet weak var marchingInstCell: UITableViewCell!
    
    @IBOutlet weak var concertInstCell: UITableViewCell!
     @IBOutlet weak var ensembleTypeCell: UITableViewCell!
    
    @IBOutlet weak var marchingInst: UILabel!
    
    @IBOutlet weak var concertInst: UILabel!

    
    @IBOutlet weak var ensemble: UILabel!
    
    var userID = FIRAuth.auth()?.currentUser?.uid
    var ref: FIRDatabaseReference!
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         ref = FIRDatabase.database().reference()
        print("userID")
        print(userID)
        print(ref.child("users").child(userID!))
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            print("inside observeSingleEvent")
            let value = snapshot.value as? NSDictionary
            let username = value?["email"] as? String ?? ""
            print(username)
            self.currentUser = User(snapshot: snapshot)
            print(self.currentUser)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        var frame: CGRect = table.frame;
        frame.size.height = table.contentSize.height
        table.frame = frame
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueId  = segue.identifier
        if segueId == "toBasicInfo" {
            
            let tableVC: SettingsBasicInfoTableViewController = segue.destination as! SettingsBasicInfoTableViewController
            
            tableVC.currentUser = currentUser
            
            tableVC.title = "Basic Info"
        } else if segueId == "toAvailability" {
            
            let tableVC: SettingsAvailabilityTableViewController = segue.destination as! SettingsAvailabilityTableViewController
            
            tableVC.currentUser = currentUser
            
            tableVC.title = "Availability"
        } else if segueId == "toSelfProfileVC" {
            let tableVC: SelfProfileViewController = segue.destination as! SelfProfileViewController
            tableVC.currentUser = currentUser
        }
        
    }
    
    @IBAction func deleteAccountButtonPressed(_ sender: AnyObject) {
        deleteAccountPressed()
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        goBackToConsole()
    }
    
    @IBAction func saveChanges(_ sender: Any) {
        goBackToConsole()
        
    }
    func goBackToConsole() {
        let storyboard = UIStoryboard(name: "Tutor", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "tutorPagingMenuNC") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }
    
   /* override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.7)
    }*/
    
   func deleteAccountPressed() {
 
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Delete Account", target:self, selector:#selector(SettingsTableViewController.logOut))
        alertView.addButton("Cancel") {
            print("Second button tapped")
        }

    
            let alert = UIAlertController(title: "Are you sure you want to delete your account?", message: "All saved settings will be lost", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction((UIAlertAction(title: "Delete Account", style: .destructive, handler: { (action) -> Void in
               
                
                self.deleteAccount()
                
                
            })))
            alert.addAction((UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
               
                
            })))
            
            self.present(alert, animated: true, completion: nil)
       

    }
    
    func deleteAccount() {
         let user = FIRAuth.auth()?.currentUser
        user?.delete { error in
            if error != nil {
                // An error happened.
            } else {
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let createAccountNC = mainStoryboard.instantiateViewController(withIdentifier: "initialNC")
                self.present(createAccountNC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        logoutPressed()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            self.performSegue(withIdentifier: "toBasicInfo", sender: self)
        case (0, 1):
            self.performSegue(withIdentifier: "toAvailability", sender: self)
        case (0, 2):
            self.performSegue(withIdentifier: "toSelfProfileVC", sender: self)
        case (1, 0):
            self.performSegue(withIdentifier: "toChangePassword", sender: self)
        case (1, 1):
            logoutPressed()
        case (2, 0):
            deleteAccountPressed()
        default:
            break;
        }
    }
    func logoutPressed() {
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("OK", target:self, selector:#selector(SettingsTableViewController.logOut))
        alertView.addButton("Cancel") {
            print("Second button tapped")
        }
        alertView.showInfo("Logout", subTitle: "Do you want to log out?")
    }
    func logOut() {
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 50,height: 50))
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        try! FIRAuth.auth()!.signOut()
        
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "isTutor")
        userDefaults.removeObject(forKey: "languages")
        userDefaults.removeObject(forKey: "description")
        
        userDefaults.synchronize()
        
        let initialStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNC = initialStoryboard.instantiateViewController(withIdentifier: "loginNC")
        
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        
        self.present(loginNC, animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 && indexPath.row == 1 {
            return 0.0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
}
