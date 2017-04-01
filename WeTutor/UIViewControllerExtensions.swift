//
//  UIViewControllerExtensions.swift
//  TutorMe
//
//  Created by Zoe on 3/6/17.
//  Copyright © 2017 CosmicMind. All rights reserved.
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

        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: -50, width: width, height: (backgroundImage?.height)!))
        imageViewBackground.image = backgroundImage
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
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

/*extension FormViewController {
    
}*/
