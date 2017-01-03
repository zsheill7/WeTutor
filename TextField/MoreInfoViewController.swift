

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
    
    var indexPathRow: Int!
   
    @IBOutlet weak var basicInfoLabel: UILabel!
   
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var preferencesLabel: UILabel!
   
    @IBOutlet weak var availabilityLabel: UILabel!

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userRatingLabel: UILabel!
    @IBOutlet weak var weatherHideOrShowButton: UIButton!
    @IBOutlet weak var submitRatingButton: UIButton!
    
     var UID: String!
    var shouldHideWeatherInfoSetting: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "shouldHideWeatherInfo")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "shouldHideWeatherInfo")
        }
    }
    var availableDaysString = ""
    var preferredSubjectsString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.addBackground(imageName: "mixed2")
       
        
        
        updateWeatherInfoViews(hideWeatherInfo: shouldHideWeatherInfoSetting, animated: false)
       
        // Clear background colors from labels and buttons
        for view in backgroundColoredViews {
            view.backgroundColor = UIColor.clear
        }
        
        // Set the kerning to 1 to increase spacing between letters
       
        for (index, subject) in destUser.preferredSubjects.enumerated() {
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
        
        basicInfoLabel.text = "Age: \(destUser.age) \nSchool: \(destUser.school)\nPhone: \(destUser.phone)\nemail:\(destUser.email)"
      // title = destUser.name
         descriptionLabel.text = destUser.description
        preferencesLabel.text = "Preferred Subjects: \(preferredSubjectsString)"
        availabilityLabel.text = "Available Days: \(destUser.availableDays)\n\(destUser.availabilityInfo)"
        nameLabel.text = "\(destUser.name)"
       /*whatToSeeLabel.text = vacationSpot.whatToSee
       
        userRatingLabel.text = String(repeating: "★", count: vacationSpot.userRating)*/
        
    }
    
    func displayAlert(title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       /* let currentUserRating = UserDefaults.standard.integer(forKey: "currentUserRating-\(vacationSpot.identifier)")*/
        
        /*if currentUserRating > 0 {
            submitRatingButton.setTitle("Update Rating (\(currentUserRating))", for: UIControlState())
        } else {
            submitRatingButton.setTitle("Submit Rating", for: UIControlState())
        }*/
    }
    
    @IBAction func weatherHideOrShowButtonTapped(_ sender: UIButton) {
        let shouldHideWeatherInfo = sender.titleLabel!.text! == "Hide"
        updateWeatherInfoViews(hideWeatherInfo: shouldHideWeatherInfo, animated: true)
        shouldHideWeatherInfoSetting = shouldHideWeatherInfo
    }
    
    func addFriendFunction() {
        let id = destUser.uid
        print(id)
        FriendSystem.system.sendRequestToUser(id)
        self.displayAlert(title: "Success!", message: "Friend Request Sent")
    }
    
    
    
    func updateWeatherInfoViews(hideWeatherInfo shouldHideWeatherInfo: Bool, animated: Bool) {
        let newButtonTitle = shouldHideWeatherInfo ? "Show" : "Hide"
       // weatherHideOrShowButton.setTitle(newButtonTitle, for: UIControlState())
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
              //  self.descriptionLabel.isHidden = shouldHideWeatherInfo
            })
        } else {
         //   descriptionLabel.isHidden = shouldHideWeatherInfo
        }
    }
    
    @IBAction func addFriendTapped(_ sender: Any) {
        addFriendFunction()
    }
    
    @IBAction func chatTapped(_ sender: Any) {
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "presentMapViewController":
            guard let navigationController = segue.destination as? UINavigationController,
                let mapViewController = navigationController.topViewController as? MapViewController else {
                    fatalError("Unexpected view hierarchy")
            }
            mapViewController.locationToShow =             CLLocationCoordinate2DMake(CLLocationDegrees(destUser.latitude), CLLocationDegrees(destUser.longitude))
            mapViewController.title = destUser.name
        /*case "presentRatingViewController":
            guard let navigationController = segue.destination as? UINavigationController,
                let ratingViewController = navigationController.topViewController as? RatingViewController else {
                    fatalError("Unexpected view hierarchy")
            }
            ratingViewController.vacationSpot = vacationSpot*/
        default:
            fatalError("Unhandled Segue: \(segue.identifier!)")
        }
    }
}

// MARK: - SFSafariViewControllerDelegate

/*extension SpotInfoViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}*/
