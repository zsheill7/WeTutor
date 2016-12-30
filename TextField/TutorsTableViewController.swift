//
//  TutorsTableViewController.swift
//  TutorMe
//
//  Created by Zoe on 12/22/16.
//  Copyright © 2016 CosmicMind. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation

class TutorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    @IBOutlet weak var contactButton: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


class TutorsTableViewController: UITableViewController {

    var dbRef: FIRDatabaseReference!
    var tutors = [User]()
    var ref: FIRDatabaseReference!
    var senderDisplayName: String?

    
    private var channelRefHandle: FIRDatabaseHandle?
    private var channels: [Channel] = []
    var tutorName: String = ""
    var tuteeName: String = ""

    private lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("channels")
    
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
    }

    
    class func instantiateFromStoryboard() -> TutorsTableViewController {
        let storyboard = UIStoryboard(name: "MenuViewController", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! TutorsTableViewController
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        dbRef = FIRDatabase.database().reference().child("users")
        startObservingDB()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    func startObservingDB () {
        
        dbRef.observe(.value, with: { (snapshot: FIRDataSnapshot) in
            var newUsers = [User]()
            for user in snapshot.children {
                let userObject = User(snapshot: user as! FIRDataSnapshot)
                newUsers.append(userObject)
            }
            self.tutors = newUsers
            self.tableView.reloadData()
        }) { (error: Error) in
            print("inside error")
            print(error)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tutors.count
    }

    @IBAction func createNewChat(_ sender: Any) {
        createChannel()
        
    }
    func createChannel() {
        let userDefaults = UserDefaults.standard
        if let isTutor = userDefaults.value(forKey: "isTutor") as? Bool,
            let userName = userDefaults.value(forKey: "name") as? String {
            if isTutor == true {
                tutorName = userName
                tuteeName = ""
            }
        }
        else {
            tutorName = "Chat"
            tuteeName = "Chat"
        }
        
        let newChannelRef = channelRef.childByAutoId()
        let channelItem = [
            "tutorName": tutorName,
            "tuteeName": tuteeName
        ]
        newChannelRef.setValue(channelItem)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> TutorTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TutorTableViewCell
        
        print("in cell for row")
        let tutor = tutors[indexPath.row]
        cell.nameLabel?.text = tutor.name
        cell.schoolLabel?.text = tutor.school
        cell.gradeLabel?.text = "Age:" + String(tutor.age)
        
        // Configure the cell...

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let channel = sender as? Channel {
            let chatVc = segue.destination as! ChatViewController
            
            chatVc.senderDisplayName = senderDisplayName
            chatVc.channel = channel
            chatVc.channelRef = channelRef.child(channel.id)
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
