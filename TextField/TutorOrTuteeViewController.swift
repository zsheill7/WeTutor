//
//  TutorOrTuteeViewController.swift
//  TextField
//
//  Created by Zoe on 12/21/16.
//  Copyright © 2017 Zoe Sheill. All rights reserved.
//

import UIKit
import Material
import Spring
import ChameleonFramework
import Firebase
import FirebaseDatabase

class TutorOrTuteeViewController: UIViewController {


    @IBOutlet weak var ballView: SpringButton!

    
    @IBOutlet weak var ballView2: SpringButton!

    var selectedX: CGFloat = 0
    var centerX: CGFloat = 0
    var centerY: CGFloat = 0
    
    
    var userRef: FIRDatabaseReference!
    var userUID = ""
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.addBackground("mixed2")
        
        userRef = FIRDatabase.database().reference().child("users")
        if FIRAuth.auth()?.currentUser?.uid != nil {
            userUID = FIRAuth.auth()!.currentUser!.uid
        }
        
        
        centerX = CGFloat(self.view.frame.width / 2)
        centerY = CGFloat(self.view.frame.height / 2)
        
        changeBall()
        changeBall2()
        
        
        
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
        ballView.position.y = centerY - 100
        ballView.layer.cornerRadius = cornerRadius
        ballView.layer.add(animation, forKey: "radius")
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
        /*ballView2.position.x = centerX
         ballView2.position.y = centerY + 100*/
        ballView2.width = 150
        ballView2.height = 100
        
        print(CGPoint(x: centerX, y: centerY + 100))
        ballView2.center = CGPoint(x: centerX, y: centerY + 100)
        ballView2.layer.cornerRadius = cornerRadius
        ballView2.layer.add(animation, forKey: "radius")
    }
    
       @IBAction func studentTapped(_ sender: Any) {
        print("tapped")
        self.userRef.child("\(userUID)/isTutor").setValue(false)
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(false, forKey: "isTutor")
        userDefaults.synchronize()
 
        
        self.performSegue(withIdentifier: "toTuteeSignUpVC", sender: self)
    }
    @IBAction func tutorTapped(_ sender: Any) {
        print("tapped")
        self.userRef.child("\(userUID)/isTutor").setValue(true)
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(true, forKey: "isTutor")
        
        userDefaults.synchronize()
        
        self.performSegue(withIdentifier: "toTutorSignUpVC", sender: self)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
