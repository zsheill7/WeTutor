//
//  ProfilePictureViewController.swift
//  TutorMe
//
//  Created by Zoe Sheill on 3/5/17.
//

import UIKit
import SCLAlertView
import Firebase

class ProfilePictureViewController: UIViewController, UIImagePickerControllerDelegate {

    @IBOutlet weak var nextButton: UIButton!
    var user = FIRAuth.auth()?.currentUser
    
    let pickedProfileImage = UIImagePickerController()
    
    @IBOutlet weak var profileImage: UIImageView!
    var profileImageUrlString = ""
    func displayAlert(title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)
    }
    
    let ref = FIRDatabase.database().reference()
    
    //MARK: viewDidLoad
    override func viewWillAppear(_ animated: Bool) {
        self.profileImage.loadImageUsingCacheWithUrlString(profileImageUrlString)
        view.addSubview(profileImageView)
        self.view.backgroundColor = UIColor.white
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImage.loadImageUsingCacheWithUrlString(profileImageUrlString)
        profileImageView.image = UIImage(named: "Owl Icon-2")
        view.addSubview(profileImageView)
        self.view.backgroundColor = UIColor.white
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toPagingMenuVC", sender: self)
    }
    
    //Creates a default profile imageview
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.contentMode = .scaleAspectFill
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changePhoto)))
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    //Sets up the default profile imageview
    
    func setupProfileImageView() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        let widthConstraint = NSLayoutConstraint(item: profileImageView,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 0.5,
                                                 constant: 100)
        self.view.addConstraints([widthConstraint])
        profileImageView.width = 100
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        self.changePhoto()
    }
    
    // If the current user already has a profile image, set it
    func fetchCurrentUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let userID = FIRAuth.auth()?.currentUser?.uid
                self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let profileImageURL = value?["profileImageURL"] as? String ?? ""
                    
                    // ...
                    if profileImageURL  != nil {
                        self.profileImageView.loadImageUsingCacheWithUrlString(profileImageURL)
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
            
        }, withCancel: nil)
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Change the profile image
    func changePhoto() {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        
        let choosePhotoButton = alert.addButton("Choose From Photo Library") {
            self.pickedProfileImage.delegate = self
            self.pickedProfileImage.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.pickedProfileImage.allowsEditing = false
            
            self.present(self.pickedProfileImage, animated: true, completion: nil)
        }
        /*
        let takePhotoButton = alert.addButton("Take Photo") {
            
            self.pickedProfileImage.delegate = self
            self.pickedProfileImage.sourceType = UIImagePickerControllerSourceType.camera
            self.pickedProfileImage.allowsEditing = false
            
            self.present(self.pickedProfileImage, animated: true, completion: nil)
            
            
            /*SCLAlertView().showInfo("Error", subTitle: "Please enter a valid email.")
            SCLAlertView().showInfo("Success!", subTitle: "Password reset email sent.")*/
            
        }*/
        let closeButton = alert.addButton("Cancel") {
            print("close")
            
        }
       
        _ = alert.showInfo("Change Profile Photo", subTitle:"")
    }
}
