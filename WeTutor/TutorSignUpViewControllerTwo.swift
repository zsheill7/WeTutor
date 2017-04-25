//  ViewController.swift


import UIKit
import Eureka
import CoreLocation
import FirebaseDatabase
import FirebaseAnalytics
import FirebaseAuth
import Popover
import NVActivityIndicatorView
import SCLAlertView

class TutorSignUpViewControllerTwo : FormViewController, NVActivityIndicatorViewable {
    
    let firstLanguages = ["English", "Spanish", "French", "Chinese", "Other"]
    let secondLanguages = ["None", "English", "Spanish", "French", "Chinese", "Other"]

    func displayAlert(_ title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)
        
    }
    
    override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    var ref: FIRDatabaseReference!
    var currentUser: User?
    var profileImageUrlString = ""
    var currentUserIsTutor: Bool?
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationAccessoryView = NavigationAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        
        if currentUserIsTutor == true {
            prepareInfoButton()
        }
        
        ref = FIRDatabase.database().reference()
        
        
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let user = User(snapshot: snapshot)
            self.currentUser = user
            let value = snapshot.value as? NSDictionary
            let profile = value?["profileImageURL"] as! String
            // let user = User.init(username: username)
            self.profileImageUrlString = profile
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
  
        let currentUser = FriendSystem.system.currentUser
        if currentUser != nil {
            self.currentUserIsTutor = currentUser?.isTutor
        }
        self.loadForm()
    }
    
    func loadForm() {
        
        let availabilityInfo: String = ""
        var languages: [String] = [String]()
        
        form
            
            +++ Section("Available Days")
            
            
            
            <<< WeekDayRow("Available Days"){
                $0.value = [.monday, .wednesday, .friday]
                
            }
            
            +++ Section("More Info on Availability (optional)")
            
            <<< TextAreaRow("Availability Notes") {
                $0.placeholder = "I'm available Sundays, but only after 3:00."
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 70)
            }.cellSetup({ (cell, row) in
                cell.backgroundColor = UIColor.clear
               // row.backgroundColor = UIColor.clear
                cell.textView.backgroundColor = UIColor.clear
               
            
            })
    
            +++ Section("Languages")
            
            <<< PickerInlineRow<String>("First Language") { (row : PickerInlineRow<String>) -> Void in
                row.title = "First Language"
                row.options = firstLanguages
                
                row.value = row.options[0]
            }
            <<< PickerInlineRow<String>("Second Language") { (row : PickerInlineRow<String>) -> Void in
                row.title = row.tag
                row.options = secondLanguages
                
                row.value = row.options[0]
            }
            <<< PickerInlineRow<String>("Third Language") { (row : PickerInlineRow<String>) -> Void in
                row.title = row.tag
                row.options = secondLanguages
                
                row.value = row.options[0]
            }
             +++ Section("")
            /*ButtonRow() {
                $0.title = "Price FAQ"
            }
            .onCellSelection {  cell, row in  //do whatever you want  
                self.openPricePopover()
                }*/
                
            <<< DecimalRow("Price") {
                $0.useFormatterDuringInput = true
                $0.title = "Hourly Price"
                $0.placeholder = "$17.00"
                let formatter = CurrencyFormatter()
                formatter.locale = .current
                formatter.numberStyle = .currency
                $0.formatter = formatter
                if currentUserIsTutor != nil {
                    $0.hidden = .function([""], { form -> Bool in
                        return !self.currentUserIsTutor!
                    })

                } else {
                    $0.hidden = false
                }
            }
            
            +++ Section()
            <<< ButtonRow() {
                $0.title = "Finish"
                }
                .onCellSelection { cell, row in
                    let size = CGSize(width: 30, height:30)
                    
                    self.startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 6)!)
                    
                    let userDefaults = UserDefaults.standard
                    
                    
                    
                    
                    //let availableDays: [Bool] = row
                    let row1: WeekDayRow? = self.form.rowBy(tag: "Available Days")
                    let daysValue = row1?.value
                    
                    //
                    var weekDayString = ""
                    var weekDayArray:[Bool] = []
                    let weekDayCell = WeekDayCell()
                    if daysValue != nil {
                        weekDayString = weekDayCell.getStringFromArray(daysValue!)
                        weekDayArray = weekDayCell.getBoolArrayFromArray(daysValue!)
                        print("daysValue: " + weekDayString)
                    } else {
                        print( "if daysValue == nil" )
                    }
                    
                    
                    let row2: TextRow? = self.form.rowBy(tag: "Availability Notes")
                    let availabilityInfo = row2?.value
                    row2?.cell.contentView.tintColor = UIColor(white: 1, alpha: 0.7)
                    
                    var firstLanguage = ""
                    if let row3 = self.form.rowBy(tag: "First Language") as? TextRow? {
                        firstLanguage = (row3?.value)!
                    } else {
                        firstLanguage = "English"
                    }
                    
                    
                    print(firstLanguage)
                    let row4: TextRow? = self.form.rowBy(tag: "Second Language")
                    let secondLanguage = row4?.value
                    
                    let row5: TextRow? = self.form.rowBy(tag: "Third Language")
                    let thirdLanguage = row5?.value
                    
                    if firstLanguage != "None" {
                        languages.append(firstLanguage)
                        FIRAnalytics.setUserPropertyString(firstLanguage, forName: "first_language")
                    }
                    if secondLanguage != "None" && secondLanguage != nil{
                        languages.append(secondLanguage!)
                        FIRAnalytics.setUserPropertyString(secondLanguage, forName: "second_language")
                    }
                    if thirdLanguage != "None" && thirdLanguage != nil{
                        languages.append(thirdLanguage!)
                        FIRAnalytics.setUserPropertyString(thirdLanguage, forName: "third_language")
                    }
                    
                    print(languages)
                    
                    let row6: DecimalRow? = self.form.rowBy(tag: "Price")
                    let hourlyPrice = row6?.value
                    if hourlyPrice != nil {
                        FIRAnalytics.setUserPropertyString(String(describing: hourlyPrice), forName: "third_language")
                    }
                    
                    if hourlyPrice != nil || self.currentUserIsTutor == false {
                        
                        for i in 0...6 {
                            FIRAnalytics.setUserPropertyString("\(weekDayArray[i])", forName: "\(weekdays[i])_available")
                        }
                        FIRAnalytics.setUserPropertyString(availabilityInfo, forName: "availability_info")
                        
                        
                        
                        userDefaults.setValue(weekDayString, forKey: "availableDays")
                        userDefaults.setValue(languages, forKey: "languages")
                        userDefaults.setValue(availabilityInfo, forKey: "availabilityInfo")
                        userDefaults.synchronize()
                        
                        if let user = FIRAuth.auth()?.currentUser {
                            self.ref.child("users/\(user.uid)/availableDays").setValue(weekDayString)
                            self.ref.child("users/\(user.uid)/availableDaysArray").setValue(weekDayArray)
                            self.ref.child("users/\(user.uid)/languages").setValue(languages)
                            self.ref.child("users/\(user.uid)/availabilityInfo").setValue(availabilityInfo)
                            self.ref.child("users/\(user.uid)/completedTutorial").setValue(false)
                            self.ref.child("users/\(user.uid)/hourlyPrice").setValue(hourlyPrice)
                            self.stopAnimating()
                            self.performSegue(withIdentifier: "toProfilePictureVC", sender: self)
                            
                        } else {
                            // No user is signed in.
                            // ...
                        }
                        

                    } else {
                       self.displayAlert("Error", message: "Please input a price.")
                    }
                    
                    self.stopAnimating()

                    
                    
                    
        }
        

    }
    
    let infoButton = UIButton()
    
    fileprivate var popover: Popover!
    
    func prepareInfoButton() {
        
        
        infoButton.setImage(UIImage(named: "Info-25"), for: UIControlState.normal)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Info-25"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(infoButtonTapped))
    }
    
    var texts = ["If you wish to be a volunteer tutor, please enter 0.00 for your price"]
    
    func infoButtonTapped() {
        
        
        self.popover = Popover()
        
        let startPoint = CGPoint(x: self.view.frame.width - 25, y: 55)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let pricePopoverVC = storyboard.instantiateViewController(withIdentifier: "pricePopoverVC")
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        /*tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false*/
        
        view.addSubview(pricePopoverVC.view)
        //self.popover = Popover(options: self.popoverOptions)
        
        //self.popover.show(tableView, point: self.rightButtomButton)
        popover.show(view, point: startPoint)
    }

    
   // let popover = Popover()
    func openPricePopover() {
       /* self.popover = Popover()
        let startPoint = CGPoint(x: self.view.frame.width - 25, y: self.view.frame.height - 55)
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        tableView.numberOfSections = 1
        tableView.numberOfRowsInSection = 1
        tableView.cellForRowAt
        tableView.isScrollEnabled = false
        //self.popover = Popover(options: self.popoverOptions)
        
        //self.popover.show(tableView, point: self.rightButtomButton)
        popover.show(tableView, point: startPoint)*/
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfilePictureVC" {
            
            
            let destinationVC: ProfilePictureViewController = segue.destination as! ProfilePictureViewController
            
           // destinationVC.currentUser = currentUser
            
            destinationVC.profileImageUrlString = profileImageUrlString
        }
    }
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // <<< ---ADD THIS LINE
        //
        self.tableView?.tableFooterView = UIView()
        
    }
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
   /* override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    */
    func multipleSelectorDone(_ item:UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 1.0)
    }
}







