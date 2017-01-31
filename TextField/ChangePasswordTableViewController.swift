//
//  ChangePasswordTableViewController.swift
//  ParseBandApp
//
//  Created by Zoe Sheill on 7/18/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit


class ChangePasswordTableViewController: UITableViewController {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var user = FIRAuth.auth()?.currentUser
    
    func displayAlert(_ title: String, message: String) {
        
        if #available(iOS 8.0, *) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction((UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                
                //self.dismissViewControllerAnimated(true, completion: nil)
                
            })))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            print("error")
        }
        
        
        
    }
    
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBOutlet weak var oldPasswordField: UITextField!
    
    @IBOutlet weak var newPasswordField: UITextField!
    
    @IBAction func confirmButton(_ sender: AnyObject) {
        
        
        
        if oldPasswordField.text == "" || newPasswordField.text == "" || confirmPasswordField.text == "" {
            
            displayAlert("Error", message: "Please enter your old and new passwords")
            
        } else if newPasswordField.text!.characters.count < 5 {
            self.displayAlert("Not Long Enough", message: "Please enter a password that is 5 or more characters")
        } else if newPasswordField.text != confirmPasswordField.text {
            self.displayAlert("Passwords Do Not Match", message: "Please re-enter passwords")
        } else if user!.password == oldPasswordField.text {
            self.displayAlert("Old Password is Incorrect", message: "Please re-enter passwords")
        }else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            user!.password = newPasswordField.text!
            
            user!.saveInBackground()
            
            UIApplication.shared.endIgnoringInteractionEvents()
            activityIndicator.stopAnimating()
            
            if #available(iOS 8.0, *) {
                let alert = UIAlertController(title: "Success!", message: "Your password has been changed", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction((UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    
                    self.dismiss(animated: true, completion: nil)
                    self.performSegue(withIdentifier: "passToSettings", sender: self)
                    
                })))
                
                self.present(alert, animated: true, completion: nil)
            } else {
                print("error")
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel!.textColor = UIColor(red: 151.0/255, green: 193.0/255, blue: 100.0/255, alpha: 1)
        
    }
}
