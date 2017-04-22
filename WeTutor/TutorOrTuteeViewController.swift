//
//  TutorOrTuteeViewController.swift
//
//  Created by Zoe on 12/21/16.
//  Copyright © 2017 Zoe Sheill. All rights reserved.
//

import UIKit
import Material
import Spring
import ChameleonFramework
import FirebaseDatabase
import FirebaseAnalytics
import FirebaseAuth

class TutorOrTuteeViewController: UIViewController {


    @IBOutlet weak var ballView: SpringButton!

    @IBOutlet weak var chooseLabel: UILabel!
    
    @IBOutlet weak var ballView2: SpringButton!

    var selectedX: CGFloat = 0
    var centerX: CGFloat = 0
    var centerY: CGFloat = 0
    
    
    var userRef: FIRDatabaseReference!
    var userUID = ""
    
    var currentUserIsTutor = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addBackground("book.png")
        userRef = FIRDatabase.database().reference().child("users")
        if FIRAuth.auth()?.currentUser?.uid != nil {
            userUID = FIRAuth.auth()!.currentUser!.uid
        }
        
       
        
        
        centerX = CGFloat(self.view.frame.width / 2)
        centerY = CGFloat(self.view.frame.height / 2)
        
        changeBall()
        changeBall2()
        
        chooseLabel.font = UIFont(name: "Helvetica", size: 25)
      
        
        
        print(centerX)
        print(centerY)
         self.ballView.backgroundColor = /*UIColor(hex: "69DBFF")*/UIColor.titleBlue()
        /*UIView.animate(withDuration: 0.1, animations: {
           
        }, completion: { finished in
            UIView.animate(withDuration: 0.5, animations: {
                self.ballView.backgroundColor = UIColor(hex: "#279CEB")
            })
        })*/
        
        ballView.animation = "zoomIn"
        //ballView.position.x = selectedXself.ballView.position.x = CGFloat(self.view.frame.width / 2)
        ballView.curve = "easeIn"
        ballView.duration =  1.0
        //applyPlainShadow(view: ballView)
        ballView.animate()
        
        self.ballView2.backgroundColor = /*UIColor(hex: "69DBFF")*/ UIColor.titleBlue()
       /* UIView.animate(withDuration: 0.1, animations: {
            
        }, completion: { finished in
            UIView.animate(withDuration: 0.5, animations: {
                self.ballView2.backgroundColor = UIColor(hex: "#279CEB")
            })
        })*/
        
        ballView2.animation = "zoomIn"
        ballView2.curve = "easeIn"
        ballView2.duration =  1.0
        //applyPlainShadow(view: ballView2)
        ballView2.animate()
        
        
        // Do any additional setup after loading the view.
    }
    func changeBall() {
         let isBall = false
        let animation = CABasicAnimation()
        let halfWidth = ballView.frame.width / 2
        let cornerRadius: CGFloat = isBall ? halfWidth : 10
        animation.keyPath = "cornerRadius"
        animation.fromValue = isBall ? 10 : halfWidth
        animation.toValue = cornerRadius
        animation.duration = 0.2
        
        ballView.width = 150
        ballView.height = 100
        ballView.position.x = centerX
        ballView.position.y = centerY - 50

        ballView.layer.cornerRadius = cornerRadius
        ballView.layer.add(animation, forKey: "radius")
    }
    
    func applyPlainShadow(view: SpringButton) {
        var layer = view.layer
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 4)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5
    }
    func applyPlainShadowLabel(view: UILabel) {
        var layer = view.layer
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 2
    }
    func changeBall2() {
        let isBall = false
        let animation = CABasicAnimation()
        let halfWidth = ballView2.frame.width / 2
        let cornerRadius: CGFloat = isBall ? halfWidth : 10
        animation.keyPath = "cornerRadius"
        animation.fromValue = isBall ? 10 : halfWidth
        animation.toValue = cornerRadius
        animation.duration = 0.2
        ballView2.width = 150
        ballView2.height = 100
        
        print(CGPoint(x: centerX, y: centerY + 75))
        ballView2.center = CGPoint(x: centerX, y: centerY + 100)
        ballView2.layer.cornerRadius = cornerRadius
        ballView2.layer.add(animation, forKey: "radius")
    }
    
       @IBAction func studentTapped(_ sender: Any) {
        print("tapped")
        self.userRef.child("\(userUID)").child("isTutor").setValue(false)
        let userDefaults = UserDefaults.standard
        
        userDefaults.setValue(false, forKey: "isTutor")
        userDefaults.synchronize()
        self.currentUserIsTutor = false
 
        FIRAnalytics.setUserPropertyString("false", forName: "is_tutor")
        
        self.performSegue(withIdentifier: "toTutorSignUpVC", sender: self)
    }
    
    @IBAction func tutorTapped(_ sender: Any) {
        print("tapped")
        self.userRef.child("\(userUID)").child("isTutor").setValue(true)
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(true, forKey: "isTutor")
        self.currentUserIsTutor = true
        userDefaults.synchronize()
        FIRAnalytics.setUserPropertyString("true", forName: "is_tutor")

        self.performSegue(withIdentifier: "toTutorSignUpVC", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toTutorSignUpVC" {
            print("in segue identifier")
            if let destinationNavigationController = segue.destination as? UINavigationController {
                
                let targetController = destinationNavigationController.topViewController as! TutorSignUpViewControllerOne
                targetController.currentUserIsTutor = currentUserIsTutor
            }
        }
    }
 

}
