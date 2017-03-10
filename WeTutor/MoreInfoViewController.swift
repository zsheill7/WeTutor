

import UIKit
import SafariServices
import Eureka
import CoreLocation
import SCLAlertView

class MoreInfoViewController: UIViewController {
    
    var destUser: User!
    
    @IBOutlet var backgroundColoredViews: [UIView]!
    @IBOutlet var headingLabels: [UILabel]!
    
   // @IBOutlet weak var name: UILabel!
    @IBOutlet weak var callButton: UIButton!
    
    @IBOutlet weak var textButton: UIButton!
    var indexPathRow: Int!
   
    @IBOutlet weak var basicInfoLabel: UILabel!
   
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var preferencesLabel: UILabel!
   
    @IBOutlet weak var availabilityLabel: UILabel!

    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var submitRatingButton: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var subjectsLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
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
        
        
              // Clear background colors from labels and buttons
        for view in backgroundColoredViews {
            view.backgroundColor = UIColor.clear
        }
       /* let viewFromNib: UIView? = Bundle.main.loadNibNamed("NibName",
                                                            owner: nil,
                                                            options: nil)?.first
        
       containerView.loadFromNibNamed(nibNamed: "WeekDaysCell")! as! WeekDaysCell*/
       /* form
            
            +++ Section("Available Days")
            
            
            
            <<< WeekDayRow("Available Days"){
                $0.value = [.monday, .wednesday, .friday]
                
        }*/
        
        
        // Set the kerning to 1 to increase spacing between letters
       
       /* for (index, subject) in destUser.preferredSubjects.enumerated() {
            if index != (destUser.preferredSubjects.count - 1) {
                preferredSubjectsString += "\(subject), "
            } else {
                preferredSubjectsString += "\(subject)"
            }
        }
        
        for (index, day) in destUser.availableDays.enumerated() {
            if index != (destUser.availableDays.count - 1) {
                preferredSubjectsString += "\(day), "
            } else {
                preferredSubjectsString += "\(day)"
            }
        }
        
        headingLabels.forEach { $0.attributedText = NSAttributedString(string: $0.text!, attributes: [NSKernAttributeName: 1]) }
        
        basicInfoLabel.text = "Age: \(destUser.grade) \nSchool: \(destUser.school)\nPhone: \(destUser.phone)\nemail:\(destUser.email)"
        // title = destUser.name
         descriptionLabel.text = destUser.description
        preferencesLabel.text = "Preferred Subjects: \(preferredSubjectsString)"
        availabilityLabel.text = "Available Days: \(destUser.availableDays)\n\(destUser.availabilityInfo)"
        nameLabel.text = "\(destUser.name)"*/
        
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
           
            default:
                fatalError("Unhandled Segue: \(segue.identifier!)")
            }
        }
    }
}


