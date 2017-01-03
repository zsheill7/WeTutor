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
import SCLAlertView

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
    var userRef: FIRDatabaseReference!
    var senderDisplayName: String?
    var newChannel: Channel?
    var destinationUser: User!
    
    private var channelRefHandle: FIRDatabaseHandle?
    private var channels: [Channel] = []
    var tutorName: String = "Chat"
    var tuteeName: String = "Chat"
    var UID: String = ""
    
    private lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("channels")
    
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
    }

    func displayAlert(title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)
        
    }
    
    class func instantiateFromStoryboard() -> TutorsTableViewController {
        let storyboard = UIStoryboard(name: "MenuViewController", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! TutorsTableViewController
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        observeChannels()
        dbRef = FIRDatabase.database().reference().child("users")
        userRef = FIRDatabase.database().reference().child("users")
        startObservingDB()
       // self.view.addBackground(imageName: "mixed2")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        FriendSystem.system.getCurrentUser { (user) in
            //self.usernameLabel.text = user.email
        }
        FriendSystem.system.addUserObserver { () in
            self.tableView.reloadData()
        }
        
        
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
        //return tutors.count
        return FriendSystem.system.userList.count
    }

    @IBAction func createNewChat(_ sender: Any) {
        createChannel()
       
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    func createChannel() {
        let userDefaults = UserDefaults.standard
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        print(userID)
        var ref: FIRDatabaseReference!
        let user = FIRAuth.auth()?.currentUser
        
        ref = FIRDatabase.database().reference()
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let userObject = User(snapshot: snapshot )
            
            let value = snapshot.value as? NSDictionary
            let isTutor = userObject.isTutor
            
            if isTutor != nil {
                
                    if isTutor == true {
                        self.tutorName = userObject.name
                        self.tuteeName = ""
                    } else {
                        
                    }
            } else {
                self.tutorName = "Chat"
                self.tuteeName = "Chat"
            }
         
            print("Tutor Name: " + self.tutorName)
            print("Tutee Name: " + self.tuteeName)
            
        
                let uuid = UUID().uuidString
            print(uuid)
            print(user?.uid)
                let newChannelRef = self.channelRef.child(uuid)
                let channelItem = [
                    "tutorName": self.tutorName,
                    "tuteeName": self.tuteeName
                ]
            print(channelItem["tutorName"]!)
            print(user!.uid)
                newChannelRef.setValue(channelItem)
                self.newChannel = Channel(id: uuid, name: channelItem["tutorName"]!)
            //let userChannelRef = child(user.uid).setValue(["username": username])
            let userChannelRef = self.userRef.child((user!.uid))
            userChannelRef.child("channels").setValue([uuid: channelItem["tutorName"]!])
                //self.ref.child("users/\(userID)/channels/\(uuid)").setValue(channelItem["tutorName"]!)
                //.setValue(uuid)
                //self.ref.child("users/\(user.uid)/channels")
                self.performSegue(withIdentifier: "toChatVC", sender: self.newChannel)

            

        })
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 161.0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UserCell {
       /* let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserCell
        
        print("in cell for row")
        let tutor = tutors[indexPath.row]
        cell.nameLabel?.text = tutor.name
        cell.schoolLabel?.text = tutor.school
        cell.gradeLabel?.text = "Age:" + String(tutor.age)
        cell.accessoryType = .detailDisclosureButton
        
        // Configure the cell...

        return cell*/
        // Create cell
        var cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell
        if cell == nil {
            tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell
        }
        print(FriendSystem.system.userList[indexPath.row].name)
        // Modify cell
        cell!.nameLabel.text = "Name: \(FriendSystem.system.userList[indexPath.row].name)"
        cell!.schoolLabel.text = "School: \(FriendSystem.system.userList[indexPath.row].school)"
        cell!.gradeLabel.text = "Grade: \(FriendSystem.system.userList[indexPath.row].grade)"
        
        cell!.setAddFriendFunction {
            print(FriendSystem.system.userList[indexPath.row])
            let id = FriendSystem.system.userList[indexPath.row].uid
            print(id)
            FriendSystem.system.sendRequestToUser(id)
            self.displayAlert(title: "Success!", message: "Friend Request Sent")
        }
        cell!.setChatFunction {
            self.createChannel()
        }
        cell!.setInfoFunction {
            let tutor = FriendSystem.system.userList[indexPath.row]
            self.UID = tutor.uid
            self.destinationUser = tutor
            self.performSegue(withIdentifier: "toMoreInfoVC", sender: self)
        }
        
        // Return cell
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        /*let tutor = tutors[indexPath.row]
        UID = tutor.uid
        destinationUser = tutor
        self.performSegue(withIdentifier: "toMoreInfoVC", sender: self)*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        print("in prepare for segue")
       if segue.identifier == "toChatVC" {
        
                print("toChatVC")
                if let channel = sender as? Channel {
                    print("in if let")
                    
                    let chatVc = segue.destination as! ChatViewController
                    
                    chatVc.senderDisplayName = senderDisplayName
                    chatVc.channel = channel
                    chatVc.channelRef = channelRef.child(channel.id)
                }
       } else if segue.identifier == "toMoreInfoVC" {
        print("toMoreInfoVC")
        let moreInfoVC = segue.destination as! MoreInfoViewController
        
        moreInfoVC.UID = UID
        //moreInfoVC.indexPathRow = indexPath.row
        moreInfoVC.destUser = destinationUser
        
    }
        

        
        
        
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }
    
    private func observeChannels() {
        // We can use the observe method to listen for new
        // channels being written to the Firebase DB
        var tutorOrTutee = "tutorName"
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
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
                
                
                if let name = channelData[tutorOrTutee] as! String!, name.characters.count > 0 {
                    self.channels.append(Channel(id: id, name: name))
                    self.tableView.reloadData()
                } else {
                    print("Error! Could not decode channel data")
                }
            })
        })
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
