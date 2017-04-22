//
//  SelfProfileViewController.swift
//  WeTutor
//
//  Created by Zoe on 4/10/17.
//  Copyright © 2017 TokkiTech. All rights reserved.
//

import UIKit
import Eureka
import CoreLocation
import SCLAlertView
import ASHorizontalScrollView
import FirebaseAnalytics
import FirebaseAuth
import FirebaseDatabase
import EventKit
import SCLAlertView

class SelfProfileViewController: UIViewController, UIScrollViewDelegate {
    

    var currentUser: User!
    
    @IBOutlet var backgroundColoredViews: [UIView]!
    @IBOutlet var headingLabels: [UILabel]!
    
    // @IBOutlet weak var name: UILabel!
    @IBOutlet weak var callButton: UIButton!
    
    @IBOutlet weak var textButton: UIButton!
    var indexPathRow: Int!
    
    @IBOutlet weak var basicInfoLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    //   @IBOutlet weak var preferencesLabel: UILabel!
    
    //@IBOutlet weak var availabilityLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var submitRatingButton: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var subjectsLabel: UILabel!
    
    @IBOutlet weak var subjectView: UIView!
    
    @IBOutlet weak var fullPageScrollView: UIScrollView!
    
    @IBOutlet weak var availabilityInfo: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    // @IBOutlet weak var weekDayView: UIScrollView!
    
    var UID: String!
    var userRef = FIRDatabase.database().reference().child("users")
    var dbRef: FIRDatabaseReference!
    var tutors = [User]()
    
    
    
    
    var availableDaysString = ""
    var preferredSubjectsString = ""
    
    func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.addBackground(imageName: "mixed2")
        
        
        FriendSystem.system.getCurrentUser { (user) in
            self.currentUser = user
        }
        
        callButton.contentMode = .scaleAspectFit
        textButton.contentMode = .scaleAspectFit
        
        self.containerView.isUserInteractionEnabled = false
        
        // Clear background colors from labels and buttons
        for view in backgroundColoredViews {
            view.backgroundColor = UIColor.clear
        }
        
        let viewFromNib: UIView? = Bundle.main.loadNibNamed("WeekDaysCellTwo",
                                                            owner: nil,
                                                            options: nil)?.first as! UIView?
        fullPageScrollView.delegate = self
        fullPageScrollView.isDirectionalLockEnabled = true
        
        self.loadHorizontalScrollView()
        
       
        
        for (index, subject) in currentUser.preferredSubjects.enumerated() {
            if index != (currentUser.preferredSubjects.count - 1) {
                preferredSubjectsString += "\(subject), "
            } else {
                preferredSubjectsString += "\(subject)"
            }
        }
        
        for (index, day) in currentUser.availableDaysStringArray.enumerated() {
            if index != (currentUser.availableDaysStringArray.count - 1) {
                preferredSubjectsString += "\(day), "
            } else {
                preferredSubjectsString += "\(day)"
            }
        }
        
        headingLabels.forEach { $0.attributedText = NSAttributedString(string: $0.text!, attributes: [NSKernAttributeName: 1]) }
        
        basicInfoLabel.text = "Age: \(currentUser.grade) \nSchool: \(currentUser.school)\nPhone: \(currentUser.phone)\nemail:\(currentUser.email)"
        // title = currentUser.name
        descriptionLabel.text = currentUser.description
        nameLabel.text = "\(currentUser.name)"
        availabilityInfo.text = currentUser.availabilityInfo
        
    }
    
    @IBAction func showSampleProfile(_ sender: Any) {
        self.displayAlert(title: "Sample profile", message: "Buttons are disabled for viewing a sample of your own profile")
    }
    
    func displayAlert(title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)
        
    }
    
    
    func loadHorizontalScrollView() {
        let horizontalScrollView:ASHorizontalScrollView = ASHorizontalScrollView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 60))
        //for iPhone 5s and lower versions in portrait
        horizontalScrollView.marginSettings_320 = MarginSettings(leftMargin: 10, miniMarginBetweenItems: 5, miniAppearWidthOfLastItem: 20)
        //for iPhone 4s and lower versions in landscape
        horizontalScrollView.marginSettings_480 = MarginSettings(leftMargin: 10, miniMarginBetweenItems: 5, miniAppearWidthOfLastItem: 20)
        // for iPhone 6 plus and 6s plus in portrait
        horizontalScrollView.marginSettings_414 = MarginSettings(leftMargin: 10, miniMarginBetweenItems: 5, miniAppearWidthOfLastItem: 20)
        // for iPhone 6 plus and 6s plus in landscape
        horizontalScrollView.marginSettings_736 = MarginSettings(leftMargin: 10, miniMarginBetweenItems: 10, miniAppearWidthOfLastItem: 30)
        //for all other screen sizes that doesn't set here, it would use defaultMarginSettings instead
        horizontalScrollView.defaultMarginSettings = MarginSettings(leftMargin: 10, miniMarginBetweenItems: 10, miniAppearWidthOfLastItem: 20)
        horizontalScrollView.shouldCenterSubViews = true
        horizontalScrollView.marginSettings_414?.miniMarginBetweenItems = 10
        horizontalScrollView.uniformItemSize = CGSize(width: 60, height: 60)
        //this must be called after changing any size or margin property of this class to get acurrate margin
        horizontalScrollView.setItemsMarginOnce()
        for index in 0...currentUser.preferredSubjects.count - 1 {
            print("for index in 1...subjectNames.count{")
            let imageView = UIImageView()
            let imageName = currentUser.preferredSubjects[index]
            if let subjectImageName = subjectImageNames[imageName] {
                if let buttonImage = UIImage(named: subjectImageName) {
                    //button.setImage(buttonImage, for: .normal)
                    imageView.image = buttonImage
                }
            }
            
            // button.backgroundColor = UIColor.blue
            horizontalScrollView.addItem(imageView)
        }
        _ = horizontalScrollView.centerSubviews()
        
        subjectView.addSubview(horizontalScrollView)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedAvailability" {
            if let vc = segue.destination as? AvailabilityTableViewController {
                vc.destUser = currentUser
            }
        }
    }
}
