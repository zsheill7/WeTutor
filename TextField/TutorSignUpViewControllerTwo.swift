//  ViewController.swift
//  Eureka ( https://github.com/xmartlabs/Eureka )
//
//  Copyright (c) 2016 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import Eureka
import CoreLocation
import FirebaseDatabase
import Firebase
//MARK: HomeViewController


//MARK: Emoji

typealias Emoji = String
let 👦🏼 = "👦🏼", 🍐 = "🍐", 💁🏻 = "💁🏻", 🐗 = "🐗", 🐼 = "🐼", 🐻 = "🐻", 🐖 = "🐖", 🐡 = "🐡"

//Mark: RowsExampleViewController


//MARK: Custom Cells Example



class TutorSignUpViewControllerTwo : FormViewController {
    
    let firstLanguages = ["English", "Spanish", "French", "Chinese", "Other"]
    let secondLanguages = ["None", "English", "Spanish", "French", "Chinese", "Other"]

  
    var ref: FIRDatabaseReference!
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.addBackground(imageName: "mixed2")
        //let availableDays: [Bool] = [false, false, false, false, false, false, false]
        let availabilityInfo: String = ""
        var languages: [String] = [String]()
        
        
        ref = FIRDatabase.database().reference()
        form
            /*Section() {
                var header = HeaderFooterView<EurekaLogoViewNib>(.nibFile(name: "EurekaSectionHeader", bundle: nil))
                header.onSetupView = { (view, section) -> () in
                    view.imageView.alpha = 0;
                    UIView.animate(withDuration: 2.0, animations: { [weak view] in
                        view?.imageView.alpha = 1
                    })
                    view.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1)
                    UIView.animate(withDuration: 1.0, animations: { [weak view] in
                        view?.layer.transform = CATransform3DIdentity
                    })
                }
                $0.header = header
            }*/
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
                    let weekDayCell = WeekDayCell()
                    if daysValue != nil {
                        weekDayString = weekDayCell.getStringFromArray(daysValue!)
                        print("daysValue: " + weekDayString)
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
                        self.ref.child("users/\(user.uid)/languages").setValue(languages)
                        self.ref.child("users/\(user.uid)/availabilityInfo").setValue(availabilityInfo)
                        
                        self.performSegue(withIdentifier: "toPagingMenuVC", sender: self)
                    
                    } else {
                        // No user is signed in.
                        // ...
                    }
        
                    
                    
        }
        
    

        


        
        
    }
    
    func multipleSelectorDone(_ item:UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.7)
    }
}

//MARK: Field row customization Example


//MARK: HiddenRowsExample



class EurekaLogoViewNib: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class EurekaLogoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let imageView = UIImageView(image: UIImage(named: "Eureka"))
        imageView.frame = CGRect(x: 0, y: 0, width: 320, height: 130)
        imageView.autoresizingMask = .flexibleWidth
        self.frame = CGRect(x: 0, y: 0, width: 320, height: 130)
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
