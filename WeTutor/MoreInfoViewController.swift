

import UIKit
import Eureka
import CoreLocation
import SCLAlertView
import ASHorizontalScrollView
import FirebaseAnalytics
import FirebaseAuth
import FirebaseDatabase
import EventKit
import Cosmos

class MoreInfoViewController: UIViewController, UIScrollViewDelegate {
    
    var destUser: User!
    var currentUser: User!
    
    @IBOutlet var backgroundColoredViews: [UIView]!
    @IBOutlet var headingLabels: [UILabel]!
    
   // @IBOutlet weak var name: UILabel!
  //  @IBOutlet weak var callButton: UIButton!
    
//    @IBOutlet weak var textButton: UIButton!
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
    
    @IBOutlet var numberOfRatingsLabel: UILabel!
    @IBOutlet weak var availabilityInfo: UILabel!
    
    @IBOutlet weak var containerView: UIView!
   // @IBOutlet weak var weekDayView: UIScrollView!
    
    @IBOutlet var ratingView: CosmosView!
     var UID: String!
    var userRef = FIRDatabase.database().reference().child("users")
    var senderDisplayName: String?
    var newChannelTextField: UITextField?
    var dbRef: FIRDatabaseReference!
    var tutors = [User]()
    fileprivate var channelRefHandle: FIRDatabaseHandle?
    fileprivate var channels: [Channel] = []
    var tutorName: String = ""
    var tuteeName: String = ""
    var tutorOrTutee = "tutorName"
    var currentUserIsTutor = false
    var iterationStatus = ""
    var newChannel: Channel?
    
    @IBOutlet var rateYourExperienceButton: UIButton!
    fileprivate lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("channels")
    
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
        
      // callButton.contentMode = .scaleAspectFit
      // textButton.contentMode = .scaleAspectFit
        
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
        
      
        
        headingLabels.forEach { $0.attributedText = NSAttributedString(string: $0.text!, attributes: [NSKernAttributeName: 1]) }
        
        basicInfoLabel.text = "Age: \(destUser.grade) \nSchool: \(destUser.school)\nPhone: \(destUser.phone)\nemail:\(destUser.email)"
        // title = destUser.name
         descriptionLabel.text = destUser.description
      //  preferencesLabel.text = "Preferred Subjects: \(preferredSubjectsString)"
        //availabilityLabel.text = "Available Days: \(destUser.availableDays)\n\(destUser.availabilityInfo)"
        nameLabel.text = "\(destUser.name)"
        availabilityInfo.text = destUser.availabilityInfo
        
        self.setupUserRating()
        
        
    }
    
    func setupUserRating() {
        if let userAverageRating = destUser.averageRating {
            self.ratingView.rating = userAverageRating
        } else {
            self.ratingView.rating = 0
        }
        
        let numberOfRatings = destUser.numberOfRatings
        
        
        self.numberOfRatingsLabel.text = "\(String(describing: numberOfRatings)) ratings"
    }
    
    @IBAction func rateYourExperience(_ sender: Any) {
        let appearance = SCLAlertView.SCLAppearance(
           /* kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,*/
            showCloseButton: false
        )

        let subview = UIView(frame: CGRect(x: 25,y: 0,width: 216, height: 140))
        let newCosmosView = CosmosView(frame: CGRect(x: 0,y: 10,width: 216, height: 40))
        newCosmosView.isUserInteractionEnabled = true
        newCosmosView.settings.starSize = 30
        subview.addSubview(newCosmosView)
        
        
        let x = (subview.frame.width - 180) / 2
        let textField1 = UITextField(frame: CGRect(x: 0/*x*/,y: 40,width: 180, height: 80))
        textField1.placeholder = "Additional Comments"
        subview.addSubview(textField1)
        let alert = SCLAlertView(appearance: appearance)
        alert.customSubview = subview
        alert.addButton("Done") {
            print("inside done")
            let uuid = UUID().uuidString
            let cosmosRating = newCosmosView.rating
            let comment = textField1.text
            
            //let newRating = Rating(rating: cosmosRating, comment: comment)
            
            let ratingRef = [
                "ratingNumber": cosmosRating,
                "comment": comment
            ] as [String : Any]
           self.userRef.child(self.destUser.uid).child("ratings").child(uuid).setValue(ratingRef)//child("ratingNumber").setValue(cosmosRating)
            //self.userRef.child(self.destUser.uid).child("ratings").child(uuid).child("comment").setValue(comment)
            
            self.setupUserRating()
        }
        alert.addButton("Cancel") {
            
            
        }
        alert.showInfo("Rate Your Experience", subTitle: "How would you rate your experience with this person?")
        
        
        
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
    
    func addFriend() {
        print(destUser)
        let id = destUser.uid
        print(id)
        //FriendSystem.system.sendRequestToUser(id)
        FriendSystem.system.acceptFriendRequest(id)
        self.createChannel(destUser)
        //self.displayAlert("Success!", message: "Contact Added")
    }
    
    func createChannel() {
        
        //self.performSegue(withIdentifier: "ShowChannel", sender: self)
        
        /*if (indexPath as NSIndexPath).section == Section1.currentChannelsSection.rawValue {*/
        //
        
        //To see if a user started a chat with someone on their friends list
        if currentUser != nil {
            FIRAnalytics.logEvent(withName: "did_select_chat", parameters: [
                "current_user": currentUser.uid as NSObject,
                "current_user_is_tutor": currentUser.isTutor as NSObject
                ])
        }
        
  
        let destUserID = destUser.uid
        channelRef.observeSingleEvent(of: .value, with: { (snapshot) in
            print("channelRef.observeSingleEvent(of: .value, with: { (snapshot) in")
            if snapshot.exists() {
                print(" if snapshot.exists() {")
                if let allChannels = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    print("typeofall")
                    print(type(of: allChannels))
                    print("if let allChannels = ((snapshot.value as AnyObject).allKeys)! as? [String] {")
                    self.iterationStatus = "inProcess"
                    for channel in allChannels {
                        
                        if let channelDict = channel.value as? Dictionary<String, AnyObject> {
                            
                            
                            //print(" if let channel = snapshot.value as? [String: String] {")
                            //This iterates through the channel list and checks if either the tutorName or the tutorName is equal to the current user
                            
                            if self.currentUserIsTutor == false {
                                if let tuteeName = channelDict["tuteeName"] as? String,
                                    let  tutorName = channelDict["tutorName"] as? String{
                                    if tuteeName == FIRAuth.auth()?.currentUser?.uid {
                                        print("if channel[self.tutorOrTutee] == FIRAuth.auth()?.currentUser?.uid {")
                                        
                                        if tutorName == destUserID {
                                            self.iterationStatus = "done"
                                            print("perform segue channel")
                                            print(channel)
                                            let newChannel = Channel(id: channel.key, name: "Chat", tutorName: tutorName, tuteeName: tuteeName)
                                            self.performSegue(withIdentifier: "toChatVC", sender: newChannel)
                                            break
                                        }
                                    }
                                }
                                
                            } else if self.currentUserIsTutor == true {
                                if let tuteeName = channelDict["tuteeName"] as? String,
                                    let  tutorName = channelDict["tutorName"] as? String{
                                    if tutorName == FIRAuth.auth()?.currentUser?.uid {
                                        print("if channel[self.tutorOrTutee] == FIRAuth.auth()?.currentUser?.uid {")
                                        if tuteeName == destUserID {
                                            self.iterationStatus = "done"
                                            print("perform segue channel2")
                                            print(channel)
                                            let newChannel = Channel(id: channel.key, name: "Chat", tutorName: tutorName, tuteeName: tuteeName)
                                            self.performSegue(withIdentifier: "toChatVC", sender: newChannel)
                                            break
                                        }
                                    } //if channelDict["tutorName"]
                                }
                            }
                            
                        }
                    } //for channel in allChannels {
                }
                
            } //if snapshot.exists() {
            
            let uuid = UUID().uuidString
            if self.iterationStatus == "inProcess" {
                if self.tutorOrTutee == "tuteeName" {
                    let channel = Channel(id: uuid, name: "Chat", tutorName: (FIRAuth.auth()?.currentUser?.uid)!, tuteeName: destUserID)
                    print("if tutorOrTutee == tuteeName {")
                    print("iterationStatus")
                    print(self.iterationStatus)
                    
                    self.createChannel(self.destUser)
                    print("if self.iterationStatus == inProcess1 {")
                    print("perform segue channel3")
                    print(channel)
                    
                    self.performSegue(withIdentifier: "toChatVC", sender: channel)
                    
                    
                } else if self.tutorOrTutee == "tutorName" {
                    let channel = Channel(id: uuid, name: "Chat", tutorName: destUserID, tuteeName: (FIRAuth.auth()?.currentUser?.uid)!)
                    print("if tutorOrTutee == tutorName {")
                    
                    print("if self.iterationStatus == inProcess2 {")
                    self.createChannel(self.destUser)
                    print("perform segue channel4")
                    print(channel)
                    self.performSegue(withIdentifier: "toChatVC", sender: channel)
                    
                }
            }
        })
    }
    
    
    func createChannel(_ otherUser: User) {
        
        
        
        /*let userDefaults = UserDefaults.standard
         if let isTutor = userDefaults.value(forKey: "isTutor") as? Bool,
         let userName = userDefaults.value(forKey: "name") as? String {
         }
         }*/
        let userDefaults = UserDefaults.standard
        let isTutor = userDefaults.value(forKey: "isTutor") as? Bool
        
        if let userID = FIRAuth.auth()?.currentUser?.uid {
            
            if isTutor == true {
                tutorName = userID
                tuteeName = otherUser.uid
            } else {
                tutorName = otherUser.uid
                tuteeName = userID
            }
        } else {
            tutorName = "Chat"
            tuteeName = "Chat"
        }
        
        
        
        let newCalendarId = createCalendar(destUser: otherUser)
        
        let channelItem = [
            "tutorName": tutorName,
            "tuteeName": tuteeName,
            "calendarId": newCalendarId
        ]
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        
        
        let uuid = UUID().uuidString
        self.newChannel = Channel(id: uuid, name: channelItem["tutorName"]!, tutorName: tutorName, tuteeName: tuteeName)
        if let userName = userDefaults.value(forKey: "name") as? String {
            
            self.senderDisplayName = userID
        } else {
            self.senderDisplayName = FIRAuth.auth()?.currentUser?.email
        }
        
        
        let userChannelRef = userRef.child(userID!).child("channels")
        let newChannelRef = channelRef.child(uuid)
        newChannelRef.setValue(channelItem)
        
        //This sets the channel item in the child "channels"
        userChannelRef.child(uuid).child("tutorName").setValue(tutorName)
        userChannelRef.child(uuid).child("tuteeName").setValue(tuteeName)
        userChannelRef.child(uuid).child("calendarId").setValue(newCalendarId)
        
        //This adds the other user as a "friend" child to the current user ref and vice versa
        FriendSystem.system.acceptFriendRequest(otherUser.uid)
        
        // self.performSegue(withIdentifier: "toChatVC", sender: self.newChannel)
        
    }
    
    func createCalendar(destUser: User) -> String {
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        let userChannelRef = userRef.child(userID!).child("channels")
        
        let channelRef = FIRDatabase.database().reference()
        
        let eventStore = EKEventStore()
        //let initCalendar = EKCalendar()
        //let eventCalendar = initCalendar.calendar
        
        // Use Event Store to create a new calendar instance
        // Configure its title
        var newCalendar = EKCalendar(for: .event, eventStore: eventStore)
        
        //var newCalendar = eventStore.calendar
        // newCalendar.calendarIdentifier = identifier
        // Probably want to prevent someone from saving a calendar
        // if they don't type in a name...
        
        if currentUser != nil {
            newCalendar.title = "Events (\(destUser.name) & \(currentUser!.name))"
        }
        
        
        // Access list of available sources from the Event Store
        let sourcesInEventStore = eventStore.sources
        
        // Filter the available sources and select the "Local" source to assign to the new calendar's
        // source property
        newCalendar.source = sourcesInEventStore.filter{
            (source: EKSource) -> Bool in
            source.sourceType.rawValue == EKSourceType.local.rawValue
            }.first!
        
        //channelRef.child("calendarId").setValue(newCalendar.calendarIdentifier)
        //userChannelRef.child("calendarId").setValue(newCalendar.calendarIdentifier)
        
        //self.calendars.append(newCalendar)
        
        do {
            try eventStore.saveCalendar(newCalendar, commit: true)
            //UserDefaults.standardUserDefaults().setObject(newCalendar.calendarIdentifier, forKey: "EventTrackerPrimaryCalendar")
        } catch {
            //  displayAlert("Unab", message: <#T##String#>)
        }
        
        return newCalendar.calendarIdentifier
        
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
    
    
    @IBAction func openInMap(_ sender: Any) {
        self.performSegue(withIdentifier: "presentMapViewController", sender: self)
    }
    
    @IBAction func addFriendTapped(_ sender: Any) {
        addFriendFunction()
    }
    
    @IBAction func chatTapped(_ sender: Any) {
        self.addFriend()
        self.createChannel()
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
            case "toChatVC":
                if let channel = sender as? Channel {
                    let chatVc = segue.destination as! ChatViewController
                    
                    print("senderdisplayName")
                    print(senderDisplayName)
                    print("channelRef1")
                    print(channelRef.child(channel.id))
                    chatVc.senderDisplayName = senderDisplayName!
                    chatVc.channel = channel
                    chatVc.channelRef = channelRef.child(channel.id)
                }
            default:
                fatalError("Unhandled Segue: \(segue.identifier!)")
            }
        }
    }
    
    
}


