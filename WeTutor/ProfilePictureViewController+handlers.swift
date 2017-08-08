//
//  LoginController+handlers.swift
//
//
//  Created by Zoe Sheill on 7/4/16.
//  Copyright © 2016 TokkiTech. All rights reserved.
//

import UIKit
import Firebase

extension ProfilePictureViewController {
    

   
    
    
   /* fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err)
                return
            }
            
//            self.messagesController?.fetchUserAndSetupNavBarTitle()
//            self.messagesController?.navigationItem.title = values["name"] as? String
            let user = User()
            //this setter potentially crashes if keys don't match
            user.setValuesForKeys(values)
            self.messagesController?.setupNavBarWithUser(user)
            
            self.dismiss(animated: true, completion: nil)
        })
    }*/
    
    //Create an image picker controller
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    //After the user picks a photo, store that photo in url form in their Firebase database
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        print("ProfilePictureViewController: did finish picking image")
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            DispatchQueue.main.async {
                self.profileImageView.image = editedImage
                self.profileImage.image = editedImage
                self.profileImageView.setNeedsDisplay()
            }
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            DispatchQueue.main.async {
                self.profileImageView.image = originalImage
                self.profileImage.image = originalImage
                self.profileImageView.setNeedsDisplay()
            }
        }
        
        
        
       /* if let selectedImage = selectedImageFromPicker {
            print("ProfilePictureViewController: selectedImage = selectedImageFromPicker")
            profileImageView.image = selectedImage
        } else {
            print("ProfilePictureViewController: selectedImage != selectedImageFromPicker")
        }*/
        
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
        
        let currentUserUID = Auth.auth().currentUser?.uid
        let usersRef = Database.database().reference().child("users")
        
        if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error)
                    self.profileImageView.image = profileImage
                    return
                }
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    print("ProfilePictureViewController: profileImageUrl = metadata?.downloadURL()?.absoluteString")
                    if currentUserUID != nil {
                        usersRef.child(currentUserUID!).child("profile_image").setValue(profileImageUrl)
                    }
                    //let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                
                }
            })
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
}
