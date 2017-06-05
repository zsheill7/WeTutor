//
//  ChannelListViewController.swift
//  ChannelListViewController
//
//  Created by Zoe on 3/6/17.
//  Copyright © 2017 TokkiTech. All rights reserved.
//
//
import UIKit
import Firebase
import SCLAlertView
import NVActivityIndicatorView
import PullToRefresh

class ChannelListViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UISearchBarDelegate, NVActivityIndicatorViewable {

    @IBOutlet weak var searchBar: UISearchBar!
     var filteredData: [User]!
    
    let cellId = "ChatUserCell"
  // MARK: Properties
    
  var senderDisplayName: String?
  var newChannelTextField: UITextField?
  var dbRef: FIRDatabaseReference!
    var tutors = [User]()
  fileprivate var channelRefHandle: FIRDatabaseHandle?
  fileprivate var channels: [Channel] = []
    var tutorName: String = ""
    var tuteeName: String = ""
  var tutorOrTutee = "tutorName"
    var currentUserIsTutor = false
    var iterationStatus = ""
    
    var currentUser: User!
  fileprivate lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference().child("channels")
  
    var userRef = FIRDatabase.database().reference().child("users")
    
    
  // MARK: View Lifecycle
    
    func displayAlert(_ title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //super.viewDidAppear(true)
        print("appearFriendSystem.system.friendListOne.count \(FriendSystem.system.friendListOne.count)")
        tableView.reloadData()
    }
   
  // MARK: viewDidLoad
    
  override func viewDidLoad() {
    super.viewDidLoad()
    self.senderDisplayName = "User"
    tableView.emptyDataSetSource = self
    tableView.emptyDataSetDelegate = self
    tableView.tableFooterView = UIView()
   
   // let refreshView = WeTutorRefreshView()
    //let refreshAnimator = RefreshAnimator(refreshView: refreshView)
    let refresher = PullToRefresh()//WeTutorPullToRefresh()
    print("viewdidload")
   // refresher.
   // refresher.color
    tableView.addPullToRefresh(refresher) {
        let when = DispatchTime.now() + 1.2
       // self.tableView.reloadData()
         self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: when) {
           /* FriendSystem.system.addFriendObserver(friendListNumber: 1) {
                print("chaFriendSystem.system.friendListOne  \(FriendSystem.system.friendListOne.count)")
                
                
               
                // self.observeChannels()
            }*/
            self.tableView.endRefreshing(at: .top)
            //self.tableView.removePullToRefresh(self.tableView.topPullToRefresh!)
          
        }
    }
    
   
    
    self.view.addBackground()
    //self.view.addFullScreenBackground("background-green")
   // searchBar.delegate = self
    //self.view.addBackground()
     if let userID = FIRAuth.auth()?.currentUser?.uid {
        userRef.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let userObject = User(snapshot: snapshot )
            print("userRef.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in")
            
           // let value = snapshot.value as? NSDictionary
            let isTutor = userObject.isTutor
            let displayName = userObject.name
            self.senderDisplayName = displayName
            
            print("self.senderDisplayName")
            print(self.senderDisplayName ?? "")
           
            if isTutor == true {
                self.tutorOrTutee = "tuteeName"
                self.currentUserIsTutor = true
            } else {
                self.currentUserIsTutor = false
                self.tutorOrTutee = "tutorName"
            }
            
            
        })
    }
   // title = "RW RIC"
    
    tableView.register(ChatUserCell.self, forCellReuseIdentifier: cellId)
    
    FriendSystem.system.getCurrentUser { (user) in
        //self.usernameLabel.text = user.email
    }
    /*FriendSystem.system.addUserObserver { () in
        self.tableView.reloadData()
    }*/
   // FriendSystem.system.friendListOne.removeAll()
   FriendSystem.system.addFriendObserver(friendListNumber: 1) {
        print("chaFriendSystem.system.friendListOne  \(FriendSystem.system.friendListOne.count)")
        
        
        self.tableView.reloadData()
       // self.observeChannels()
    }
  /*  FriendSystem.system.addFriendObserver {
        print("cha2FriendSystem.system.friendListOne  \(FriendSystem.system.friendListOne.count)")
        
        
        self.tableView.reloadData()friendList
        // self.observeChannels()
    }*/

    
    
    self.tableView.reloadData()
    if FriendSystem.system.friendListOne.count != 0 {
        //self.view.addBackground()
    }
    //filteredData = FriendSystem.system.friendListOne
    
    dbRef = FIRDatabase.database().reference().child("users")
    userRef = FIRDatabase.database().reference().child("users")
    //startObservingDB()
    
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
    

  deinit {
    if let refHandle = channelRefHandle {
      channelRef.removeObserver(withHandle: refHandle)
    }
    tableView.removePullToRefresh(tableView.topPullToRefresh!)
  }
    
  
  // MARK :Actions
  
  @IBAction func createChannel(_ sender: AnyObject) {
    //createChannel()
  }
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
  
    func createChannel(otherUser: String) {
        
        
        
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
                tutorName = otherUser
                tuteeName = userID
            }
        } else {
            tutorName = "Chat"
            tuteeName = "Chat"
        }
        
       
        let channelItem = [
            "tutorName": tutorName,
            "tuteeName": tuteeName
        ]
        
        let userID = FIRAuth.auth()?.currentUser?.uid
        let userChannelRef = userRef.child(userID!).child("channels")
        let uuid = UUID().uuidString
        let newChannelRef = channelRef.child(uuid)
        newChannelRef.setValue(channelItem)
        userChannelRef.child(uuid).child("tutorName").setValue(tutorName)
        userChannelRef.child(uuid).child("tuteeName").setValue(tuteeName)
        
        //channelRef.child(uuid).setValue(
        
    }
    
    /*
    
    fileprivate func fetchMessageWithMessageId(messageId: String, senderId: String) {
        
        let messagesReference = FIRDatabase.database().reference().child("channels").child("messages").child(messageId)
        
        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                    /*let recentMessageReference = FIRDatabase.database().reference().child("users").child(senderId).child("recentMessage")

                    recentMessageReference.child("text").setValue(message.text)
                    recentMessageReference.child("timestamp").setValue(message.timestamp)*/
                }
                
                self.attemptReloadOfTable()
            }
            
        }, withCancel: nil)
    }
    
    fileprivate func attemptReloadOfTable() {
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    var timer: Timer?
    
    func handleReloadTable() {
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            
            return (message1.timestamp?.int32Value)! > (message2.timestamp?.int32Value)!
        })
        
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    


  // MARK: Firebase related methods

    
  fileprivate func observeChannels() {
    // We can use the observe method to listen for new
    // channels being written to the Firebase DB
    
    self.channels.removeAll()
    
    let userID = FIRAuth.auth()?.currentUser?.uid
    let userChannelRef = userRef.child(userID!).child("channels")
    
    print("inside observeChannels)")
    for friend in FriendSystem.system.friendListOne {
        print("for friend in FriendSystem.system.friendListOne")
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
                    self.currentUserIsTutor = true
                    self.tutorOrTutee = "tuteeName"
                } else {
                    self.currentUserIsTutor = false
                    self.tutorOrTutee = "tutorName"
                }
            }
            else {
                // no highscore exists
            }
            let email = userObject.email
            //print(email)
            //print("userObject.channels")
            //print( userObject.channels)
            for channel in userObject.channels {
               
                    self.channels.append(channel)
                    self.tableView.reloadData()
                
            }
        })
    }*/
       
    /* MARK: EmptyDataSet */
  
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "No Contacts to Display"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Swipe right to find tutors and students to connect with"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "placeholder_kickstarter")
    }
    
     // MARK: Navigation
  

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // super.prepare(for: segue, sender: sender)
    
    //if segue.identifier == "toChatVC" {
        if let channel = sender as? Channel {
          let chatVc = segue.destination as! ChatViewController
          
        print("senderdisplayName")
            print(senderDisplayName)
            print("channelRef1")
            print(channelRef.child(channel.id))
          chatVc.senderDisplayName = senderDisplayName!
          chatVc.channel = channel
          chatVc.channelRef = channelRef.child(channel.id)
        }
   // }
  }
  
  // MARK: UITableViewDataSource
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return tutors.count
        print("FriendSystem.system.friendListOne.count \(FriendSystem.system.friendListOne.count)")
    print(FriendSystem.system.friendListOne.count)
        //print(filteredData.count)
        return FriendSystem.system.friendListOne.count
        
    }
  
     
    let cellHeight: CGFloat = 90.0
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ChatUserCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatUserCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        print("cha2FriendSystem.system.friendListOne  \(FriendSystem.system.friendListOne.count)")

        let user = FriendSystem.system.friendListOne[indexPath.row]
        cell.textLabel?.text = user.name
        if user.recentMessageText != nil {
           // cell.detailTextLabel?.text = user.recentMessageText
        }
        
        if let profileImageUrl = user.profileImageUrl {
            if URL(string: user.profileImageUrl!) != nil {
                cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
            } else {
                cell.profileImageView.image = #imageLiteral(resourceName: "Owl Icon")
            }
        } else {
            cell.profileImageView.image = #imageLiteral(resourceName: "Owl Icon")
        }
        
        return cell
        
        
        // Return cell
        //return cell!
    }

  // MARK: UITableViewDelegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    //To see if a user started a chat with someone on their friends list
    let size = CGSize(width: 30, height:30)
    
    //startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 6)!)
    /*perform(#selector(delayedStopActivity),
            with: nil,
            afterDelay: 2.5)*/
    
    let cell = tableView.cellForRow(at: indexPath)
    cell?.isUserInteractionEnabled = false
    if currentUser != nil {
        FIRAnalytics.logEvent(withName: "did_select_chat", parameters: [
            "current_user": currentUser.uid as NSObject,
            "current_user_is_tutor": currentUserIsTutor as NSObject
            ])
    }
    
    let destUser = FriendSystem.system.friendListOne[indexPath.row]
    let destUserID = destUser.uid
    channelRef.observeSingleEvent(of: .value, with: { (snapshot) in
        cell?.isUserInteractionEnabled = true
        print("channelRef.observeSingleEvent(of: .value, with: { (snapshot) in")
        if snapshot.exists() {
            print(" if snapshot.exists() {")
            if let allChannels = snapshot.children.allObjects as? [FIRDataSnapshot] {
                print("typeofall")
                print(type(of: allChannels))
                print("if let allChannels = ((snapshot.value as AnyObject).allKeys)! as? [String] {")
                     self.iterationStatus = "inProcess"
                for channel in allChannels {
                
                    if let channelDict = channel.value as? Dictionary<String, AnyObject> {
                       //This iterates through the channel list and checks if either the tutorName or the tutorName is equal to the current user
                    
                        if self.currentUserIsTutor == false {
                            if let tuteeName = channelDict["tuteeName"] as? String,
                                let  tutorName = channelDict["tutorName"] as? String{
                                if tuteeName == FIRAuth.auth()?.currentUser?.uid {
                                    print("if channel[self.tutorOrTutee] == FIRAuth.auth()?.currentUser?.uid {")
                              
                                    if tutorName == destUserID {
                                        self.iterationStatus = "done"
                                        print("perform segue channel")
                                        print(channel)
                                         let newChannel = Channel(id: channel.key, name: "Chat", tutorName: tutorName, tuteeName: tuteeName)
                                        self.stopAnimating()
                                         self.performSegue(withIdentifier: "toChatVC", sender: newChannel)
                                        
                                        break
                                    }
                                }
                            }
                            
                        } else if self.currentUserIsTutor == true {
                            if let tuteeName = channelDict["tuteeName"] as? String,
                                let  tutorName = channelDict["tutorName"] as? String{
                                if tutorName == FIRAuth.auth()?.currentUser?.uid {
                                    print("if channel[self.tutorOrTutee] == FIRAuth.auth()?.currentUser?.uid {")
                                    if tuteeName == destUserID {
                                        self.iterationStatus = "done"
                                        print("perform segue channel2")
                                        print(channel)
                                        let newChannel = Channel(id: channel.key, name: "Chat", tutorName: tutorName, tuteeName: tuteeName)
                                        self.stopAnimating()
                                        self.performSegue(withIdentifier: "toChatVC", sender: newChannel)
                                        
                                        break
                                    }
                                } //if channelDict["tutorName"]
                            }
                        }
                        
                    }
                } //for channel in allChannels {
            }
            
        } //if snapshot.exists() {
            
        let uuid = UUID().uuidString
        if self.iterationStatus == "inProcess" {
            if self.tutorOrTutee == "tuteeName" {
                let channel = Channel(id: uuid, name: "Chat", tutorName: (FIRAuth.auth()?.currentUser?.uid)!, tuteeName: destUserID)
                print("if tutorOrTutee == tuteeName {")
                print("iterationStatus")
                print(self.iterationStatus)
      
                self.createChannel(otherUser: destUserID)
                print("if self.iterationStatus == inProcess1 {")
                print("perform segue channel3")
                print(channel)
                self.stopAnimating()
                self.performSegue(withIdentifier: "toChatVC", sender: channel)
                
                
            } else if self.tutorOrTutee == "tutorName" {
                let channel = Channel(id: uuid, name: "Chat", tutorName: destUserID, tuteeName: (FIRAuth.auth()?.currentUser?.uid)!)
                print("if tutorOrTutee == tutorName {")

                print("if self.iterationStatus == inProcess2 {")
                self.createChannel(otherUser: destUserID)
                print("perform segue channel4")
                print(channel)
                self.stopAnimating()
                self.performSegue(withIdentifier: "toChatVC", sender: channel)
                
            }
        }
    })
  }
    
   /* func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredData = FriendSystem.system.friendListOne
        } else {
            //If the user has entered text into the search box
            filteredData = FriendSystem.system.friendListOne.filter({(dataItem: String) -> Bool in
                // If dataItem matches the searchText, return true to include it
                if dataItem.range(ofString: searchText, options: .caseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        }
        self.tableView.reloadData()
    }
    */
    class func instantiateFromStoryboard() -> ChannelListViewController {
        let storyboard = UIStoryboard(name: "MenuViewController", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! ChannelListViewController
    }
  
}



