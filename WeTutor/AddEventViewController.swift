//
//  AddEventViewController.swift
//  WeTutor
//
//  Created by Zoe on 4/8/17.
//  Copyright © 2017 TokkiTech. All rights reserved.
//

import UIKit
import Eureka
import FirebaseDatabase
import FirebaseAuth

class AddEventNavigationController: UINavigationController, RowControllerType {
    var onDismissCallback : ((UIViewController) -> ())?
}


class AddEventViewController: FormViewController {

    var channel: Channel? {
        didSet {
            title = channel?.name
        }
    }
    var channelRef: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FriendSystem.system.getCurrentUser { (user) in
            //self.usernameLabel.text = user.email
        }
        
        //FriendSystem.system.addFriendObserver(friendListNumber: <#Int#>) {
            print("inside FriendSystem.system.addFriendObserver")
            // self.loadAllCalendars()
            
            self.tableView?.reloadData()
            //self.observeChannels()
            
       // }
        
        initializeForm()
        
        
        
        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = #selector(AddEventViewController.cancelTapped(_:))
        // Do any additional setup after loading the view.
    }

    /*@IBAction func backButtonPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Tutor", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "tutorPagingMenuNC") as! UINavigationController
        //controller.modalTransitionStyle = .flipHorizontal
        self.present(controller, animated: true, completion: nil)
    }*/
    private func initializeForm() {
        
        form +++
            
            TextRow("Title").cellSetup { cell, row in
                cell.textField.placeholder = row.tag
            }
            
            <<< TextRow("Location").cellSetup {
                $1.cell.textField.placeholder = $0.row.tag
            }
            
            +++
            
            SwitchRow("All-day") {
                $0.title = $0.tag
                }.onChange { [weak self] row in
                    let startDate: DateTimeInlineRow! = self?.form.rowBy(tag: "Starts")
                    let endDate: DateTimeInlineRow! = self?.form.rowBy(tag: "Ends")
                    
                    if row.value ?? false {
                        startDate.dateFormatter?.dateStyle = .medium
                        startDate.dateFormatter?.timeStyle = .none
                        endDate.dateFormatter?.dateStyle = .medium
                        endDate.dateFormatter?.timeStyle = .none
                    }
                    else {
                        startDate.dateFormatter?.dateStyle = .short
                        startDate.dateFormatter?.timeStyle = .short
                        endDate.dateFormatter?.dateStyle = .short
                        endDate.dateFormatter?.timeStyle = .short
                    }
                    startDate.updateCell()
                    endDate.updateCell()
                    startDate.inlineRow?.updateCell()
                    endDate.inlineRow?.updateCell()
            }
            
            <<< DateTimeInlineRow("Starts") {
                $0.title = $0.tag
                $0.value = Date().addingTimeInterval(60*60*24)
                }
                .onChange { [weak self] row in
                    let endRow: DateTimeInlineRow! = self?.form.rowBy(tag: "Ends")
                    if row.value?.compare(endRow.value!) == .orderedDescending {
                        endRow.value = Date(timeInterval: 60*60*24, since: row.value!)
                        endRow.cell!.backgroundColor = .white
                        endRow.updateCell()
                    }
                }
                .onExpandInlineRow { cell, row, inlineRow in
                    inlineRow.cellUpdate { [weak self] cell, dateRow in
                        let allRow: SwitchRow! = self?.form.rowBy(tag: "All-day")
                        if allRow.value ?? false {
                            cell.datePicker.datePickerMode = .date
                        }
                        else {
                            cell.datePicker.datePickerMode = .dateAndTime
                        }
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
            }
            
            <<< DateTimeInlineRow("Ends"){
                $0.title = $0.tag
                $0.value = Date().addingTimeInterval(60*60*25)
                }
                .onChange { [weak self] row in
                    let startRow: DateTimeInlineRow! = self?.form.rowBy(tag: "Starts")
                    if row.value?.compare(startRow.value!) == .orderedAscending {
                        row.cell!.backgroundColor = .red
                    }
                    else{
                        row.cell!.backgroundColor = .white
                    }
                    row.updateCell()
                }
                .onExpandInlineRow { cell, row, inlineRow in
                    inlineRow.cellUpdate { [weak self] cell, dateRow in
                        let allRow: SwitchRow! = self?.form.rowBy(tag: "All-day")
                        if allRow.value ?? false {
                            cell.datePicker.datePickerMode = .date
                        }
                        else {
                            cell.datePicker.datePickerMode = .dateAndTime
                        }
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
        }
        
        form +++
            
            PushRow<RepeatInterval>("Repeat") {
                $0.title = $0.tag
                $0.options = RepeatInterval.allValues
                $0.value = .Never
                }.onPresent({ (_, vc) in
                    vc.enableDeselection = false
                    vc.dismissOnSelection = false
                })
        
        form +++
            
            PushRow<EventAlert>() {
                $0.title = "Alert"
                $0.options = EventAlert.allValues
                $0.value = .Never
                }
                .onChange { [weak self] row in
                    if row.value == .Never {
                        if let second : PushRow<EventAlert> = self?.form.rowBy(tag: "Another Alert"), let secondIndexPath = second.indexPath {
                            row.section?.remove(at: secondIndexPath.row)
                        }
                    }
                    else{
                        guard let _ : PushRow<EventAlert> = self?.form.rowBy(tag: "Another Alert") else {
                            let second = PushRow<EventAlert>("Another Alert") {
                                $0.title = $0.tag
                                $0.value = .Never
                                $0.options = EventAlert.allValues
                            }
                            row.section?.insert(second, at: row.indexPath!.row + 1)
                            return
                        }
                    }
        }
        
        /*form +++
            
            PushRow<EventState>("Show As") {
                $0.title = "Show As"
                $0.options = EventState.allValues
        }*/
        
        form +++
            
            
            TextAreaRow("Notes") {
                $0.placeholder = "Notes"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 50)
        }
        
        form +++
        
            ButtonRow() {
                $0.title = "Add Event"
                
            }.onCellSelection {  cell, row in
                
                let row1: TextRow? = self.form.rowBy(tag: "Title")
                let title = row1?.value
                let row2: TextRow? = self.form.rowBy(tag: "Location")
                let location = row2?.value
                let row3: DateTimeInlineRow? = self.form.rowBy(tag: "Starts")
                
                let startDate = row3?.value
                var startDateInterval = startDate?.timeIntervalSince1970
                let row4: DateTimeInlineRow? = self.form.rowBy(tag: "Ends")
                let endDate = row4?.value
                var endDateInterval = endDate?.timeIntervalSince1970
                
                let row5: PushRow<RepeatInterval>? = self.form.rowBy(tag: "Repeat")
                let repeatInterval = row5?.value?.description
                let row6: PushRow<EventAlert>? = self.form.rowBy(tag: "Alert")
                let alert = row6?.value?.description
                
                let row7: TextAreaRow? = self.form.rowBy(tag: "Notes")
                let notes = row7?.value
                //let row7: TextRow? = self.form.rowBy(tag: "Title")
                //let title = row7?.value
                let uuid = UUID().uuidString
                let eventDict = ["title": title, "location": location, "startDate": startDateInterval, "endDate": endDateInterval, "repeatInterval": repeatInterval, "alert": alert ?? "", "notes": notes ?? ""] as [String : Any]
                print("channelRefe \(self.channelRef) eventDict \(eventDict) uid \(Auth.auth().currentUser?.uid)")
                self.channelRef?.child("events").child(uuid).setValue(eventDict)
                
                let storyboard = UIStoryboard(name: "Tutor", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "tutorPagingMenuNC") as! UINavigationController
                //controller.modalTransitionStyle = .flipHorizontal
                self.present(controller, animated: true, completion: nil)
        }
    }
    
    func cancelTapped(_ barButtonItem: UIBarButtonItem) {
        (navigationController as? AddEventNavigationController)?.onDismissCallback?(self)
    }
    
    enum RepeatInterval : String, CustomStringConvertible {
        case Never = "Never"
        case Every_Day = "Every Day"
        case Every_Week = "Every Week"
        case Every_2_Weeks = "Every 2 Weeks"
        case Every_Month = "Every Month"
        case Every_Year = "Every Year"
        
        var description : String { return rawValue }
        
        static let allValues = [Never, Every_Day, Every_Week, Every_2_Weeks, Every_Month, Every_Year]
    }
    
    enum EventAlert : String, CustomStringConvertible {
        case Never = "None"
        case At_time_of_event = "At time of event"
        case Five_Minutes = "5 minutes before"
        case FifTeen_Minutes = "15 minutes before"
        case Half_Hour = "30 minutes before"
        case One_Hour = "1 hour before"
        case Two_Hour = "2 hours before"
        case One_Day = "1 day before"
        case Two_Days = "2 days before"
        
        var description : String { return rawValue }
        
        static let allValues = [Never, At_time_of_event, Five_Minutes, FifTeen_Minutes, Half_Hour, One_Hour, Two_Hour, One_Day, Two_Days]
    }
    
    enum EventState {
        case busy
        case free
        
        static let allValues = [busy, free]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
