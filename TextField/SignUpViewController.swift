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
import Firebase
import SCLAlertView



extension UIView {
    func addBackground(imageName: String) {
        // screen width and height:
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let newWidth = height * 2.0
        
        //let rect = CGRect(origin: CGPoint(x: -newWidth / 2,y : 0), size: CGSize(width: newWidth, height: height * 1.75))
        //let rect = CGRect(origin: CGPoint(x: -newWidth / 2 + 400,y : 0), size: CGSize(width: newWidth, height: height * 2))
        let rect = CGRect(origin: CGPoint(x: -newWidth / 2 - 100,y : 0), size: CGSize(width: newWidth, height: height * 1.2))
        
        let imageViewBackground = UIImageView(frame: rect)
        imageViewBackground.image = UIImage(named: imageName)
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubview(toBack: imageViewBackground)
    }
}

class SignUpViewController: UIViewController {
    private var nameField: TextField!
    private var emailField: ErrorTextField!
    private var passwordField: TextField!
    private var confirmPasswordField: TextField!
    let kInfoTitle = "Info"
    let kSubtitle = "You've just displayed this awesome Pop Up View"
    let blueColor: Int! = 0x22B573
    
    var ref: FIRDatabaseReference!
    
    func displayAlert(title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)

    }
    /// A constant to layout the textFields.
    private let constant: CGFloat = 32
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        /*self.view.backgroundColor = UIColor.init(
            gradientStyle: UIGradientStyle.leftToRight,
            withFrame: self.view.frame,
            andColors: [ Color.blue.lighten4, Color.blue.lighten4 ]
        )*/
        /*UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "blur-images-18")?.draw(in: self.view.bounds)*/
        self.view.addBackground(imageName: "mixed2")
        //self.view.backgroundColor = UIColor.newSkyBlue()
        /*var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)*/
        
        RZTransitionsManager.shared().defaultPresentDismissAnimationController = RZZoomAlphaAnimationController()
        RZTransitionsManager.shared().defaultPushPopAnimationController = RZCardSlideAnimationController()
        
        prepareNameField()
        prepareEmailField()
        preparePasswordField()
        prepareConfirmPasswordField()
        prepareNextButton()
        prepareForgotPasswordButton()
        prepareLoginButton()
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
                    if isTutor == true {
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Tutor", bundle: nil)
                        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tutorPagingMenuNC") as! UINavigationController
                        self.present(viewController, animated: true, completion: nil)
                    } else {
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Tutee", bundle: nil)
                        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tuteePagingMenu NC") as! UINavigationController
                        self.present(viewController, animated: true, completion: nil)
                    }
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
    
    func createAccount() {
        if emailField.text == "" || nameField.text == "" || passwordField.text == "" || confirmPasswordField.text == "" {
            displayAlert(title: "Error", message: "Please complete all fields")
            
        } else if emailField.text?.isEmail() == false{
            displayAlert(title: "Error", message: "\"\(emailField.text!)\" is not a valid email address")
        
        } else if passwordField.text!.characters.count < 6 {
            self.displayAlert(title: "Not Long Enough", message: "Please enter a password that is 6 or more characters")
        } else if passwordField.text != confirmPasswordField.text {
            self.displayAlert(title: "Passwords Do Not Match", message: "Please re-enter passwords")
        } else {
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
                if error == nil {
                    print("You have successfully signed up")
                    
                    self.ref = FIRDatabase.database().reference()
                    self.ref.child("users").child((user?.uid)!).setValue(
                        ["name": self.nameField.text])
                    let userDefaults = UserDefaults.standard
                    userDefaults.setValue(self.emailField.text!, forKey: "email")
                    userDefaults.setValue(self.passwordField.text!, forKey: "password")
                    userDefaults.setValue(self.nameField.text!, forKey: "name")
                    
                    self.performSegue(withIdentifier: "goToTutorOrTutee", sender: self)
                    
                    
                } else {
                    self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
                }
            })
        }
    }
    
    /// Programmatic update for the textField as it rotates.
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        emailField.width = view.height - 2 * constant
    }
    
    /// Prepares the resign responder button.
    /*private func prepareResignResponderButton() {
        let btn = RaisedButton(title: "Resign", titleColor: Color.blue.base)
    
        btn.addTarget(self, action: #selector(handleResignResponderButton(button:)), for: .touchUpInside)
        
        view.layout(btn).width(100).height(constant).top(24).right(24)
    }*/
    private func prepareNextButton() {
        /*let btn = UIButton()
        btn.setImage(UIImage(named: "nextButton-1"), for: .normal)*/
        let btn = RaisedButton(title: "Sign Up", titleColor: Color.grey.lighten3)
        btn.backgroundColor = UIColor.flatBlue
        
        
        btn.addTarget(self, action: #selector(handleNextButton(button:)), for: .touchUpInside)
        
        view.layout(btn).width(310).height(constant).top(13 * constant).centerHorizontally()    }
    
    private func prepareForgotPasswordButton() {
        //let btn = RaisedButton(title: "Forgot Password?", titleColor: UIColor.textGray())
        
        let btn: UIButton! = UIButton()
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.setTitleColor(UIColor.flatBlue, for: .highlighted)
        btn.titleLabel!.font =  UIFont(name: "HelveticaNeue", size: 16)
        //btn.title = "Forgot Password?"
        btn.setTitle("Forgot Password?", for: UIControlState.normal)
        btn.addTarget(self, action: #selector(handleForgotPasswordButton(button:)), for: .touchUpInside)
        
        view.layout(btn).width(150).height(constant).top(15 * constant).centerHorizontally()    }
    
    private func prepareLoginButton() {
        //let btn = RaisedButton(title: "Forgot Password?", titleColor: UIColor.textGray())
        
        let btn: UIButton! = UIButton()
        btn.setTitleColor(UIColor.darkGray, for: .normal)
        btn.setTitleColor(UIColor.flatBlue, for: .highlighted)
        btn.titleLabel!.font =  UIFont(name: "HelveticaNeue", size: 16)
        
        btn.setTitle("Already Registered? Log In", for: UIControlState.normal)
        btn.addTarget(self, action: #selector(handleLogInButton(button:)), for: .touchUpInside)
        
        view.layout(btn).width(210).height(constant).top(16 * constant).centerHorizontally()    }

    
    //
    @objc
    internal func handleResignResponderButton(button: UIButton) {
        nameField?.resignFirstResponder()
        emailField?.resignFirstResponder()
        passwordField?.resignFirstResponder()
        confirmPasswordField?.resignFirstResponder()

    }
    internal func handleNextButton(button: UIButton) {
       createAccount()
        
    }
    internal func handleForgotPasswordButton(button: UIButton) {
        //SCLAlertView().showInfo("Hello Info", subTitle: "This is a more descriptive info text.") // Info
        print("hello")
        createForgotPasswordAlert()
    }
    internal func handleLogInButton(button: UIButton) {
        //SCLAlertView().showInfo("Hello Info", subTitle: "This is a more descriptive info text.") // Info
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "loginNC") as! UINavigationController
        controller.modalTransitionStyle = .flipHorizontal
        self.present(controller, animated: true, completion: nil)
        
        //createForgotPasswordAlert()
    }
    
    func createForgotPasswordAlert() {
        /*let alertView = SCLAlertView()
        alertView.showInfo("Reset Password", subTitle: "Please enter your email for a password reset link.")
        let emailField = alertView.addTextField("Email:")*/
        
        
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false
                                                    /*contentViewColor: UIColor.alertViewBlue()*/)
        let alert = SCLAlertView(appearance: appearance)
        let emailTextField = alert.addTextField("Email")
        
        /*_ = alert.addButton("Show Name") {
            print("Text value: \(txt.text)")
        }*/
        
      
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
        
        
        /*_ = alert.addButton("Cancel") {
            print("Second button tapped")
        }*/
        _ = alert.showEdit("Reset Password", subTitle:"Please enter your email for a password reset link.")
        //emailButton.backgroundColor = UIColor.alertViewBlue()
        //closeButton.backgroundColor = UIColor.alertViewBlue()
        //emailTextField.borderColor = UIColor.alertViewBlue()
        
    }
    
    private func prepareNameField() {
        nameField = TextField()
        //nameField.addBackground(imageName: "Rectangle 8")
        //nameField.background = UIImage(named: "Rectangle 8")
        nameField.placeholder = "Name"
        //nameField.detail = "Your given name"
        nameField.isClearIconButtonEnabled = true
        
        let leftView = UIImageView()
        leftView.image = Icon.star
        
        nameField.leftView = leftView
        nameField.leftViewMode = .always
        
        view.layout(nameField).top(4 * constant).horizontally(left: constant, right: constant)
    }
    
    private func prepareEmailField() {
        emailField = ErrorTextField(frame: CGRect(x: constant, y: 6 * constant, width: view.width - (2 * constant), height: constant))
        emailField.placeholder = "Email"
        emailField.detail = "Error, incorrect email"
        emailField.isClearIconButtonEnabled = true
        emailField.delegate = self
        
        let leftView = UIImageView()
        leftView.image = Icon.email
        
        emailField.leftView = leftView
        emailField.leftViewMode = .always
        //emailField.leftViewNormalColor = .brown
        //emailField.leftViewActiveColor = .blue
        
        // Set the colors for the emailField, different from the defaults.
//        emailField.placeholderNormalColor = Color.amber.darken4
//        emailField.placeholderActiveColor = Color.pink.base
//        emailField.dividerNormalColor = Color.cyan.base
//        emailField.dividerActiveColor = Color.green.base
        
        view.addSubview(emailField)
    }
    
    private func preparePasswordField() {
        passwordField = TextField()
        passwordField.placeholder = "Password"
        //passwordField.detail = "At least 8 characters"
        passwordField.clearButtonMode = .whileEditing
        passwordField.isVisibilityIconButtonEnabled = true
        
        // Setting the visibilityIconButton color.
        passwordField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        
        let leftView = UIImageView()
         leftView.image = UIImage(named: "Lock-104")?.imageResize(sizeChange: CGSize(width: 27, height: 27))
        
        passwordField.leftView = leftView
        passwordField.leftViewMode = .always
        passwordField.leftViewNormalColor = .brown
        passwordField.leftViewActiveColor = .green
        
        view.layout(passwordField).top(8 * constant).horizontally(left: constant, right: constant)
    }
    
    private func prepareConfirmPasswordField() {
        confirmPasswordField = TextField()
        confirmPasswordField.placeholder = "Confirm Password"
        confirmPasswordField.detail = "At least 6 characters"
        confirmPasswordField.clearButtonMode = .whileEditing
        confirmPasswordField.isVisibilityIconButtonEnabled = true
        
        // Setting the visibilityIconButton color.
        confirmPasswordField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        
        let leftView = UIImageView()
        leftView.image = UIImage(named: "Lock-104")?.imageResize(sizeChange: CGSize(width: 27, height: 27))
        
        confirmPasswordField.leftView = leftView
        confirmPasswordField.leftViewMode = .always
        confirmPasswordField.leftViewNormalColor = .brown
        confirmPasswordField.leftViewActiveColor = .green

        
        view.layout(confirmPasswordField).top(10 * constant).horizontally(left: constant, right: constant)
    }
}

extension UIViewController: TextFieldDelegate {
    /// Executed when the 'return' key is pressed when using the emailField.
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = true
        return true
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        (textField as? ErrorTextField)?.isErrorRevealed = false
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
    
    public func textField(textField: UITextField, didChange text: String?) {
        //print("did change", text ?? "")
    }
    
    public func textField(textField: UITextField, willClear text: String?) {
        print("will clear", text ?? "")
    }
    
    public func textField(textField: UITextField, didClear text: String?) {
        print("did clear", text ?? "")
    }
}

