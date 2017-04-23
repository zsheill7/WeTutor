/*
 * Copyright (C) 2017, Zoe Sheill.
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
import FBSDKCoreKit
import FBSDKLoginKit
import Popover

extension UIView {
    func addBackground(_ imageName: String) {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let newWidth = height * 2.1
       
        let rect = CGRect(origin: CGPoint(x: -newWidth / 2 - 10,y : 90), size: CGSize(width: newWidth, height: height * 1.7))
     
        
        let imageViewBackground = UIImageView(frame: rect)
        imageViewBackground.image = UIImage(named: imageName)

        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubview(toBack: imageViewBackground)
    }
    
    func addBlueBackground(_ imageName: String) {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let newWidth = height * 2.0
        
        let rect = CGRect(origin: CGPoint(x: -newWidth / 2 - 10,y : 0), size: CGSize(width: newWidth, height: height * 1.7))
        
        let imageViewBackground = UIImageView(frame: rect)
        imageViewBackground.image = UIImage(named: imageName)
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubview(toBack: imageViewBackground)
    }
}


class SignUpViewController: UIViewController, FBSDKLoginButtonDelegate {
   
   
    fileprivate var nameField: TextField!
    fileprivate var emailField: ErrorTextField!
    fileprivate var passwordField: TextField!
    fileprivate var confirmPasswordField: TextField!
    let kInfoTitle = "Info"
    let kSubtitle = "You've just displayed this awesome Pop Up View"
    let blueColor: Int! = 0x22B573
    //let user = FIRAuth.auth()?.currentUser
    var ref: FIRDatabaseReference!
    
    let lightGrayColor = UIColor.lightGray.lighten(byPercentage: 0.1)!
    func displayAlert(_ title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)

    }
    
    fileprivate let constant: CGFloat = 32
    var horizConstant: CGFloat = 32
    let device = UIDevice.current
    
    let screenHeight = UIScreen.main.bounds.size.height
    var IS_IPHONE = Bool()
    var IS_IPAD  = Bool()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IS_IPAD = device.userInterfaceIdiom == .pad
        IS_IPHONE = device.userInterfaceIdiom == .phone
        print("IS_IPAD " + String(IS_IPAD))
        print("IS_IPHONE " + String(IS_IPHONE))
        
        if IS_IPAD {
          horizConstant = 100
        }
       // if DeviceType.IS_IPAD || DeviceType.IS_IPAD_PRO {
            
      //  }
       
        self.view.addBackground("book.png")
        
        
        /*if (FBSDKAccessToken.current() != nil)
        {
            // User is already logged in     
            print("(FBSDKAccessToken.current() != nil)")
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Tutor", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "tutorPagingMenuVC") as! PagingMenuViewController
            self.present(viewController, animated: true, completion: nil)

        }
        else
        {
            print("create loginView")
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            let yValue = self.view.frame.height * 0.85
            loginView.center = CGPoint(x: self.view.frame.width / 2, y: yValue)
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
        */
        
        RZTransitionsManager.shared().defaultPresentDismissAnimationController = RZZoomAlphaAnimationController()
        RZTransitionsManager.shared().defaultPushPopAnimationController = RZCardSlideAnimationController()
        
        prepareInfoButton()
        prepareNameField()
        prepareEmailField()
        preparePasswordField()
        prepareConfirmPasswordField()
        prepareNextButton()
        prepareForgotPasswordButton()
        prepareLoginButton()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func alreadySignedIn() {
        ref = FIRDatabase.database().reference()
        let currentUserUID = FIRAuth.auth()?.currentUser?.uid
        if currentUserUID != nil {
            
            ref.child("users").child(currentUserUID!).observeSingleEvent(of: .value, with: { (snapshot) in
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
    
    /*func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        // ...
        
        
        
        
    }*/
    //MARK: Facebook SDK Default Signin
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
            print("error1")
            print(error)
        }
        else if result.isCancelled {
            // Handle cancellations
            print("result was cancelled")
            
        }
        else {
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            print("after let credential")
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                // ...
                if let error = error {
                    // ...
                     self.displayAlert("Error", message: "Unable to access your account.")
                    return
                } else {
                    if (user != nil) {
                        let uid = user?.uid as String!
                        let animalIndex =  Int(arc4random_uniform(6))
                        let profileImage = UIImage(named: animalImageNames[animalIndex])
                        let userInfo = ["name": user?.displayName, "email": user?.email]
                        FIRDatabase.database().reference().child("users/\(uid)").setValue(userInfo) // as well as other info
                        self.setProfileImage(profileImage: profileImage!)
                        self.performSegue(withIdentifier: "goToTutorOrTutee", sender: self)
                    }
                }
            }
        }
        
    }
    
    func setProfileImage(profileImage: UIImage) {
        let imageName = UUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
        
        let currentUserUID = FIRAuth.auth()?.currentUser?.uid
        let usersRef = FIRDatabase.database().reference().child("users")
        
        print("func setProfileImage(profileImage: UIImage) {")
        
        if let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
            
            print("if let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {")
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    return
                }
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    
                    if currentUserUID != nil {
                        usersRef.child(currentUserUID!).child("profileImageURL").setValue(profileImageUrl)
                        print("set image")
                    }
                }
            })
        } else {
            "if let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) { returned false"
        }
        
    }
    
  
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
func createAccount() {
        if emailField.text == "" || nameField.text == "" || passwordField.text == "" || confirmPasswordField.text == "" {
            displayAlert("Error", message: "Please complete all fields")
            
        } else if emailField.text?.isEmail() == false{
            displayAlert("Error", message: "\"\(emailField.text!)\" is not a valid email address")
        
        } else if passwordField.text!.characters.count < 6 {
            self.displayAlert("Not Long Enough", message: "Please enter a password that is 6 or more characters")
        } else if passwordField.text != confirmPasswordField.text {
            self.displayAlert("Passwords Do Not Match", message: "Please re-enter passwords")
        } else {
            FriendSystem.system.createAccount(emailField.text!, password: passwordField.text!, name: nameField.text!) { (success) in
                if success {
                    print("You have successfully signed up")
                    
                                       
                    let alert = UIAlertController(title: "Account Created", message: "Please verify your email by confirming the sent link.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    self.performSegue(withIdentifier: "goToTutorOrTutee", sender: self)
                    
                    
                } else {
                    //self.displayAlert(title: "Unable to Sign Up", message: "Please try again later"/*error.localizedDescription*/)
                }
            }
        }
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        emailField.width = view.height - 2 * constant
    }
   
    fileprivate func prepareNextButton() {
        let btn = RaisedButton(title: "Sign Up", titleColor: Color.grey.lighten3)
        btn.backgroundColor = UIColor(netHex: 0x51679F)
        btn.addTarget(self, action: #selector(handleNextButton(_:)), for: .touchUpInside)
        
        //view.layout(btn).width(310).height(constant).top(13 * constant).centerHorizontally()
        var verticalMult: CGFloat = 13
        
        
        view.layout(btn).top(verticalMult * constant).horizontally(left: horizConstant, right: horizConstant)
    }
    
    fileprivate func prepareForgotPasswordButton() {
       
        let btn: UIButton! = UIButton()
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(lightGrayColor, for: .highlighted)
        btn.titleLabel!.font =  UIFont(name: "HelveticaNeue", size: 16)
        btn.setTitle("Forgot Your Password?", for: UIControlState.normal)
        btn.addTarget(self, action: #selector(handleForgotPasswordButton(_:)), for: .touchUpInside)
        
        var verticalMult: CGFloat = 15

        view.layout(btn).width(200).height(constant).top(verticalMult * constant).centerHorizontally()
    }
    
    fileprivate func prepareLoginButton() {
        
        let btn: UIButton! = UIButton()
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(lightGrayColor, for: .highlighted)
        btn.titleLabel!.font =  UIFont(name: "HelveticaNeue", size: 16)
        
        btn.setTitle("Already Registered? Log In", for: UIControlState.normal)
        btn.addTarget(self, action: #selector(handleLogInButton(_:)), for: .touchUpInside)
        
         var verticalMult: CGFloat = 16
        

        view.layout(btn).width(210).height(constant).top(verticalMult * constant).centerHorizontally()
    }

    
    //
    
    //MARK: Material button functions
    @objc
    internal func handleResignResponderButton(_ button: UIButton) {
        nameField?.resignFirstResponder()
        emailField?.resignFirstResponder()
        passwordField?.resignFirstResponder()
        confirmPasswordField?.resignFirstResponder()

    }
    internal func handleNextButton(_ button: UIButton) {
       createAccount()
        
    }
    internal func handleForgotPasswordButton(_ button: UIButton) {
       
        print("hello")
        createForgotPasswordAlert()
    }
    internal func handleLogInButton(_ button: UIButton) {
        //SCLAlertView().showInfo("Hello Info", subTitle: "This is a more descriptive info text.") // Info
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "loginNC") as! UINavigationController
        controller.modalTransitionStyle = .flipHorizontal
        self.present(controller, animated: true, completion: nil)
        
        //createForgotPasswordAlert()
    }
    
    //MARK: Creates a popup SCLAlertView for retrieving password
    
    func createForgotPasswordAlert() {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false
                                                    /*contentViewColor: UIColor.alertViewBlue()*/)
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
    
    
    fileprivate func prepareNameField() {
        nameField = TextField()
        nameField.placeholder = "Name"
        nameField.placeholderNormalColor = UIColor.white
        nameField.dividerColor = UIColor.white
        nameField.dividerNormalColor = UIColor.white
        nameField.leftViewNormalColor = UIColor.white
        nameField.textColor = UIColor.white
        nameField.tintColor = UIColor.white
        nameField.dividerActiveColor = UIColor(netHex: 0x51679F).lighten(byPercentage: 0.9)!
        nameField.leftViewActiveColor = UIColor(netHex: 0x51679F).lighten(byPercentage: 0.9)!
        nameField.placeholderActiveColor =  UIColor(netHex: 0x51679F).lighten(byPercentage: 0.9)!
        
        let leftView = UIImageView()
        leftView.image = Icon.star
        
        nameField.leftView = leftView
        nameField.leftViewMode = .always
 
        var verticalMult: CGFloat = 4
        view.layout(nameField).top(verticalMult * constant).horizontally(left: horizConstant, right: horizConstant)
    }
    let infoButton = UIButton()
    
    fileprivate var popover: Popover!
    
    func prepareInfoButton() {
        
        
        infoButton.setImage(UIImage(named: "Info-25"), for: UIControlState.normal)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Info-25"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(infoButtonTapped))
    }
    var texts = ["For parents: feel free to sign up with your child's name and your email account."]
    func infoButtonTapped() {
        
       
        self.popover = Popover()
        let startPoint = CGPoint(x: self.view.frame.width - 25, y: 55)

        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        //self.popover = Popover(options: self.popoverOptions)
        
        //self.popover.show(tableView, point: self.rightButtomButton)
        popover.show(tableView, point: startPoint)
    }
    
    fileprivate func prepareEmailField() {
        var verticalMult: CGFloat = 6
 
        
        emailField = ErrorTextField(frame: CGRect(x: horizConstant, y: verticalMult * constant, width: view.width - (2 * horizConstant), height: constant))
        emailField.placeholder = "Email"
        emailField.detail = "Error, incorrect email"
        emailField.placeholderNormalColor = UIColor.white
        emailField.dividerColor = UIColor.white
        emailField.dividerNormalColor = UIColor.white
        emailField.leftViewNormalColor = UIColor.white
        emailField.textColor = UIColor.white
        emailField.tintColor = UIColor.white
        emailField.dividerActiveColor = UIColor(netHex: 0x51679F).lighten(byPercentage: 0.9)!
        emailField.leftViewActiveColor = UIColor(netHex: 0x51679F).lighten(byPercentage: 0.9)!
        emailField.placeholderActiveColor =  UIColor(netHex: 0x51679F).lighten(byPercentage: 0.9)!
        
        emailField.delegate = self
        
        let leftView = UIImageView()
        leftView.image = Icon.email
        
        emailField.leftView = leftView
        emailField.leftViewMode = .always
        view.addSubview(emailField)
    }
    
    fileprivate func preparePasswordField() {
        passwordField = TextField()
        passwordField.placeholder = "Password"
        //passwordField.detail = "At least 8 characters"
        passwordField.clearButtonMode = .whileEditing
        passwordField.isVisibilityIconButtonEnabled = true
        passwordField.placeholderNormalColor = UIColor.white
        passwordField.dividerColor = UIColor.white
        passwordField.dividerNormalColor = UIColor.white
        passwordField.leftViewNormalColor = UIColor.white
         passwordField.textColor = UIColor.white
         passwordField.tintColor = UIColor.white
        
        passwordField.dividerActiveColor = UIColor(netHex: 0x51679F).lighten(byPercentage: 0.9)!
        passwordField.leftViewActiveColor = UIColor(netHex: 0x51679F).lighten(byPercentage: 0.9)!
        passwordField.placeholderActiveColor =  UIColor(netHex: 0x51679F).lighten(byPercentage: 0.9)!
        
        // Setting the visibilityIconButton color.
        passwordField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        
        let leftView = UIImageView()
         leftView.image = UIImage(named: "Lock white")?.imageResize(CGSize(width: 27, height: 27))
        
        passwordField.leftView = leftView
        passwordField.leftViewMode = .always
        passwordField.leftViewNormalColor = .brown
        passwordField.leftViewActiveColor = .green
        
        var verticalMult: CGFloat = 8
        
        
        
        view.layout(passwordField).top(verticalMult * constant).horizontally(left: horizConstant, right: horizConstant)
    }
    
    fileprivate func prepareConfirmPasswordField() {
        confirmPasswordField = TextField()
        confirmPasswordField.placeholder = "Confirm Password"
        confirmPasswordField.detail = "At least 6 characters"
        confirmPasswordField.clearButtonMode = .whileEditing
        confirmPasswordField.isVisibilityIconButtonEnabled = true
        confirmPasswordField.placeholderNormalColor = UIColor.white
        confirmPasswordField.dividerColor = UIColor.white
        confirmPasswordField.leftViewNormalColor = UIColor.white
        confirmPasswordField.textColor = UIColor.white
        confirmPasswordField.tintColor = UIColor.white
        confirmPasswordField.detailColor = UIColor.lightGray.lighten(byPercentage: 0.5)!
        confirmPasswordField.dividerNormalColor = UIColor.white
        confirmPasswordField.dividerActiveColor = UIColor(netHex: 0x51679F).lighten(byPercentage: 0.9)!
        confirmPasswordField.leftViewActiveColor = UIColor(netHex: 0x51679F).lighten(byPercentage: 0.9)!
        confirmPasswordField.placeholderActiveColor =  UIColor(netHex: 0x51679F).lighten(byPercentage: 0.9)!
        
        confirmPasswordField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        
        let leftView = UIImageView()
        leftView.image = UIImage(named: "Lock white")?.imageResize(CGSize(width: 27, height: 27))
        
        confirmPasswordField.leftView = leftView
        confirmPasswordField.leftViewMode = .always
        confirmPasswordField.leftViewNormalColor = .brown
        confirmPasswordField.leftViewActiveColor = .green

        var verticalMult: CGFloat = 10
        print("\(screenHeight) screenHeight")
        
        view.layout(confirmPasswordField).top(verticalMult * constant).horizontally(left: horizConstant, right: horizConstant)
    }
}

extension SignUpViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.popover.dismiss()
    }
}

extension SignUpViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = self.texts[(indexPath as NSIndexPath).row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
    
    public func textField(_ textField: UITextField, didChange text: String?) {
        //print("did change", text ?? "")
    }
    
    public func textField(_ textField: UITextField, willClear text: String?) {
        print("will clear", text ?? "")
    }
    
    public func textField(_ textField: UITextField, didClear text: String?) {
        print("did clear", text ?? "")
    }
}

