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
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
         self.profileImage.loadImageUsingCacheWithUrlString(profileImageUrlString)
        
        view.addSubview(profileImageView)
        self.view.backgroundColor = UIColor.white
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toPagingMenuVC", sender: self)
    }
    
    lazy var profileImageView: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "Owl Icon-2")
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.contentMode = .scaleAspectFill
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changePhoto)))
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
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
        
        
        
        /*if let imageFile = user!["barcode"] {
            
            imageFile.getDataInBackgroundWithBlock({ (data, error) in
                if let downloadedImage = UIImage(data: data!) {
                    self.barcodeImage.image = downloadedImage
                }
                print("inside block 1")
                
            })
        }*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changePhoto() {

        
        
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        
        let choosePhotoButton = alert.addButton("Choose From Photo Library") {
            self.pickedProfileImage.delegate = self
            self.pickedProfileImage.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.pickedProfileImage.allowsEditing = false
            
            self.present(self.pickedProfileImage, animated: true, completion: nil)
        }
        
        let takePhotoButton = alert.addButton("Take Photo") {
            
            self.pickedProfileImage.delegate = self
            self.pickedProfileImage.sourceType = UIImagePickerControllerSourceType.camera
            self.pickedProfileImage.allowsEditing = false
            
            self.present(self.pickedProfileImage, animated: true, completion: nil)
            
            
            /*SCLAlertView().showInfo("Error", subTitle: "Please enter a valid email.")
            SCLAlertView().showInfo("Success!", subTitle: "Password reset email sent.")*/
            
        }
        let closeButton = alert.addButton("Cancel") {
            print("close")
            
        }
       
        _ = alert.showInfo("Change Profile Photo", subTitle:"")
    }
    
    
    /*@IBAction func changePhoto(sender: AnyObject) {
        if #available(iOS 8.0, *) {
            let alertController = UIAlertController(title: "Choose Photo", message: "", preferredStyle: .ActionSheet)
            let choosePhoto = UIAlertAction(title: "Choose from Photo Library", style: .Default) { (_) in
                self.pickedBarcodeImage.delegate = self
                self.pickedBarcodeImage.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                self.pickedBarcodeImage.allowsEditing = false
                
                self.presentViewController(self.pickedBarcodeImage, animated: true, completion: nil)
                
                //barcodeImage.image = image
                
            }
            
            
            
            let takePhoto = UIAlertAction(title: "Take Photo", style: .Default) { (_) in
                self.pickedBarcodeImage.delegate = self
                self.pickedBarcodeImage.sourceType = UIImagePickerControllerSourceType.Camera
                self.pickedBarcodeImage.allowsEditing = false
                
                self.presentViewController(self.pickedBarcodeImage, animated: true, completion: nil)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
            
            alertController.addAction(choosePhoto)
            alertController.addAction(takePhoto)
            alertController.addAction(cancelAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            
        } else {
            displayAlert( "Software Update Needed", message: "Please update to iOS8 or later or contact an admin")
        }
        
        
    }*/
    
  /*  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismiss(animated: true, completion: nil)
        
        
        
        
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        if picker == pickedBarcodeImage {
            if let imageFile = PFFile(name: "image.png", data: imageData!) {
                user!["barcode"] = imageFile
                
                imageFile.getDataInBackgroundWithBlock({ (data, error) in
                    if let downloadedImage = UIImage(data: data!) {
                        self.barcodeImage.image = downloadedImage
                    }
                    print("inside block")
                })
                imageFile.saveInBackgroundWithBlock({ (success, error) in
                    if success {
                        print("success")
                        
                    } else {
                        print(error)
                    }
                })
                user!.saveInBackgroundWithBlock({ (success, error) in
                    if success {
                        print("success2")
                        
                    } else {
                        print(error)
                    }
                })
                
                displayAlert("Success!", message: "Your barcode image was changed")
            } else {
                print("Couldn't create imagefile")
            }
        }
    }*/


}
