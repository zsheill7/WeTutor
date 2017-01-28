//
//  StringExtensions.swift
//  TutorMe
//
//  Created by Zoe on 12/24/16.
//  Copyright © 2017 Zoe Sheill. All rights reserved.
//

import Foundation

extension String {
    func isEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
}
