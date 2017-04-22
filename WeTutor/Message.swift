//
//  Message.swift
//  gameofchats
//
//  Created by Zoe Sheill on 7/7/16.
//  Copyright © 2016 TokkiTech. All rights reserved.
//

import UIKit
import Firebase
import UIKit

import Firebase

class Message: NSObject {
    
    var senderId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    var photoUrl: String?
    var senderName: String?
   
    
    init(dictionary: [String: Any]) {
        self.senderId = dictionary["senderId"] as? String
        self.text = dictionary["text"] as? String
        self.toId = dictionary["toId"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
        self.photoUrl = dictionary["photoUrl"] as? String
        self.senderName = dictionary["senderName"] as? String
    }
    
    func chatPartnerId() -> String? {
        return senderId == FIRAuth.auth()?.currentUser?.uid ? toId : senderId
    }
    
}







