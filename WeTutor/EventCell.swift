//
//  eventCell.swift
//  Band App Add Event
//
//  Created by Zoe Sheill on 7/12/16.
//  Copyright © 2016 ClassroomM. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    @IBOutlet weak var eventTitle: UILabel!
  
    @IBOutlet weak var eventDate: UILabel!
    
    @IBOutlet weak var eventDescription: UILabel!
    
    @IBOutlet weak var calendarMonthLabel: UILabel!
    
    @IBOutlet weak var calendarDateLabel: UILabel!
    
    @IBOutlet weak var calendarIcon: UIImageView!
    
    override func awakeFromNib() {
        if let calendarImage = UIImage(named: "calendarIcon") {
            calendarIcon.image = calendarImage
        }
    }
}
