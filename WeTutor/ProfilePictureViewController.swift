//
//  ProfilePictureViewController.swift
//  TutorMe
//
//  Created by Zoe on 3/5/17.
//

import UIKit
import SCLAlertView
import Firebase

class ProfilePictureViewController: UIViewController, UIImagePickerControllerDelegate {

    @IBOutlet weak var nextButton: UIButton!
    var user = FIRAuth.auth()?.currentUser
    
    let pickedProfileImage = UIImagePickerController()
    
    @IBOutlet weak var profileImage: UIImageView!
    
    func displayAlert(title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)
    }
    
    let ref = FIRDatabase.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(profileImageView)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        //need x, y, width, height constraints
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
        //profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    /*func fetchCurrentUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let userID = FIRAuth.auth()?.currentUser?.uid
                ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    let profileImageURL = value?["profileImageURL"] as? String ?? ""
                   // let user = User.init(username: username)
                    
                    // ...
                    if profileImageURL  != nil {
                        cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
                //if you use this setter, your app will crash if your class properties don't exactly match up with the firebase dictionary keys
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                
                //this will crash because of background thread, so lets use dispatch_async to fix
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
                //                user.name = dictionary["name"]
            }
            
        }, withCancel: nil)
    }*/

    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let profile = value?["profileImageURL"]
           // let user = User.init(username: username)
            if let newProfile = profile as? Data {
                
                if let downloadedImage = UIImage(data: newProfile as! Data) {
                   // self.profileImage.image = downloadedImage
                    self.profileImage.loadImageUsingCacheWithUrlString(profile as! String)
              
                }
                print("inside block 1")
                
            } else {
                print("if let newProfile = profile as? Data { returned false")
            }
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
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

        
        
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false
            /*contentViewColor: UIColor.alertViewBlue()*/)
        let alert = SCLAlertView(appearance: appearance)
        //let emailTextField = alert.addTextField("Email")
        
        /*_ = alert.addButton("Show Name") {
         print("Text value: \(txt.text)")
         }*/
        
        
        
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
        
        //presentViewController(alertController, animated: true, completion: nil)
        
        /*_ = alert.addButton("Cancel") {
         print("Second button tapped")
         }*/
        _ = alert.showInfo("Change Profile Photo", subTitle:"")
        //emailButton.backgroundColor = UIColor.alertViewBlue()
        //closeButton.backgroundColor = UIColor.alertViewBlue()
        //emailTextField.borderColor = UIColor.alertViewBlue()
        
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
    
    /*func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
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
