//
//  SettingsTableViewController.swift
//  ParseBandApp
//
//  Created by Zoe Sheill on 7/18/16.
//  Copyright © 2016 Parse. All rights reserved.
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
        //self.tableView?.addBlueBackground("mixed2")
       
        self.view.addBackground()
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
        
        /*print("test1")
        if let marchingInst = FIRAuth.auth()?.currentUser!["marchingInstrument"] as? String {
            print("test2")
            self.marchingInst.text! = marchingInst
        }
        
        if let concertInst = FIRAuth.auth()?.currentUser!["concertInstrument"] as? String {
            print("test2")
            self.concertInst.text! = concertInst
        }
        if let concertBandType = FIRAuth.auth()?.currentUser!["concertBandType"] as? String {
            print("test2")
            self.ensemble.text! = concertBandType
        }*/
        /*marchingInstCell.tag = 1
        concertInstCell.tag = 2
        ensembleTypeCell.tag = 3*/
        
        
        
        var frame: CGRect = table.frame;
        frame.size.height = table.contentSize.height
        table.frame = frame
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
     
        
       /* if let marchingInst = FIRAuth.auth()?.currentUser!["marchingInstrument"] as? String {
            
            self.marchingInst.text! = marchingInst
        }
        
        if let concertInst = FIRAuth.auth()?.currentUser!["concertInstrument"] as? String {

            self.concertInst.text! = concertInst
        }
        if let concertBandType = FIRAuth.auth()?.currentUser!["concertBandType"] as? String {
            print("test3")
            self.ensemble.text! = concertBandType
        }*/
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_one" {
            /*let tableVC: SettingsInstrumentsTableViewController = segue.destination as! SettingsInstrumentsTableViewController
            
            tableVC.cellTag = 1
          
            tableVC.title = "Marching Instrument"*/
            
            let tableVC: SettingsBasicInfoTableViewController = segue.destination as! SettingsBasicInfoTableViewController
            
            tableVC.currentUser = currentUser
            
            tableVC.title = "Basic Info"
            
        } else if segue.identifier == "segue_two" {
            /*let tableVC: SettingsInstrumentsTableViewController = segue.destination as! SettingsInstrumentsTableViewController
            
            tableVC.cellTag = 2
            tableVC.title = "Concert Instrument"*/
            let tableVC: SettingsAvailabilityTableViewController = segue.destination as! SettingsAvailabilityTableViewController
            
            tableVC.currentUser = currentUser
            
            tableVC.title = "Availability"
            
        } else if segue.identifier == "segue_three" {
            /*let tableVC: SettingsInstrumentsTableViewController = segue.destination as! SettingsInstrumentsTableViewController
            
            tableVC.cellTag = 3
            tableVC.title = "Concert Band"*/
            
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
                
                
            })))
            alert.addAction((UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
               
                
            })))
            
            self.present(alert, animated: true, completion: nil)
       

    }
    
    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        logoutPressed()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 1 {
            logoutPressed()
        } /*else if indexPath.section == 1 && indexPath.row == 0 {
            goBackToConsole()
        }*/ else if indexPath.section == 2 && indexPath.row == 0 {
            deleteAccountPressed()
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
        /*let alert = UIAlertController(title: "Logout", message: "Do you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction((UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 50,height: 50))
            self.activityIndicator.center = self.view.center
            self.activityIndicator.hidesWhenStopped = true
            self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            try! FIRAuth.auth()!.signOut()
            
            let initialStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let loginNC = initialStoryboard.instantiateViewController(withIdentifier: "loginNC")
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            self.present(loginNC, animated: true, completion: nil)
        

        })))
        alert.addAction((UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            
        })))
        
        self.present(alert, animated: true, completion: nil)*/
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

    /*override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel!.textColor = UIColor.titleGreen()
    }*/
    
    
}
