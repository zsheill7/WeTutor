/*
 * Copyright (c) 2017 Zoe Sheill
 *
 */

import UIKit

class UserCellTwo: UITableViewCell {
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    //  @IBOutlet weak var chatButton: UIButton!
    
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var gradeLabel: UILabel!
    
    @IBOutlet weak var subjectLabel: UILabel!
    
    
    @IBOutlet weak var infoButton: UIButton!
    
    
    var addFriendFunc: (() -> (Void))!
    var chatFunc: (() -> (Void))!
    var moreInfoFunc: (() -> (Void))!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        infoButton.contentMode = .scaleAspectFit
        addFriendButton.contentMode = .scaleAspectFit
    }
    
    @IBAction func addFriendTapped(_ sender: Any) {
        addFriendFunc()
    }
    
    
    /*   @IBAction func chatTapped(_ sender: Any) {
     chatFunc()
     }*/
    
    @IBAction func moreInfoTapped(_ sender: Any) {
         moreInfoFunc()
    }
   
    func setAddFriendFunction(_ function: @escaping () -> Void) {
        self.addFriendFunc = function
        
    }
    /*  func setChatFunction(_ function: @escaping () -> Void) {
     self.chatFunc = function
     
     }*/
    func setInfoFunction(_ function: @escaping () -> Void) {
        self.moreInfoFunc = function
        
    }
    
    
}
