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
    }
}
