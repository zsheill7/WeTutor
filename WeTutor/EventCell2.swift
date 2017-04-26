//
//  EventCell.swift
//  WeTutor
//
//  Created by Zoe on 4/25/17.
//  Copyright © 2017 CosmicMind. All rights reserved.
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
        print("awake from nib")
        var screenBounds = UIScreen.main.bounds
        let cornerRadius: CGFloat = 5
        let width = screenBounds.width
        let cellHeight = 125
        self.contentView.backgroundColor = UIColor.clear
        if let calendarImage = UIImage(named: "calendarIcon") {
            calendarIcon.image = calendarImage
        }
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: /*Int(self.frame.size.width - 40)*/Int(width - 20), height: cellHeight - 20))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 1.0])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = cornerRadius
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        //let leftColorView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: cellHeight))
        //leftColorView.backgroundColor = colors[indexPath.row % 6]
        
        // self.isUserInteractionEnabled = true
        
        
        
        self.contentView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.contentView.alpha = 1
        }
        self.addSubview(whiteRoundedView)
        self.sendSubview(toBack: whiteRoundedView)
        
    }
}
