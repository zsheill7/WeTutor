//
 // Copyright (C) 2017, Zoe Sheill.
 // All rights reserved.
 //
 //  Created by Zoe on 3/6/17.
 //  Copyright © 2017 TokkiTech. All rights reserved.
 //



import UIKit
import SCLAlertView

class RequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    func displayAlert(_ title: String, message: String) {
        SCLAlertView().showInfo(title, subTitle: message)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        print(FriendSystem.system.requestList)

        FriendSystem.system.addRequestObserver {
            print(FriendSystem.system.requestList)
            self.tableView.reloadData()
        }
    }

    class func instantiateFromStoryboard() -> RequestViewController {
        let storyboard = UIStoryboard(name: "MenuViewController", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! RequestViewController
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendSystem.system.requestList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 161.0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create cell
        /*var cell = tableView.dequeueReusableCell(withIdentifier: "UserCell")
         if cell == nil {
         tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
         cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell
         }
         
         // Modify cell
         cell!.button.setTitle("Accept", for: UIControlState())
         cell!.emailLabel.text = FriendSystem.system.requestList[indexPath.row].email
         
         cell!.setFunction {
         let id = FriendSystem.system.requestList[indexPath.row].id
         FriendSystem.system.acceptFriendRequest(id!)
         }
         
         // Return cell
         return cell!*/
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
        //cell!.chatButton.removeFromSuperview()
        cell!.setAddFriendFunction {
            let id = FriendSystem.system.requestList[indexPath.row].uid
            FriendSystem.system.acceptFriendRequest(id)
            self.displayAlert("Success!", message: "Friend Request Accepted")
        }
        /*cell!.setChatFunction {
         self.createChannel()
         }*/
        
        // Return cell
        return cell!
        
    }
    
    /* MARK: EmptyDataSet */
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "No Contacts to Display"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "When someone sends you a contact request, it will appear here."
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage(named: "placeholder_kickstarter")
}

}

