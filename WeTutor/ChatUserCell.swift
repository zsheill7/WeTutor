//
//  ChatUserCell.swift
//  WeTutor
//
//  Created by Zoe on 3/31/17.
//  Copyright © 2017 Zoe Sheill. All rights reserved.
//

import UIKit
import Firebase

class ChatUserCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 78, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 78, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var screenBounds = UIScreen.main.bounds
    
    
    
    
    
   
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        
        let width = screenBounds.size.width
        let height = screenBounds.size.height
        let cellHeight = self.height
        let cornerRadius:CGFloat = 5
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 21).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: /*Int(self.frame.size.width - 40)*/Int(width - 20), height: Int(80.0)))
        
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 1.0])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = cornerRadius
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        self.contentView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.contentView.alpha = 1
        }
        self.contentView.addSubview(whiteRoundedView)
        self.contentView.sendSubview(toBack: whiteRoundedView)
        
        /*let whiteRoundedView : UIView = UIView(frame: CGRect(x: -2, y: 8, width: /*Int(self.frame.size.width - 40)*/Int(width + 20), height: 90))
         
         whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 1.0])
         whiteRoundedView.layer.masksToBounds = false
         whiteRoundedView.layer.cornerRadius = cornerRadius
         whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
         whiteRoundedView.layer.shadowOpacity = 0.2*/
        
        /* let leftColorView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: cellHeight))
         //leftColorView.backgroundColor = colors[indexPath.row % 6]
         
         
         
         leftColorView.layer.masksToBounds = true
         leftColorView.backgroundColor = colors[colorsCount % 5]
         
         colorsCount += 1
         
         leftColorView.roundCorners(corners: [.topLeft, .bottomLeft], radius: cornerRadius)*/
        // whiteRoundedView.addSubview(leftColorView)
        self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        self.contentView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.contentView.alpha = 1
        }
        //self.contentView.addSubview(whiteRoundedView)
        //self.contentView.sendSubview(toBack: whiteRoundedView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
