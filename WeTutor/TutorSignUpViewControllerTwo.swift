//  ViewController.swift


import UIKit
import Eureka
import CoreLocation
import FirebaseDatabase
import Firebase




class TutorSignUpViewControllerTwo : FormViewController {
    
    let firstLanguages = ["English", "Spanish", "French", "Chinese", "Other"]
    let secondLanguages = ["None", "English", "Spanish", "French", "Chinese", "Other"]

  
    /*override func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }*/
    
    override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    var ref: FIRDatabaseReference!
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.hideKeyboardWhenTappedAround()
       // self.tableView?.addBlueBackground("mixed2")
        //let availableDays: [Bool] = [false, false, false, false, false, false, false]
        self.view.backgroundColor = UIColor(red:0.70, green:0.87, blue:0.88, alpha:1.0)
        ref = FIRDatabase.database().reference()
        
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
            }
            
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
            
            
            
            +++ Section()
            <<< ButtonRow() {
                $0.title = "Finish"
                }
                .onCellSelection { cell, row in
                    
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
                    }
                    if secondLanguage != "None" && secondLanguage != nil{
                        languages.append(secondLanguage!)
                    }
                    if thirdLanguage != "None" && thirdLanguage != nil{
                        languages.append(thirdLanguage!)
                    }
                    
                    print(languages)
                    
                    
                    userDefaults.setValue(weekDayString, forKey: "availableDays")
                    userDefaults.setValue(languages, forKey: "languages")
                    userDefaults.setValue(availabilityInfo, forKey: "availabilityInfo")
                    userDefaults.synchronize()
                    
                    if let user = FIRAuth.auth()?.currentUser {
                        self.ref.child("users/\(user.uid)/availableDays").setValue(weekDayString)
                        self.ref.child("users/\(user.uid)/availableDaysArray").setValue(weekDayArray)
                        self.ref.child("users/\(user.uid)/languages").setValue(languages)
                        self.ref.child("users/\(user.uid)/availabilityInfo").setValue(availabilityInfo)
                        
                        self.performSegue(withIdentifier: "toPagingMenuVC", sender: self)
                        
                    } else {
                        // No user is signed in.
                        // ...
                    }
                    
                    
                    
        }

    }
    
    /**
     * Called when 'return' key pressed. return NO to ignore.
     */
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        cell.backgroundColor = UIColor(white: 1, alpha: 0.7)
    }
}






