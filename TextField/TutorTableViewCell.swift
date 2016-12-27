//
//  TutorTableViewCell.swift
//  TutorMe
//
//  Created by Zoe on 12/22/16.
//  Copyright © 2016 CosmicMind. All rights reserved.
//

import UIKit

class TutorTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
