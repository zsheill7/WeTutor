//
//  AvailabilityTableViewController.swift
//  WeTutor
//
//  Created by Zoe on 3/25/17.
//  Copyright © 2017 TokkiTech. All rights reserved.
//

import UIKit
import Eureka
import Material

class AvailabilityTableViewController: FormViewController{
    
    var destUser: User! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.backgroundColor = UIColor.white
        self.loadForm()
        self.view.isUserInteractionEnabled = false
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadForm() {
        
       /* let availabilityInfo: String = ""
        var languages: [String] = [String]()*/
        let availableDaysBoolArray = destUser.availableDaysArray
        
        let weekDayCell = WeekDayCell()
        let availableDaysWeekdayArray: [WeekDay] = weekDayCell.getWeekDaySetFromBoolArray(availableDaysBoolArray)
        
        let availableDaysWeekdaySet = Set(availableDaysWeekdayArray)
        form
            
            +++ Section()
            
            
            
            <<< WeekDayRow("Available Days"){
                $0.value = availableDaysWeekdaySet/*[.monday, .wednesday, .friday]*/
                
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
