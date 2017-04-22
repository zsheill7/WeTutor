//
//  eventCell.swift
//  Add Event
//
//  Created by Zoe Sheill on 7/12/16.
//  Copyright © 2016 TokkiTech. All rights reserved.
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
        var screenBounds = UIScreen.main.bounds
        
        let width = screenBounds.size.width
        let cellHeight = 105
        let cornerRadius:CGFloat = 5
        //self.contentView.backgroundColor = UIColor.red
        if let calendarImage = UIImage(named: "calendarIcon") {
            calendarIcon.image = calendarImage
        }
         let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: /*Int(self.frame.size.width - 40)*/Int(width - 20), height: cellHeight))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 1.0])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = cornerRadius
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        //let leftColorView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: cellHeight))
        //leftColorView.backgroundColor = colors[indexPath.row % 6]
        
       // self.isUserInteractionEnabled = true
        
        
        
        self.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.contentView.alpha = 1
        }
        self.addSubview(whiteRoundedView)
        self.sendSubview(toBack: whiteRoundedView)
    }
}
