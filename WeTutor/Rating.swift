//
//  Rating.swift
//  WeTutor
//
//  Created by Zoe on 4/14/17.
//  Copyright © 2017 TokkiTech. All rights reserved.
//

import UIKit

struct Rating {
    var rating: Double
    var comment: String 

    init(rating: Double,  comment: String) {
        self.rating = rating
        self.comment = comment
    }
    
}
