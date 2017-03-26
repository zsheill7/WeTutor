

import UIKit
import SafariServices
import Eureka
import CoreLocation
import SCLAlertView
import ASHorizontalScrollView

class MoreInfoViewController: UIViewController, UIScrollViewDelegate {
    
    var destUser: User!
    
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
    
    
    @IBOutlet weak var containerView: UIView!
   // @IBOutlet weak var weekDayView: UIScrollView!
    
     var UID: String!
    
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
        
        
      // containerView.loadFromNibNamed(nibNamed: "WeekDaysCell")! as! WeekDayCell
        
       /* form
            
            +++ Section("Available Days")
            
            
            
            <<< WeekDayRow("Available Days"){
                $0.value = [.monday, .wednesday, .friday]
                
        }*/
        
        //let backView = UIView(frame: self.tableView.bounds)
        
       // self.fullPageScrollView.addBackground("Info Input Page (w-stripes)")
        
        // Set the kerning to 1 to increase spacing between letters
       
        for (index, subject) in destUser.preferredSubjects.enumerated() {
            if index != (destUser.preferredSubjects.count - 1) {
                preferredSubjectsString += "\(subject), "
            } else {
                preferredSubjectsString += "\(subject)"
            }
        }
        
        for (index, day) in destUser.availableDaysStringArray.enumerated() {
            if index != (destUser.availableDaysStringArray.count - 1) {
                preferredSubjectsString += "\(day), "
            } else {
                preferredSubjectsString += "\(day)"
            }
        }
        
        headingLabels.forEach { $0.attributedText = NSAttributedString(string: $0.text!, attributes: [NSKernAttributeName: 1]) }
        
        basicInfoLabel.text = "Age: \(destUser.grade) \nSchool: \(destUser.school)\nPhone: \(destUser.phone)\nemail:\(destUser.email)"
        // title = destUser.name
         descriptionLabel.text = destUser.description
      //  preferencesLabel.text = "Preferred Subjects: \(preferredSubjectsString)"
        //availabilityLabel.text = "Available Days: \(destUser.availableDays)\n\(destUser.availabilityInfo)"
        nameLabel.text = "\(destUser.name)"
        
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
        for index in 0...destUser.preferredSubjects.count - 1 {
            print("for index in 1...subjectNames.count{")
            let imageView = UIImageView()
            let imageName = destUser.preferredSubjects[index]
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
    
    
    
    func displayAlert(_ title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    

    
    
    @IBAction func callNumber(_ sender: Any) {
        let phoneNumber = destUser.phone
        print("inside call number")
        if let url = URL(string: "tel://"+"\(phoneNumber)")  {
            print("inside if let url1")
            if (UIApplication.shared.canOpenURL(url)) {
                print("inside if let url2")
                UIApplication.shared.openURL(url)
            }
        } else {
             self.displayAlert("Unable to Connect", message: "This phone number is not in service")
        }
    }
    
    @IBAction func textNumber(_ sender: Any) {
         let phoneNumber = destUser.phone
        
        if let url = URL(string: "sms:+\(phoneNumber)") {
            UIApplication.shared.openURL(url)
        } else {
            self.displayAlert("Unable to Connect", message: "This phone number is not in service")
        }
    }
    
    
    func addFriendFunction() {
        let id = destUser.uid
        print(id)
        FriendSystem.system.sendRequestToUser(id)
        self.displayAlert("Success!", message: "Friend Request Sent")
    }
    
    
    
    
    @IBAction func addFriendTapped(_ sender: Any) {
        addFriendFunction()
    }
    
    @IBAction func chatTapped(_ sender: Any) {
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 {
            scrollView.contentOffset.x = 0
        }
       // scrollView.bounces = (scrollView.contentOffset.y > 100)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != nil {
            switch segue.identifier! {
            case "presentMapViewController":
                guard let navigationController = segue.destination as? UINavigationController,
                    let mapViewController = navigationController.topViewController as? MapViewController else {
                        fatalError("Unexpected view hierarchy")
                }
                print( CLLocationCoordinate2DMake(CLLocationDegrees(destUser.latitude), CLLocationDegrees(destUser.longitude)))
                mapViewController.locationToShow =             CLLocationCoordinate2DMake(CLLocationDegrees(destUser.latitude), CLLocationDegrees(destUser.longitude))
                mapViewController.title = destUser.name
            case "embedAvailability":
                if let vc = segue.destination as? AvailabilityTableViewController {
                    vc.destUser = destUser
                }
           
            default:
                fatalError("Unhandled Segue: \(segue.identifier!)")
            }
        }
    }
}


