//
//  Unused.swift
//  WeTutor
//
//  Created by Zoe on 3/12/17.
//  Copyright © 2017 TokkiTech. All rights reserved.
//

import Foundation

/* override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
 cell.backgroundColor = UIColor(white: 1, alpha: 0.7)
 }*/

// MARK: Actions

/*func submit(_: UIBarButtonItem!) {
 
 let message = self.form.formValues().description
 
 let alertController = UIAlertController(title: "Form output", message: message, preferredStyle: .alert)
 
 let cancel = UIAlertAction(title: "OK", style: .cancel) { (action) in
 }
 
 alertController.addAction(cancel)
 
 self.present(alertController, animated: true, completion: nil)
 }
 
 // MARK: Private interface
 
 
 fileprivate func loadForm() {
 
 let form = FormDescriptor(title: "Example Form")
 
 var row = FormRowDescriptor(tag: Static.emailTag, type: .name, title: "Email")
 
 
 
 let section1 = FormSectionDescriptor(headerTitle: "  ", footerTitle: nil)
 let section15 = FormSectionDescriptor(headerTitle: "  ", footerTitle: nil)
 
 
 row = FormRowDescriptor(tag: Static.zipcodeTag, type: .text, title: "Zip Code")
 row.configuration.cell.appearance = ["textField.placeholder" : "e.g. 98040" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
 section1.rows.append(row)
 
 let section2 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
 
 row = FormRowDescriptor(tag: Static.schoolTag, type: .name, title: "School Name")
 row.configuration.cell.appearance = ["textField.placeholder" : "e.g. Mercer Island High School" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
 section2.rows.append(row)
 
 row = FormRowDescriptor(tag: Static.phoneTag, type: .phone, title: "Phone")
 row.configuration.cell.appearance = ["textField.placeholder" : "e.g. 13069242633" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
 section2.rows.append(row)
 
 let section3 = FormSectionDescriptor(headerTitle: " ", footerTitle: nil)
 
 row = FormRowDescriptor(tag: Static.gender, type: .picker, title: "Gender")
 row.configuration.cell.showsInputToolbar = true
 row.configuration.selection.options = (["F", "M", "U"] as [String]) as [AnyObject]
 row.configuration.selection.optionTitleClosure = { value in
 guard let option = value as? String else { return "" }
 switch option {
 case "F":
 return "Female"
 case "M":
 return "Male"
 case "U":
 return "Other/I'd rather not say"
 default:
 return ""
 }
 }
 
 row.value = "F" as AnyObject
 
 section3.rows.append(row)
 
 /*row = FormRowDescriptor(tag: Static.birthday, type: .date, title: "Birthday")
 row.configuration.cell.showsInputToolbar = true*/
 
 row = FormRowDescriptor(tag: Static.subjects, type: .picker, title: "Grade")
 row.configuration.selection.options = (["Kindergarten", "1st grade", "2nd grade", "3rd grade", "4th grade", "5th grade", "6th grade", "7th grade", "8th grade", "9th grade", "10th grade", "11th grade", "12th grade", "College"] as [String]) as [AnyObject]
 row.configuration.selection.allowsMultipleSelection = true
 row.configuration.selection.optionTitleClosure = { value in
 guard let option = value as? String else { return "" }
 return option
 /*switch option {
 case "Kindergarten":
 return "Kindergarten"
 case "1st grade":
 return "1st grade"
 case "2nd grade":
 return "2nd grade"
 case "3rd grade":
 return "3rd grade"
 case "4th grade":
 return "4th grade"
 case "5th grade":
 return "5th grade"
 case "6th grade":
 return "6th grade"
 case "7th grade":
 return "7th grade"
 case "8th grade":
 return "8th grade"
 case "9th grade":
 return "9th grade"
 case "10th grade":
 return "10th grade"
 case "11th grade":
 return "11th grade"
 case "12th grade":
 return "12th grade"
 case 13:
 return "College"*/
 
 
 
 
 }
 row.value = "Kindergarten" as AnyObject
 
 section3.rows.append(row)
 
 row = FormRowDescriptor(tag: Static.subjects, type: .picker, title: "Preferred Subject")
 row.configuration.selection.options = ([0, 1, 2] as [Int]) as [AnyObject]
 row.configuration.selection.allowsMultipleSelection = true
 row.configuration.selection.optionTitleClosure = { value in
 guard let option = value as? Int else { return "" }
 switch option {
 case 0:
 return "No Preference"
 case 1:
 return "Math"
 case 2:
 return "Reading or writing"
 case 3:
 return "Science"
 
 
 default:
 return ""
 }
 }
 row.value = 0 as AnyObject
 
 
 
 section3.rows.append(row)
 
 
 
 
 let section4 = FormSectionDescriptor(headerTitle: "Description", footerTitle: nil)
 row = FormRowDescriptor(tag: Static.textView, type: .multilineText, title: "About Me")
 // row.cell.contentView.tintColor = UIColor(white: 1, alpha: 0.5)
 
 row.configuration.cell.appearance = ["tintColor" : UIColor.red]
 section4.rows.append(row)
 
 
 let section5 = FormSectionDescriptor(headerTitle: " ", footerTitle: nil)
 
 //row.configuration.cell.appearance = ["textField.placeholder" : "This will be a part of your profile. Tell us about yourself. What are your extracurriculars?  Do you have experience with working with children?" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
 
 row = FormRowDescriptor(tag: Static.button, type: .button, title: "Continue")
 
 row.configuration.button.didSelectClosure = { _ in
 self.view.endEditing(true)
 print("finished")
 
 // self.form.validateForm()
 if let zipcode = self.form.sections[0].rows[0].value as? String,
 let schoolName = self.form.sections[2].rows[0].value,
 let phone    = self.form.sections[2].rows[1].value,
 let gender    = self.form.sections[3].rows[0].value,
 let grade    = self.form.sections[3].rows[1].value,
 let preferredSubject = self.form.sections[3].rows[2].value,
 let description = self.form.sections[4].rows[0].value as? String {
 
 self.ref = FIRDatabase.database().reference()
 
 
 let userDefaults = UserDefaults.standard
 userDefaults.set(description, forKey: "description")
 print(schoolName)
 print(grade)
 print(description)
 
 let user = FIRAuth.auth()?.currentUser
 
 let userID = FIRAuth.auth()?.currentUser?.uid
 self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
 // Get user value
 print("got snapshot")
 
 let value = snapshot.value as? NSDictionary
 print(value?["name"] as? String)
 print(value?["password"] as? String)
 print(value?["email"] as? String)
 print(value?["isTutor"] as? Bool)
 if let name = value?["name"] as? String,
 let password = value?["password"] as? String,
 let email = value?["email"] as? String,
 let isTutor = value?["isTutor"] as? Bool{
 
 
 /* if let email = userDefaults.value(forKey: "email"),
 let password = userDefaults.value(forKey: "password"),
 let name = userDefaults.value(forKey: "name"),
 let user = FIRAuth.auth()?.currentUser {*/
 let x = Int(self.view.center.x)
 let y = Int(self.view.center.y)
 let frame = CGRect(x: x, y: y, width: self.cellWidth, height: self.cellHeight)
 
 let activityIndicatorView = NVActivityIndicatorView(frame: frame,
 type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.lineScale.rawValue) )
 let animationTypeLabel = UILabel(frame: frame)
 
 animationTypeLabel.text = "Loading..."
 animationTypeLabel.sizeToFit()
 animationTypeLabel.textColor = UIColor.white
 animationTypeLabel.frame.origin.x += 5
 animationTypeLabel.frame.origin.y += CGFloat(self.cellHeight) - animationTypeLabel.frame.size.height
 
 activityIndicatorView.padding = 20
 self.view.addSubview(activityIndicatorView)
 self.view.addSubview(animationTypeLabel)
 activityIndicatorView.startAnimating()
 
 
 self.ref.child("users").child(userID!).setValue(["zipcode": zipcode,
 "schoolName": schoolName,
 "phone": phone,
 "gender": gender,
 "grade": grade,
 "preferredSubject": preferredSubject,
 "description": description,
 "email": email,
 "password": password,
 "isTutor": isTutor,
 "name": name], withCompletionBlock: { (error, ref) in
 print("before error nil")
 if error == nil {
 print("error=nil")
 let geocoder = CLGeocoder()
 geocoder.geocodeAddressString(zipcode as! String) { placemarks, error in
 if error != nil {
 print(error?.localizedDescription ?? "")
 } else {
 for placemark in placemarks! {
 let location = placemark.location
 let latitude = location?.coordinate.latitude
 let longitude = location?.coordinate.longitude
 self.ref.child("users/\(userID!)/latitude").setValue(latitude)
 self.ref.child("users/\(userID!)/longitude").setValue(longitude)
 }
 }
 }
 activityIndicatorView.stopAnimating()
 self.performSegue(withIdentifier: "toSecondVC", sender: self)
 } else /*if error != nil*/{
 self.displayAlert("Error", message: (error?.localizedDescription)!)
 }
 }) //self.ref.child("users").child(userID!).observeSingleEvent
 } //if let zipcode = self.form.sections[0].rows[0].value,
 //let schoolName = self.form.sections[1].rows[0].value,
 
 
 // ...
 }) { (error) in
 self.displayAlert("Error", message: error.localizedDescription)
 }
 
 
 
 
 
 } else {
 self.displayAlert("Error", message: "Please fill out every section.")
 }
 
 
 }
 section5.rows.append(row)
 
 form.sections = [section1, section15, section2, section3, section4, section5]
 
 self.form = form
 }*/

/*  func createCalendar(destUser: User) -> String {
 
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
 */

/*userRef.child(userID!).observeSingleEvent(of: .value, with: { (snapshot1) in
 
 if snapshot1.hasChild("channels") {
 
 let channelRefHandle = userChannelRef.observe(.childAdded, with: { (snapshot) -> Void in
 //let channelData = snapshot.value as! Dictionary<String, AnyObject>
 if let channelData = snapshot.value as? Dictionary<String, AnyObject> {
 print("  if let channelData = snapshot.value as? Dictionary<String, AnyObject> {")
 let id = snapshot.key
 var ref: FIRDatabaseReference!
 let userID = FIRAuth.auth()?.currentUser?.uid
 ref = FIRDatabase.database().reference()
 ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
 // Get user value
 let userObject = User(snapshot: snapshot )
 
 let value = snapshot.value as? NSDictionary
 let isTutor = userObject.isTutor
 if isTutor != nil {
 if isTutor == true {
 tutorOrTutee = "tuteeName"
 } else {
 tutorOrTutee = "tutorName"
 }
 }
 else {
 // no highscore exists
 }
 })
 
 if let name = channelData[tutorOrTutee] as! String!, name.characters.count > 0 {
 print(" if let name = channelData[tutorOrTutee] as! String!, name.characters.count > 0 {")
 self.channels.append(Channel(id: id, name: name))
 self.tableView.reloadData()
 } else {
 print("Error! Could not decode channel data")
 }
 }
 })
 } else {
 print("false room doesn't exist")
 }
 })
 }*/


/*func createChannelTemp(otherUser: String) {
 
 
 
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
 tuteeName = otherUser
 } else {
 
 }
 } else {
 tutorName = "Chat"
 tuteeName = "Chat"
 }
 
 let newChannelRef = channelRef.childByAutoId()
 let channelItem = [
 "tutorName": tutorName,
 "tuteeName": tuteeName
 ]
 newChannelRef.setValue(channelItem)
 let userID = FIRAuth.auth()?.currentUser?.uid
 let userChannelRef = userRef.child(userID!).child("channels")
 let uuid = UUID().uuidString
 
 userChannelRef.child(uuid).child("tutorName").setValue(tutorName)
 userChannelRef.child(uuid).child("tuteeName").setValue(tuteeName)
 
 }*/

/*func createChannel(otherUser: String) {
 print("in create channel")
 let userDefaults = UserDefaults.standard
 
 let userID = FIRAuth.auth()?.currentUser?.uid
 print(userID)
 var ref: FIRDatabaseReference!
 let user = FIRAuth.auth()?.currentUser
 
 ref = FIRDatabase.database().reference()
 ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
 
 print("in child observesingleevent")
 let userObject = User(snapshot: snapshot )
 print(userObject)
 let value = snapshot.value as? NSDictionary
 let isTutor = userObject.isTutor
 
 if isTutor != nil {
 print("tutor != nil")
 
 if isTutor == true {
 self.tutorName = userID!
 self.tuteeName = otherUser
 } else {
 
 }
 } else {
 self.tutorName = "Chat"
 self.tuteeName = "Chat"
 }
 
 print("Tutor Name: " + self.tutorName)
 print("Tutee Name: " + self.tuteeName)
 
 
 let uuid = UUID().uuidString
 let channelItem = [
 "tutorName": self.tutorName,
 "tuteeName": self.tuteeName
 ]
 
 //self.createChannel = Channel(id: uuid, name: channelItem["tutorName"]!)
 
 let newChannelRef = self.channelRef.childByAutoId()
 
 newChannelRef.setValue(channelItem)
 let userID = FIRAuth.auth()?.currentUser?.uid
 let userChannelRef = self.userRef.child(userID!).child("channels")
 userChannelRef.setValue(self.channelRef)
 /*userChannelRef.child("tutorName").setValue(self.tutorName)
 userChannelRef.child("tuteeName").setValue(tuteeName)*/
 self.performSegue(withIdentifier: "toChatVC", sender: self)
 
 
 
 })
 
 
 }*/

