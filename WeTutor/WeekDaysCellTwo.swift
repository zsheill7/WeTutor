//
//  WeekDaysCellTwo.swift
//  TutorMe
//
//  Created by Zoe on 3/8/17.
//  Copyright © 2017 TokkiTech. All rights reserved.
//

/*import Eureka
import UIKit

open class WeekDayCell : Cell<Set<WeekDay>>, CellType {
    
    @IBOutlet var sundayButton: UIButton!
    @IBOutlet var mondayButton: UIButton!
    @IBOutlet var tuesdayButton: UIButton!
    @IBOutlet var wednesdayButton: UIButton!
    @IBOutlet var thursdayButton: UIButton!
    @IBOutlet var fridayButton: UIButton!
    @IBOutlet var saturdayButton: UIButton!
    //higg
    
    
    open override func setup() {
        height = { 60 }
        row.title = nil
        super.setup()
        selectionStyle = .none
        for subview in contentView.subviews {
            if let button = subview as? UIButton {
                button.setImage(UIImage(named: "checkedDay"), for: .selected)
                button.setImage(UIImage(named: "uncheckedDay"), for: .normal)
                button.adjustsImageWhenHighlighted = false
                imageTopTitleBottom(button)
            }
        }
    }
    
    open override func update() {
        row.title = nil
        super.update()
        let value = row.value
        mondayButton.isSelected = value?.contains(.monday) ?? false
        tuesdayButton.isSelected = value?.contains(.tuesday) ?? false
        wednesdayButton.isSelected = value?.contains(.wednesday) ?? false
        thursdayButton.isSelected = value?.contains(.thursday) ?? false
        fridayButton.isSelected = value?.contains(.friday) ?? false
        saturdayButton.isSelected = value?.contains(.saturday) ?? false
        sundayButton.isSelected = value?.contains(.sunday) ?? false
        
        mondayButton.alpha = row.isDisabled ? 0.6 : 1.0
        tuesdayButton.alpha = mondayButton.alpha
        wednesdayButton.alpha = mondayButton.alpha
        thursdayButton.alpha = mondayButton.alpha
        fridayButton.alpha = mondayButton.alpha
        saturdayButton.alpha = mondayButton.alpha
        sundayButton.alpha = mondayButton.alpha
    }
    
    @IBAction func dayTapped(_ sender: UIButton) {
        dayTapped(sender, day: getDayFromButton(sender))
    }
    
    fileprivate func getDayFromButton(_ button: UIButton) -> WeekDay{
        switch button{
        case sundayButton:
            return .sunday
        case mondayButton:
            return .monday
        case tuesdayButton:
            return .tuesday
        case wednesdayButton:
            return .wednesday
        case thursdayButton:
            return .thursday
        case fridayButton:
            return .friday
        default:
            return .saturday
        }
    }
    
    func getStringFromArray(_ array: Set<WeekDay>) -> String {
        var weekDayString = ""
        for weekDay in array {
            switch weekDay{
            case .sunday:
                weekDayString.append("Sunday, ")
            case .monday:
                weekDayString.append("Monday, ")
            case .tuesday:
                weekDayString.append("Tuesday, ")
            case .wednesday:
                weekDayString.append("Wednesday, ")
            case .thursday:
                weekDayString.append("Thursday, ")
            case .friday:
                weekDayString.append("Friday, ")
            default:
                weekDayString.append("Saturday, ")
            }
            
        }
        weekDayString = weekDayString.substring(to: weekDayString.index(before: weekDayString.endIndex))
        
        return weekDayString
    }
    
    func getBoolArrayFromArray(_ array: Set<WeekDay>) -> [Bool] {
        var weekDayArray: [Bool] = [false,false,false,false,false,false,false]
        for weekDay in array {
            switch weekDay{
            case .sunday:
                weekDayArray[0] = true
            case .monday:
                weekDayArray[1] = true
            case .tuesday:
                weekDayArray[2] = true
            case .wednesday:
                weekDayArray[3] = true
            case .thursday:
                weekDayArray[4] = true
            case .friday:
                weekDayArray[5] = true
            default:
                weekDayArray[6] = true
            }
            
        }
        //weekDayString = weekDayString.substring(to: weekDayString.index(before: weekDayString.endIndex))
        
        return weekDayArray
    }
    
    
    
    fileprivate func dayTapped(_ button: UIButton, day: WeekDay){
        button.isSelected = !button.isSelected
        if button.isSelected{
            row.value?.insert(day)
        }
        else{
            _ = row.value?.remove(day)
        }
    }
    
    fileprivate func imageTopTitleBottom(_ button : UIButton){
        
        guard let imageSize = button.imageView?.image?.size else { return }
        let spacing : CGFloat = 3.0
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0)
        guard let titleLabel = button.titleLabel, let title = titleLabel.text else { return }
        let titleSize = title.size(attributes: [NSFontAttributeName: titleLabel.font])
        button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0, 0, -titleSize.width)
    }
}

//MARK: WeekDayRow

/*public final class WeekDayRow: Row<WeekDayCell>, RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<WeekDayCell>(nibName: "WeekDaysCell")
    }
}
*/*/
