

import UIKit
import SafariServices
import Eureka
import CoreLocation

class MoreInfoViewController: UIViewController {
    
    var destinationUser: User!
    
    @IBOutlet var backgroundColoredViews: [UIView]!
    @IBOutlet var headingLabels: [UILabel]!
    
   // @IBOutlet weak var name: UILabel!
    
   
    @IBOutlet weak var basicInfoLabel: UILabel!
   
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
        updateWeatherInfoViews(hideWeatherInfo: shouldHideWeatherInfoSetting, animated: false)
       
        // Clear background colors from labels and buttons
        for view in backgroundColoredViews {
            view.backgroundColor = UIColor.clear
        }
        
        // Set the kerning to 1 to increase spacing between letters
        headingLabels.forEach { $0.attributedText = NSAttributedString(string: $0.text!, attributes: [NSKernAttributeName: 1]) }
        
        basicInfoLabel.text = "\(destinationUser.name) \nAge: \(destinationUser.age) \nSchool: \(destinationUser.school)\nPhone: \(destinationUser.phone)\nemail:\(destinationUser.email)"
       title = destinationUser.name
         descriptionLabel.text = destinationUser.description
        preferencesLabel.text = "Preferred Subjects: \(destinationUser.preferredSubjects)"
        availabilityLabel.text = "Available Days: \(destinationUser.availableDays)\n\(destinationUser.availabilityInfo)"
       /*whatToSeeLabel.text = vacationSpot.whatToSee
       
        userRatingLabel.text = String(repeating: "★", count: vacationSpot.userRating)*/
        
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
    
    
    func updateWeatherInfoViews(hideWeatherInfo shouldHideWeatherInfo: Bool, animated: Bool) {
        let newButtonTitle = shouldHideWeatherInfo ? "Show" : "Hide"
        weatherHideOrShowButton.setTitle(newButtonTitle, for: UIControlState())
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
              //  self.descriptionLabel.isHidden = shouldHideWeatherInfo
            })
        } else {
         //   descriptionLabel.isHidden = shouldHideWeatherInfo
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "presentMapViewController":
            guard let navigationController = segue.destination as? UINavigationController,
                let mapViewController = navigationController.topViewController as? MapViewController else {
                    fatalError("Unexpected view hierarchy")
            }
            mapViewController.locationToShow =             CLLocationCoordinate2DMake(CLLocationDegrees(destinationUser.latitude), CLLocationDegrees(destinationUser.longitude))
            mapViewController.title = destinationUser.name
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
