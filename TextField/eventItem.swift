//
//  eventItem.swift
//  Band App Add Event
//
//  Created by Zoe Sheill on 7/11/16.
//  Copyright © 2016 ClassroomM. All rights reserved.
//

import UIKit

struct eventItem {
    var title: String
    var date: NSDate
    var description: String
    var instrument: String
    var ensemble: String //1 == Marching Band, 2 == Concert Band
    var willRepeat: Bool
    var UUID: String
    var objectID: String
    
    let labelFont = UIFont(name: "HelveticaNeue-Bold", size: 18)
    //let attributes :Dictionary = [NSFontAttributeName : labelFont]
    let formatter = DateFormatter()
    
    
    
    init(title: String, date: NSDate, description: String, instrument: String, ensemble: String, willRepeat: Bool, UUID: String, objectID: String) {
        self.date = date
        self.title = title
        self.description = description
        self.instrument = instrument
        self.ensemble = ensemble
        self.willRepeat = willRepeat
        self.UUID = UUID
        self.objectID = objectID
        
        
       // formatter.dateStyle = DateFormatter.Style.LongStyle
       // formatter.timeStyle = DateFormatter.Style.ShortStyle
    }
    
    var isOverdue: Bool {
        return (NSDate().compare(self.date as Date) == ComparisonResult.orderedDescending)
    }
    
    func toString() -> String {
        let dateString = formatter.string(from: date as Date)
        let eventString: String = title + "\n" + dateString + "\n" + description + "\n" + instrument
        return eventString
    }
    
    func getDateString() -> String {
        let dateString = formatter.string(from: date as Date)
        return dateString
    }
}
