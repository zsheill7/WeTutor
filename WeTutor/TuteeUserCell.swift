//
//  TuteeUserCell.swift
//  WeTutor
//
//  Created by Zoe on 4/18/17.
//  Copyright © 2017 TokkiTech. All rights reserved.
//



import UIKit
import Cosmos


class TuteeUserCell: UITableViewCell {
    
    
    
    
    @IBOutlet var ratingView: CosmosView!
    
   
    @IBOutlet weak var friendIndicatorView: UIImageView!
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var addFriendButton: UIButton!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var schoolLabel: UILabel!
    
  //  @IBOutlet weak var hourlyPriceLabel: UITextField!
    
 //   @IBOutlet weak var gpaLabel: UILabel!
    
    @IBOutlet weak var subjectLabel: UILabel!
    
  //  @IBOutlet weak var ratingView: CosmosView!
    
 //   @IBOutlet var numberOfRatingsLabel: UILabel!
    
    @IBOutlet weak var gradeLabel: UILabel!
    
    /*@IBOutlet weak var subjectLabel: UILabel!
     
     @IBOutlet weak var infoButton: UIButton!
     
     @IBOutlet weak var addFriendButton2: UIButton!*/
    
    var screenBounds = UIScreen.main.bounds
    
    
    override func awakeFromNib() {
        let width = screenBounds.size.width
        let height = screenBounds.size.height
        let cellHeight = 135
        let cornerRadius:CGFloat = 5
        infoButton.imageView?.contentMode = .scaleAspectFit
        addFriendButton.imageView?.contentMode = .scaleAspectFit
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: /*Int(self.frame.size.width - 40)*/Int(width - 20), height: cellHeight))

        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 1.0])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = cornerRadius
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        let leftColorView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: cellHeight))
        //leftColorView.backgroundColor = colors[indexPath.row % 6]
        
        self.isUserInteractionEnabled = true
        
        
        leftColorView.layer.masksToBounds = true
        leftColorView.backgroundColor = colors[colorsCount % 5]
        
        colorsCount += 1
        
        leftColorView.roundCorners(corners: [.topLeft, .bottomLeft], radius: cornerRadius)
        whiteRoundedView.addSubview(leftColorView)
        
        self.contentView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.contentView.alpha = 1
        }
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

