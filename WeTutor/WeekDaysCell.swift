//
//  WeekDaysCell.swift
//  TutorMe
//
//  Created by Zoe on 3/7/17.
//  Copyright © 2017 Zoe Sheill. All rights reserved.
//


import UIKit

class WeekDaysCell: UITableViewCell {
    
   // @IBOutlet var weekDaysView: UIView!
    
    @IBOutlet weak var sundayButton: UIButton!
    @IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var tuesdayButton: UIButton!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var thursdayButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!
    
    var buttons: [UIButton?] {
        return [self.sundayButton, self.mondayButton, self.tuesdayButton, self.wednesdayButton, self.thursdayButton, self.fridayButton, self.saturdayButton]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        /*Bundle.main.loadNibNamed("WeekDaysCell", owner: self, options: nil)?[0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds*/
    }
}
