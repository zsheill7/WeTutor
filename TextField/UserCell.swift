//
//  UserCell.swift
//  FirebaseFriendRequest
//
//  Created by Kiran Kunigiri on 7/11/16.
//  Copyright © 2016 Kiran. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
  
    @IBOutlet weak var schoolLabel: UILabel!
    
    @IBOutlet weak var gradeLabel: UILabel!

    @IBOutlet weak var addFriendLabel: UIButton!
    
    @IBOutlet weak var chatLabel: UIButton!
   
    var addFriendFunc: (() -> (Void))!
    var chatFunc: (() -> (Void))!
    @IBAction func addFriendTapped(_ sender: Any) {
        addFriendFunc()
    }
    @IBAction func chatTapped(_ sender: Any) {
        chatFunc()
    }
    
    func setAddFriendFunction(_ function: @escaping () -> Void) {
        self.addFriendFunc = function
        
    }
    func setChatFunction(_ function: @escaping () -> Void) {
        self.chatFunc = function
        
    }
    
}
