//
//  eventItem.swift
// 
//
//  Created by Zoe Sheill on 7/11/16.
//  Copyright © 2016 TokkiTech. All rights reserved.
//

import UIKit
import CoreLocation

enum EventAlert : String, CustomStringConvertible {
    case Never = "None"
    case At_time_of_event = "At time of event"
    case Five_Minutes = "5 minutes before"
    case FifTeen_Minutes = "15 minutes before"
    case Half_Hour = "30 minutes before"
    case One_Hour = "1 hour before"
    case Two_Hour = "2 hours before"
    case One_Day = "1 day before"
    case Two_Days = "2 days before"
    
    var description : String { return rawValue }
    
    static let allValues = [Never, At_time_of_event, Five_Minutes, FifTeen_Minutes, Half_Hour, One_Hour, Two_Hour, One_Day, Two_Days]
}


struct Event {
    var title: String
    var startDate: NSDate
    var endDate: NSDate
    var description: String
    
    var location: String//CLLocation
    var repeatInterval: String
    var uid: String
    var objectID: String
    var eventAlert: String//EventAlert
    
    let labelFont = UIFont(name: "HelveticaNeue-Bold", size: 18)
    let formatter = DateFormatter()
    
    
    
    init(title: String,  startDate: NSDate, endDate: NSDate, description: String, location: String/*CLLocation*/, repeatInterval: String, uid: String, objectID: String, eventAlert:String) {
        self.startDate = startDate
        self.endDate = endDate
        self.title = title
        self.description = description
        self.location = location
        
        self.repeatInterval = repeatInterval
        self.uid = uid
        self.objectID = objectID
        self.eventAlert = eventAlert
    }
    
    var isOverdue: Bool {
        return (NSDate().compare(self.startDate as Date) == ComparisonResult.orderedDescending)
    }
    
    func toString() -> String {
        let dateString = formatter.string(from: startDate as Date)
        let eventString: String = title + "\n" + dateString + "\n" + description
        return eventString
    }
    
    func getDateString() -> String {
        let dateString = formatter.string(from: startDate as Date)
        return dateString
    }
}
