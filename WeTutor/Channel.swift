 //
 // Copyright (c) 2017 Zoe Sheill
 //
 //
 //  Created by Zoe Sheill on 7/7/16.
 //  Copyright © 2016 TokkiTech. All rights reserved.
 //
//original 173829
internal class Channel {
    internal let id: String
    internal let name: String
    internal let tutorName: String
    internal let tuteeName: String
    internal var calendarId: String
  
    init(id: String, name: String, tutorName: String, tuteeName: String) {
    self.id = id
    self.name = name
    self.tutorName = tutorName
    self.tuteeName = tuteeName
    self.calendarId = ""
    }
    
    func setCalendarId(_ calendarId: String){
        self.calendarId = calendarId
    }
}
