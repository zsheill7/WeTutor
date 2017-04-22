/*
 * Copyright (C) 2015 - 2016, Zoe Sheill>.
 * All rights reserved.
 *
 */

import UIKit
import Material
import ChameleonFramework
import RZTransitions
import FirebaseAuth
import FirebaseDatabase
import SCLAlertView
import FirebaseAnalytics


class LoginViewController: UIViewController {
    fileprivate var nameField: TextField!
    fileprivate var emailField: ErrorTextField!
    fileprivate var passwordField: TextField!
    fileprivate var confirmPasswordField: TextField!
    let kInfoTitle = "Info"
    let kSubtitle = "You've just displayed this awesome Pop Up View"
    let blueColor: Int! = 0x22B573
    
    var ref: FIRDatabaseReference!
    
    func displayAlert(_ title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)
        
    }
    /// A constant to layout the textFields.
    fileprivate let constant: CGFloat = 32
    var horizConstant: CGFloat = 32
    let userDefaults = UserDefaults.standard
    
    let lightGrayColor = UIColor.lightGray.lighten(byPercentage: 0.1)!
    
    let screenHeight = UIScreen.main.bounds.size.height
    var IS_IPHONE = Bool()
    var IS_IPAD  = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IS_IPHONE = screenHeight <= CGFloat(1000.0)
        IS_IPAD  = screenHeight > CGFloat(1000.0)
        
        if IS_IPAD {
            horizConstant = 100
        }
        
      self.view.addBackground("book.png")
     
        
        RZTransitionsManager.shared().defaultPresentDismissAnimationController = RZZoomAlphaAnimationController()
        RZTransitionsManager.shared().defaultPushPopAnimationController = RZCardSlideAnimationController()
        
        prepareEmailField()
        preparePasswordField()
        prepareNextButton()
        prepareForgotPasswordButton()
        prepareSignupButton()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func alreadySignedIn() {
        ref = FIRDatabase.database().reference()
        let currentUserUID = FIRAuth.auth()?.currentUser?.uid
        if currentUserUID != nil {
            
            ref.child("users").child(currentUserUID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let isTutor = value?["isTutor"] as? Bool
                if isTutor != nil {
                    
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Tutor", bundle: nil)
                    let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tutorPagingMenuVC") as! PagingMenuViewController
                    self.present(viewController, animated: true, completion: nil)
                   
                }
                
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
            
            /**/
        } else {
            // No user is signed in.
            // ...
        }
    }
       
    func instantiateNextVC() {
        
    }
    func logIn() {
        if self.emailField.text == "" || self.passwordField.text == "" {
            self.displayAlert("Error", message: "Please enter an email and password.")
        } else {
            FIRAuth.auth()?.signIn(withEmail: self.emailField.text!, password: self.passwordField.text!, completion: { (user, error) in
                if error == nil {
                    print("sign user.uid \(user?.uid) \(FIRAuth.auth()?.currentUser?.uid)")
                 //   print
                    /*if !(user?.isEmailVerified)!{
                     
                        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false
                            /*contentViewColor: UIColor.alertViewBlue()*/)
                        let alert = SCLAlertView(appearance: appearance)
                       // let emailTextField = alert.addTextField("Email")
                        
                        let emailButton = alert.addButton("Okay") {
                            
                            user?.sendEmailVerification(completion: nil)
                            
                        }
                        let closeButton = alert.addButton("Cancel") {
                            print("close")
                        }
                        
                        _ = alert.showInfo("Error", subTitle: "Your email address has not yet been verified. Would you like us to send another verification email to \(self.emailField.text!)?")
                       // _ = alert.showInfo("Reset Password", subTitle:"Please enter your email for a password reset link.")
  
                    } else {*/
                        print ("Email verified. Signing in...")
                    
                    //self.emailField.text!
                    var ref: FIRDatabaseReference!
                    
                    ref = FIRDatabase.database().reference()
                    
                    //let userID = FIRAuth.auth()?.currentUser?.uid
                    ref.child("users").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        let userObject = User(snapshot: snapshot )

                        
                      //  let value = snapshot.value as? NSDictionary
                        let languages = userObject.languages
                        let isTutor = userObject.isTutor
                        let description = userObject.description
                        
                        print(languages)
                        print(isTutor)
                        let userDefaults = UserDefaults.standard
                        
                        
                        
                        userDefaults.setValue(isTutor, forKey: "isTutor")
                        userDefaults.setValue(languages, forKey: "languages")
                        userDefaults.setValue(description, forKey: "description")
                        
                        userDefaults.synchronize()

                        if userObject.email == "" {
                            /*FriendSystem.system.createAccount(self.emailField.text!, password: passwordField.text!, name: self.nameField.text!) { (success) in
                                if success {
                                    print("You have successfully signed up")
                                    
                                   self.performSegue(withIdentifier: "toTutorOrTuteeVC", sender: self)
                                } else {
                                    //self.displayAlert(title: "Unable to Sign Up", message: "Please try again later"/*error.localizedDescription*/)
                                }
                            }*/
                            let user = FIRAuth.auth()?.currentUser
                            
                            user?.delete { error in
                                if let error = error {
                                    // An error happened.
                                } else {
                                    // Account deleted.
                                }
                            }
                            self.displayAlert("Error", message: "Please create an account again")
                           
                        } else {
                        
                            FIRAnalytics.logEvent(withName: "logged_in", parameters: [
                                "name": userObject.name as NSObject,
                                "is_tutor": userObject.isTutor as NSObject
                                ])
                            
                            if description.characters.count > 0{
                                self.performSegue(withIdentifier: "toPagingMenuVC", sender: self)
                            } else {
                                self.performSegue(withIdentifier: "toTutorOrTuteeVC", sender: self)
                            }
                        }
                        
                        
                        // ...
                    }) { (error) in
                        let noInternetError = "Network error (such as timeout, interrupted connection or unreachable host) has occurred."
                        let invalidPasswordError = "The password is invalid or the user does not have a password."
                        
                        var errorMessage = error.localizedDescription
                        if error.localizedDescription == noInternetError {
                            errorMessage = "Please check your internet connection and try again later."
                        }
                        if error.localizedDescription == invalidPasswordError {
                            errorMessage = "The username or password is incorrect."
                        }
                        
                        self.displayAlert("Unable to Log In", message: errorMessage)
                        
                    }
                    

                } else {
                    self.displayAlert("Error", message: (error?.localizedDescription)!)
                }
            })
        }
    }
    
    
    
    /// Programmatic update for the textField as it rotates.
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        emailField.width = view.height - 2 * horizConstant
    }
    fileprivate func prepareNextButton() {
        
        let btn = RaisedButton(title: "Log In", titleColor: Color.grey.lighten3)
         btn.backgroundColor = UIColor(netHex: 0x51679F)//UIColor.titleBlue().lighten(byPercentage: 0.08)
        
        
        btn.addTarget(self, action: #selector(handleNextButton(_ :)), for: .touchUpInside)
        var verticalMult: CGFloat = 13
        
        if IS_IPAD {
            verticalMult = 11
        }
        view.layout(btn).top(verticalMult * constant).horizontally(left: horizConstant, right: horizConstant)        //view.layout(btn).width(310).height(constant).top(13 * constant).centerHorizontally()
    }
    
    fileprivate func prepareForgotPasswordButton() {
        let btn: UIButton! = UIButton()
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(lightGrayColor, for: .highlighted)
        btn.titleLabel!.font =  UIFont(name: "HelveticaNeue", size: 16)
        btn.setTitle("Forgot Your Password?", for: UIControlState.normal)
        btn.addTarget(self, action: #selector(handleForgotPasswordButton(_ :)), for: .touchUpInside)
        
        var verticalMult: CGFloat = 15
        if IS_IPAD {
            verticalMult = 12.5
        }
        
        view.layout(btn).width(200).height(constant).top(verticalMult * constant).centerHorizontally()
    }
    
    fileprivate func prepareSignupButton() {
        let btn: UIButton! = UIButton()
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(lightGrayColor, for: .highlighted)
        btn.titleLabel!.font =  UIFont(name: "HelveticaNeue", size: 16)
        
        btn.setTitle("Sign Up for an Account", for: UIControlState.normal)
        btn.addTarget(self, action: #selector(handleSignUpButton(_ :)), for: .touchUpInside)
        
        var verticalMult: CGFloat = 16
        if IS_IPAD {
            verticalMult = 13.5
        }
        
        view.layout(btn).width(210).height(constant).top(verticalMult * constant).centerHorizontally()
    }
    
    
    //
    @objc
    internal func handleResignResponderButton(_ button: UIButton) {
        nameField?.resignFirstResponder()
        emailField?.resignFirstResponder()
        passwordField?.resignFirstResponder()
        confirmPasswordField?.resignFirstResponder()
        
    }
    internal func handleNextButton(_ button: UIButton) {
        logIn()
        
    }
    internal func handleForgotPasswordButton(_ button: UIButton) {
               print("hello")
        createForgotPasswordAlert()
    }
    internal func handleSignUpButton(_ button: UIButton) {
      
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "signupNC") as! UINavigationController
        controller.modalTransitionStyle = .flipHorizontal
        self.present(controller, animated: true, completion: nil)
    }
    func resetIsTutor() {
        let userID = FIRAuth.auth()?.currentUser?.uid
        var ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
 
            let userObject = User(snapshot: snapshot )
            
            let value = snapshot.value as? NSDictionary
            let languages = userObject.languages
            let isTutor = userObject.isTutor
            
            let userDefaults = UserDefaults.standard
            
            userDefaults.setValue(isTutor, forKey: "isTutor")
            
            userDefaults.synchronize()
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func createForgotPasswordAlert() {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        let emailTextField = alert.addTextField("Email")
        
        
        
        let emailButton = alert.addButton("Send Email") {
            if emailTextField.text != nil {
                if emailTextField.text?.isEmail() == false {
                    SCLAlertView().showInfo("Error", subTitle: "Please enter a valid email.")
                } else {
                    FIRAuth.auth()?.sendPasswordReset(withEmail: emailTextField.text!, completion: { (error) in
                       var title = ""
                        var message = ""
                        
                        if error != nil {
                            title = "Error!"
                            message = (error?.localizedDescription)!
                        } else {
                            title = "Success!"
                            message = "Password reset email sent."
                            self.emailField.text = ""
                        }
                        SCLAlertView().showInfo("Success!", subTitle: "Password reset email sent.")
                    })
                }
            }
        }
        let closeButton = alert.addButton("Cancel") {
            print("close")
        }
        
        _ = alert.showInfo("Reset Password", subTitle:"Please enter your email for a password reset link.")
    }
    
    let lightPurpleColor = UIColor(netHex: 0x51679F).lighten(byPercentage: 0.9)!
    
    fileprivate func prepareEmailField() {
        emailField = ErrorTextField(frame: CGRect(x: horizConstant, y: 6 * constant, width: view.width - (2 * horizConstant), height: constant))
        emailField.placeholder = "Email"
        emailField.detail = "Error, incorrect email"
        emailField.isClearIconButtonEnabled = true
        emailField.textColor = UIColor.white
        emailField.tintColor = UIColor.white
        emailField.placeholderNormalColor = UIColor.white
        emailField.dividerColor = UIColor.white
        emailField.dividerNormalColor = UIColor.white
        emailField.leftViewNormalColor = UIColor.white
        emailField.delegate = self
        emailField.dividerActiveColor = lightPurpleColor
        emailField.leftViewActiveColor = lightPurpleColor
        emailField.placeholderActiveColor =  lightPurpleColor
        let leftView = UIImageView()
        leftView.image = Icon.email
        
        emailField.leftView = leftView
        emailField.leftViewMode = .always
       
        
        view.addSubview(emailField)
    }
    
    fileprivate func preparePasswordField() {
        passwordField = TextField()
        passwordField.placeholder = "Password"
        passwordField.clearButtonMode = .whileEditing
        passwordField.isVisibilityIconButtonEnabled = true
        passwordField.placeholderNormalColor = UIColor.white
        passwordField.dividerColor = UIColor.white
        // Setting the visibilityIconButton color.
        passwordField.dividerNormalColor = UIColor.white
         passwordField.textColor = UIColor.white
        passwordField.tintColor = UIColor.white
        passwordField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        passwordField.dividerActiveColor = lightPurpleColor
        passwordField.leftViewActiveColor = lightPurpleColor
        passwordField.placeholderActiveColor =  lightPurpleColor

        let leftView = UIImageView()
        leftView.image = UIImage(named: "Lock white")?.imageResize(CGSize(width: 27, height: 27))
        
        passwordField.leftView = leftView
        passwordField.leftViewMode = .always
        passwordField.leftViewNormalColor = .brown
        passwordField.leftViewActiveColor = .green
        
        view.layout(passwordField).top(8 * constant).horizontally(left: horizConstant, right: horizConstant)
    }
    
}



