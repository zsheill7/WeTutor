//
//  User.swift
//  TutorMe
//
//  Created by Zoe on 12/22/16.
//  Copyright © 2016 CosmicMind. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

struct User {
    let uid:String
    let email:String
    let name:String
    let isTutor: Bool
    let age: Int
    let description: String
    let phone: String
    let address:String
    let school: String
    
    let languages: [String]
    let availableDays: [Bool]
    let preferredSubjects: [Bool]
    /*
     
     uid
     name
     age
     description
     isTutor
     languages
     address
     availableDays
     school
 
 */
    
    init(userData:FIRUser) {
        uid = userData.uid
        name = ""
        age = 10
        description = userData.description
        isTutor = false
        languages = [""]
        address = ""
        availableDays = [false]
        school = ""
        phone = ""
        preferredSubjects = [false, false, false]
        
        if let mail = userData.providerData.first?.email {
            email = mail
        } else {
            email = ""
        }
    }
    
    init (snapshot:FIRDataSnapshot) {
        
        let snapshotValue = snapshot.value as? NSDictionary
        
        if let userUID = snapshotValue?["uid"] as? String {
            uid = userUID
        } else {
            uid = ""
        }
        
        if let userEmail = snapshotValue?["email"] as? String {
            email = userEmail
        } else {
           email = ""
        }
        
        if let userAddress = snapshotValue?["address"] as? String {
            address = userAddress
        } else {
            address  = ""
        }
        
        if let userName = snapshotValue?["name"] as? String {
            name = userName
        } else {
            name = ""
        }
        
        if let userDescription = snapshotValue?["description"] as? String {
            description = userDescription
        } else {
            description = ""
        }
        
        if let userIsTutor = snapshotValue?["isTutor"] as? Bool {
            isTutor = userIsTutor
        } else {
            isTutor = false
        }
        
        if let userLanguages = snapshotValue?["languages"] as? [String] {
            languages = userLanguages
        } else {
            languages = [""]
        }
        
        if let userAvailableDays = snapshotValue?["availableDays"] as? [Bool] {
            availableDays = userAvailableDays
        } else {
            availableDays = [false]
        }
        
        if let userSchool = snapshotValue?["school"] as? String {
            school = userSchool
        } else {
            school = ""
        }
        if let userAge = snapshotValue?["age"] as? Int {
            age = userAge
        } else {
            age = 0
        }
        if let userPhone = snapshotValue?["phone"] as? String {
            phone = userPhone
        } else {
            phone = ""
        }
        if let userSubject = snapshotValue?["preferredSubject"] as? [Bool] {
            preferredSubjects = userSubject
        } else {
            preferredSubjects = [false, false, false]
        }
        
    }
    
    init (uid: String, email: String, name: String, school: String, isTutor: Bool, address: String, age: Int, description: String, languages: [String], availableDays: [Bool], phone: String, preferredSubjects: [Bool]) {
        self.uid = uid
        self.email = email
        self.address = address
        self.name = name
        self.age = age
        self.description = description
        self.isTutor = isTutor
        self.languages = languages
        self.availableDays = availableDays
        self.school = school
        self.phone = phone
        self.preferredSubjects = preferredSubjects
    }
}
