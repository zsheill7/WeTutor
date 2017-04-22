//
//  TutorSignUpViewControllerThree.swift
//  WeTutor
//
//  Created by Zoe on 4/2/17.
//  Copyright © 2017 TokkiTech. All rights reserved.
//

import UIKit
import Eureka
import CoreLocation
import FirebaseDatabase
import FirebaseAnalytics
import FirebaseAuth

class CurrencyFormatter : NumberFormatter, FormatterProtocol {
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, range rangep: UnsafeMutablePointer<NSRange>?) throws {
        guard obj != nil else { return }
        let str = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        obj?.pointee = NSNumber(value: (Double(str) ?? 0.0)/Double(pow(10.0, Double(minimumFractionDigits))))
    }
    
    func getNewPosition(forPosition position: UITextPosition, inTextInput textInput: UITextInput, oldValue: String?, newValue: String?) -> UITextPosition {
        return textInput.position(from: position, offset:((newValue?.characters.count ?? 0) - (oldValue?.characters.count ?? 0))) ?? position
    }
}

class TutorSignUpViewControllerThree : FormViewController {


    override func dismissKeyboard() {
        view.endEditing(true)
    }

    var ref: FIRDatabaseReference!

    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationAccessoryView = NavigationAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        
        // self.hideKeyboardWhenTappedAround()
        // self.tableView?.addBlueBackground("mixed2")
        //let availableDays: [Bool] = [false, false, false, false, false, false, false]
        self.tableView?.backgroundColor = UIColor.backgroundBlue()
        
        ref = FIRDatabase.database().reference()
        
        self.loadForm()
        
        
    }
    
    func loadForm() {
        
        form
            
            +++ Section()
            <<< DecimalRow() {
                $0.useFormatterDuringInput = true
                $0.title = "Price"
                $0.placeholder = "17"
                let formatter = CurrencyFormatter()
                formatter.locale = .current
                formatter.numberStyle = .currency
                $0.formatter = formatter
            }
    }
    
    
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
        cell.backgroundColor = UIColor(white: 1, alpha: 0.7)
    }
}
