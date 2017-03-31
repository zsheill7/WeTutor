/*
 * Copyright (c) 2017 Zoe Sheill
 *
 */

import UIKit
import Cosmos

var colorsCount = 0

class UserCellThree: UITableViewCell {
    
    
    
    
    
    /*@IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var schoolLabel: UILabel!
    
    @IBOutlet weak var gradeLabel: UILabel!
    
    @IBOutlet weak var subjectLabel: UILabel!
    //  @IBOutlet weak var chatButton: UIButton!
    
    @IBOutlet weak var hourlyPrice: UILabel!
    

    //@IBOutlet weak var addFriendButton: UIButton!
 
    
    
    @IBOutlet weak var userRating: CosmosView!
    
    @IBOutlet weak var gpaLabel: UILabel!
    
    @IBOutlet weak var infoButton: UIButton!
    */
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var addFriendButton: UIButton!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var schoolLabel: UILabel!
    
    @IBOutlet weak var hourlyPriceLabel: UILabel!
    
    @IBOutlet weak var gpaLabel: UILabel!
    
    @IBOutlet weak var subjectLabel: UILabel!
    
    @IBOutlet weak var ratingView: CosmosView!
    
    
    @IBOutlet weak var gradeLabel: UILabel!

    /*@IBOutlet weak var subjectLabel: UILabel!
    
    @IBOutlet weak var infoButton: UIButton!

    @IBOutlet weak var addFriendButton2: UIButton!*/
    
    var bounds = UIScreen.main.bounds
    var width = bounds.size.width
    var height = bounds.size.height
    
    override func awakeFromNib() {
        var cellHeight = 135
        
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: Int(self.frame.size.width - 40), height: cellHeight))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 1.0])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 3.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        let leftColorView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: cellHeight))
        //leftColorView.backgroundColor = colors[indexPath.row % 6]
        
        
        leftColorView.layer.masksToBounds = true
        leftColorView.backgroundColor = colors[colorsCount % 5]
        
        colorsCount += 1
        
        leftColorView.roundCorners(corners: [.topLeft, .bottomLeft], radius: 3)
        whiteRoundedView.addSubview(leftColorView)
        self.contentView.addSubview(whiteRoundedView)
        self.contentView.sendSubview(toBack: whiteRoundedView)

    }
    
    
   // @IBOutlet weak var profileImageView: UIImageView!
    
    var addFriendFunc: (() -> (Void))!
    var chatFunc: (() -> (Void))!
    var moreInfoFunc: (() -> (Void))!
    
    /*required init?(coder aDecoder: NSCoder) {
     super.init(coder: aDecoder)
     infoButton.contentMode = .scaleAspectFit
     addFriendButton.contentMode = .scaleAspectFit
     }*/
   
    
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
