//
//  AboutThisAppViewController.swift
//  WeTutor
//
//  Created by Zoe on 12/24/16.
//  Copyright © 2017 Zoe Sheill. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import ChameleonFramework


class AboutThisAppViewController: UIViewController {
    
    
    @IBOutlet var textView: UITextView!
    
    var currentUserIsTutor: Bool?
    var ref: FIRDatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.linkTextAttributes = [NSForegroundColorAttributeName: UIColor.lightTeal().lighten(byPercentage: 0.5) ?? UIColor.lightTeal()]
        textView.isUserInteractionEnabled = true
        
         self.view?.addBackground()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedOkay(_ sender: Any) {
        
        
             self.dismiss(animated: true, completion: nil)
        /*let storyboard = UIStoryboard(name: "Tutor", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "tutorPagingMenuNC") as! UINavigationController
        //controller.modalTransitionStyle = .flipHorizontal
        self.present(controller, animated: true, completion: nil)*/
            
        /*} else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "signupNC") as! UINavigationController
            //controller.modalTransitionStyle = .crossDissolve
            self.present(controller, animated: true, completion: nil)
        }*/

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
