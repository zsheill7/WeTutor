//
//  ChangeemailTableViewController.swift
//  WeTutor
//
//  Created by Zoe Sheill on 7/18/16.
//

import UIKit
import Firebase
import SCLAlertView

class ChangePasswordTableViewController: UITableViewController {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var user = FIRAuth.auth()?.currentUser

    var ref: FIRDatabaseReference!
    func displayAlert(title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)

    }
    
    override func viewDidLoad() {
        ref = FIRDatabase.database().reference()
       // self.view?.backgroundColor = UIColor.backgroundBlue()
    }
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBOutlet weak var oldEmailField: UITextField!
    
    @IBOutlet weak var newEmailField: UITextField!
    
    @IBOutlet weak var confirmEmailField: UITextField!
    
    @IBOutlet weak var resetEmailField: UITextField!

    
    @IBAction func confirmButton(_ sender: AnyObject) {
        
        
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let email = value?["email"] as? String ?? ""
            
            
            var userID = self.user?.uid
            if self.oldEmailField.text == "" || self.newEmailField.text == "" || self.confirmEmailField.text == "" {
                
                self.displayAlert(title: "Error", message: "Please enter your old and new emails")
                
            } else if self.isValidEmail(testStr: self.newEmailField.text!) == false {
                //self.displayAlert(title: "Not Long Enough", message: "Please enter a email that is 5 or more characters")
                self.displayAlert(title: "Not a Valid Email", message: "Please enter new email")
            } else if self.newEmailField.text != self.confirmEmailField.text {
                self.displayAlert(title: "Emails Do Not Match", message: "Please re-enter emails")
            } else if email != self.oldEmailField.text {
                self.displayAlert(title: "Old Email is Incorrect", message: "Please re-enter emails")
            }else {
                
                self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                self.activityIndicator.center = self.view.center
                self.activityIndicator.hidesWhenStopped = true
                self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                self.view.addSubview(self.activityIndicator)
                self.activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()
                
                
                FIRAuth.auth()?.currentUser?.updateEmail(self.newEmailField.text!, completion: { (error) in
                    if error != nil {
                        self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
                    } else {
                        self.displayAlert(title: "Success!", message: "Your email has been changed")
                    }
                })
                
                UIApplication.shared.endIgnoringInteractionEvents()
                self.activityIndicator.stopAnimating()
                
                
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
       
    }
    
    @IBAction func sendResetEmail(_ sender: Any) {
        if resetEmailField.text == nil {
            
        } else if self.isValidEmail(testStr: self.newEmailField.text!) == false {

            self.displayAlert(title: "Not a Valid Email", message: "Please enter new email")
        } else {
            FIRAuth.auth()?.sendPasswordReset(withEmail: resetEmailField.text!) { (error) in
                if error != nil {
                    self.displayAlert(title: "Unable to Send Reset Email", message: "Please try again later")
                } else {
                    self.displayAlert(title: "Success!", message: "Password reset email sent")
                }
            }
        }

    }
    
   
}
