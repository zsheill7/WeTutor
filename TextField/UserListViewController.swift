/*
 * Copyright (C) 2017, Zoe Sheill.
 * All rights reserved.
 *
 */


import UIKit
import SCLAlertView

class UserListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    func displayAlert(_ title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FriendSystem.system.getCurrentUser { (user) in
            self.usernameLabel.text = user.email
        }
        
        FriendSystem.system.addUserObserver { () in
            self.tableView.reloadData()
        }
    }

    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        FriendSystem.system.logoutAccount()
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let rootVC = appDelegate.window!.rootViewController
        
        if rootVC == self.tabBarController {
            self.present((storyboard?.instantiateInitialViewController())!, animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}

extension UserListViewController: UITableViewDataSource {
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendSystem.system.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // var cell = tableView.dequeueReusableCell(withIdentifier: "UserCell")
 
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell
        if cell == nil {
            tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
 
        }
        
        // Modify cell
        
        
        
       
        print(FriendSystem.system.userList[indexPath.row].name)
        // Modify cell
        cell!.nameLabel.text = "Name: \(FriendSystem.system.userList[indexPath.row].name)"
        cell!.schoolLabel.text = "School: \(FriendSystem.system.userList[indexPath.row].school)"
        cell!.gradeLabel.text = "Grade: \(FriendSystem.system.userList[indexPath.row].grade)"
        
        /*cell!.setAddFriendFunction {
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
        }*/
        
        // Return cell
        return cell!
    }
    
}
