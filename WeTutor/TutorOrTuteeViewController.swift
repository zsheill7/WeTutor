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
import Firebase
import FirebaseDatabase

class TutorOrTuteeViewController: UIViewController {


    @IBOutlet weak var ballView: SpringButton!

    @IBOutlet weak var chooseLabel: UILabel!
    
    @IBOutlet weak var ballView2: SpringButton!

    var selectedX: CGFloat = 0
    var centerX: CGFloat = 0
    var centerY: CGFloat = 0
    
    
    var userRef: FIRDatabaseReference!
    var userUID = ""
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view?.backgroundColor = UIColor.backgroundBlue()
        
        userRef = FIRDatabase.database().reference().child("users")
        if FIRAuth.auth()?.currentUser?.uid != nil {
            userUID = FIRAuth.auth()!.currentUser!.uid
        }
        
       
        
        
        centerX = CGFloat(self.view.frame.width / 2)
        centerY = CGFloat(self.view.frame.height / 2)
        
        changeBall()
        changeBall2()
        
        chooseLabel.layer.shadowColor = UIColor.black.cgColor
        chooseLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        chooseLabel.layer.shadowOpacity = 0.4
        chooseLabel.layer.shadowRadius = 5
        
       /* let pickOneLabel = UILabel()
        pickOneLabel.backgroundColor = UIColor.blue
        pickOneLabel.text = "Are you signing up as a "
        pickOneLabel.textColor = UIColor.white
        pickOneLabel.translatesAutoresizingMaskIntoConstraints = false
       /* pickOneLabel.position.x = centerX
        pickOneLabel.position.y = centerY + 40*/
         pickOneLabel.center = CGPoint(x: centerX, y: centerY + 50)
        pickOneLabel.font = UIFont(name: "Helvetica-Bold", size: 20)
        pickOneLabel.height = 20
        //pickOneLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        pickOneLabel.widthAnchor.constraint(equalToConstant: 400).isActive = true
        pickOneLabel.textAlignment = .center
        let yConstraint = NSLayoutConstraint(item: pickOneLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self.tableView, attribute: .CenterY, multiplier: 1, constant: 0)
       /* pickOneLabel.centerXAnchor.constraint(equalTo: pickOneLabel.superview!.centerXAnchor).isActive = true
        pickOneLabel.centerYAnchor.constraint(equalTo: pickOneLabel.superview!.centerYAnchor).isActive = true*/
        self.view.addSubview(pickOneLabel)
         pickOneLabel.center = CGPoint(x: centerX, y: centerY + 50)
        
        let pickOneLabelTwo = UILabel()
        //pickOneLabelTwo.backgroundColor = UIColor.blue
        pickOneLabelTwo.text = "tutor or a student?"
        pickOneLabelTwo.textColor = UIColor.white
        pickOneLabelTwo.height = 20
        pickOneLabelTwo.translatesAutoresizingMaskIntoConstraints = false
        pickOneLabelTwo.center = CGPoint(x: centerX, y: centerY + 30)
        pickOneLabelTwo.font = UIFont(name: "Helvetica-Bold", size: 20)
        pickOneLabelTwo.heightAnchor.constraint(equalToConstant: 30).isActive = true
        pickOneLabelTwo.widthAnchor.constraint(equalToConstant: 400).isActive = true
        pickOneLabelTwo.textAlignment = .center
        /* pickOneLabelTwo.centerXAnchor.constraint(equalTo: pickOneLabelTwo.superview!.centerXAnchor).isActive = true
         pickOneLabelTwo.centerYAnchor.constraint(equalTo: pickOneLabelTwo.superview!.centerYAnchor).isActive = true*/
        self.view.addSubview(pickOneLabelTwo)*/
        
        
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
        applyPlainShadow(view: ballView)
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
        applyPlainShadow(view: ballView2)
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
        ballView.position.y = centerY - 75

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
        /*ballView2.position.x = centerX
         ballView2.position.y = centerY + 100*/
        ballView2.width = 150
        ballView2.height = 100
        
        print(CGPoint(x: centerX, y: centerY + 75))
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
 
        
        self.performSegue(withIdentifier: "toTutorSignUpVC", sender: self)
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
