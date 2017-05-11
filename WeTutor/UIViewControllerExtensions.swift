//
//  UIViewControllerExtensions.swift
//  TutorMe
//
//  Created by Zoe on 3/6/17.
//  Copyright © 2017 TokkiTech. All rights reserved.
//

import Foundation

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    func addBackground() {
        // screen width and height:
        let width = UIScreen.main.bounds.size.width
        //let height = UIScreen.mainScreen().bounds.size.height
        let backgroundImage = UIImage(named: "background")

        var imageViewBackground = UIImageView(frame: CGRect(x: 0, y: -90, width: width, height: (backgroundImage?.height)! * 1.1))
        
        let screenHeight = UIScreen.main.bounds.height
        if screenHeight > 800.0 {
            imageViewBackground = UIImageView(frame: CGRect(x: 0, y: -90, width: width, height: (backgroundImage?.height)! * 1.7))
        }
        imageViewBackground.image = backgroundImage
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleToFill
        imageViewBackground.tag = 4
        self.addSubview(imageViewBackground)
        self.sendSubview(toBack: imageViewBackground)
    }
    
    func addFullScreenBackground(_ named: String) {
        // screen width and height:
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let backgroundImage = UIImage(named: named)
        
        var imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        
        imageViewBackground.image = backgroundImage
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleToFill
        imageViewBackground.tag = 4
        self.addSubview(imageViewBackground)
        self.sendSubview(toBack: imageViewBackground)
    }
    
    func addFlippedBackground() {
        let width = UIScreen.main.bounds.size.width
        //let height = UIScreen.mainScreen().bounds.size.height
        let backgroundImage = UIImage(named: "flippedBackground")
        
        var imageViewBackground = UIImageView(frame: CGRect(x: 0, y: -90, width: width, height: (backgroundImage?.height)! * 1.1))
        let screenHeight = UIScreen.main.bounds.height
        if screenHeight > 800.0 {
            imageViewBackground = UIImageView(frame: CGRect(x: 0, y: -90, width: width, height: (backgroundImage?.height)! * 1.7))
        }
        imageViewBackground.image = backgroundImage
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleToFill
        imageViewBackground.tag = 5
        self.addSubview(imageViewBackground)
        self.sendSubview(toBack: imageViewBackground)
        
    }
}

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
