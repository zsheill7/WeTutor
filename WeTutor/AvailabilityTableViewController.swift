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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadForm() {
        
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
        super.viewWillAppear(animated)
        self.tableView?.tableFooterView = UIView()
        
    }
    
    func multipleSelectorDone(_ item:UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.7)
    }


   

}
