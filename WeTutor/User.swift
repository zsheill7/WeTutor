//
//  User.swift
//  TutorMe
//
//  Created by Zoe on 12/22/16.
//  Copyright © 2017 Zoe Sheill. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

struct User {
    let uid:String
    let email:String
    let name:String
    let isTutor: Bool
    let gender: String
    
    let description: String
    let phone: String
    let address:String
    let school: String
    
    var languages: [String]
    let availableDaysStringArray: [String]
    let availableDaysArray: [Bool]
    let preferredSubjects: [String]
    
    
    let availabilityInfo: String
    let grade: String
    
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocation
    var distanceFromUser: Double
    
    var channels: [Channel]
    let weekDayString: String
    let friends: [String: Bool]
    var profileImageUrl: String?
    
    var rating: Double //user rating from 1 to 5
    var gpa: Double //from 0.0 to 4.0
    var hourlyPrice: Double
    
    var completedTutorial: Bool
    
    var recentMessageText: String
    var recentMessageTimestamp: Date
    var ratings: [String: [String: Any]]
    var averageRating: Double?
    
    var numberOfRatings: Int
    /*
     
     uid
     name
     grade
     description
     isTutor
     languages
     address
     availableDays
     school
 
     var languages: [String]
     let availableDaysStringArray: [String]
     let availableDaysArray: [Bool]
     let preferredSubjects: [String]
     
     let availabilityInfo: String
     let grade: String
     
     let latitude: Double
     let longitude: Double
     var coordinate: CLLocation
     var distanceFromUser: Double
     
     var channels: [Channel]
     let weekDayString: String
     let friends: [String: Bool]
     var profileImageUrl: String?
     
     var rating: Double //user rating from 1 to 5
     var gpa: Double //from 0.0 to 4.0
     var hourlyPrice: Double

 */
    
   /* init(userData:FIRUser) {
        uid = userData.uid
        name = ""
    
        description = userData.description
        isTutor = false
        languages = [""]
        address = ""
        availableDays = [String]()
        school = ""
        phone = ""
        preferredSubjects = [String]()
        availabilityInfo = ""
        grade = ""
        latitude = 0
        longitude = 0
        channels = [Channel]()
        weekDayString = ""
        if let mail = userData.providerData.first?.email {
            email = mail
        } else {
            email = ""
        }
        friends =  [String: Bool]()
        coordinate
    }*/
    
    init (snapshot:FIRDataSnapshot) {
        
        let snapshotValue = snapshot.value as? NSDictionary
        let channelSnapshot = snapshot.childSnapshot(forPath: "channels")
       // let channelValue = channelChild.value as? NSDictionary
        
        channels = [Channel]()
       
        for channel in channelSnapshot.children.allObjects as! [FIRDataSnapshot] {
            let channelValue = channel.value as? NSDictionary
            let id = channel.key
            let name = "Chat"
            if let tutorName = channelValue?["tutorName"] as? String,
                let tuteeName = channelValue?["tuteeName"] as? String {
            
                let tempChannel = Channel(id: id, name: name, tutorName: tutorName, tuteeName: tuteeName)
                channels.append(tempChannel)
            }
        }
       
        
        if let userUID = snapshot.key as? String {
            uid = userUID
        } else {
            uid = ""
        }
        
        if let userEmail = snapshotValue?["email"] as? String {
            email = userEmail
        } else {
           email = ""
        }
        
        if let userAddress = snapshotValue?["zipcode"] as? String {
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
        
        if let userLanguages = snapshotValue?["languages"] as? [String:String] {
            languages = [""]
            print("userLanguages")
            print(userLanguages)
            for value in userLanguages.values {
                print(value)
                languages.append(value)
            }
        } else {
            languages = [""]
        }
        
        if let availableDaysArray = snapshotValue?["availableDaysArray"] as? [Bool] {
            self.availableDaysArray = availableDaysArray
        } else {
            availableDaysArray = [Bool]()
        }
        
        if let availableDaysStringArray = snapshotValue?["availableDays"] as? [String] {
            self.availableDaysStringArray = availableDaysStringArray
        } else {
            availableDaysStringArray = [String]()
        }
        
        if let userSchool = snapshotValue?["schoolName"] as? String {
            school = userSchool
        } else {
            school = ""
        }
        if let userGrade = snapshotValue?["grade"] as? String {
            grade = userGrade
        } else {
            grade = ""
        }
        if let userPhone = snapshotValue?["phone"] as? String {
            phone = userPhone
        } else {
            phone = ""
        }
        if let userSubject = snapshotValue?["preferredSubject"] as? [String] {
            preferredSubjects = userSubject
        } else {
            preferredSubjects = ["None"]
        }
        
        if let userAvailability = snapshotValue?["availabilityInfo"] as? String {
            availabilityInfo = userAvailability
        } else {
            availabilityInfo = ""
        }
        
        
        if let userLatitude = snapshotValue?["latitude"] as? Double {
            latitude = userLatitude
        } else {
            latitude = 0
        }
        if let userLongitude = snapshotValue?["longitude"] as? Double {
            longitude = userLongitude
        } else {
            longitude = 0
        }
        /*if let userChannels = snapshotValue?["channels"] as? [String: [String: String]] {
            channels = userChannels
        } else {
            channels = [String: [String: String]]()
        }*/
        if let userWeekDayString = snapshotValue?["weekDayString"] as? String {
            weekDayString = userWeekDayString
        } else {
            weekDayString = ""
        }
        if let userFriends = snapshotValue?["friends"] as? [String:Bool] {
            friends = userFriends
        } else {
            friends = [String:Bool]()
        }
        
        if let profileImage = snapshotValue?["profileImageURL"] as? String {
            self.profileImageUrl = profileImage
        } else {
            self.profileImageUrl = ""
        }
       
        if let rating = snapshotValue?["rating"] as? Double {
            self.rating = rating
        } else {
            self.rating = 0.0
        }
        if let gpa = snapshotValue?["gpa"] as? Double {
            self.gpa = gpa
        } else {
            self.gpa = 0.0
        }
        if let hourlyPrice = snapshotValue?["hourlyPrice"] as? Double {
            self.hourlyPrice = hourlyPrice
        } else {
            self.hourlyPrice = 0.0
        }
        
        if let gender = snapshotValue?["gender"] as? String {
            self.gender = gender
        } else {
            self.gender = "Male"
        }
        
        if let completedTutorial = snapshotValue?["completedTutorial"] as? Bool {
            self.completedTutorial = completedTutorial
        } else {
            self.completedTutorial = Bool()
        }
        
        if let recentMessageText = snapshotValue?["recentMessageText"] as? String {
            self.recentMessageText = recentMessageText
        } else {
            self.recentMessageText = ""
        }
        
        if let recentMessageTimestamp = snapshotValue?["recentMessageTimestamp"] as? Double {
            self.recentMessageTimestamp = Date(timeIntervalSince1970: recentMessageTimestamp)
        } else {
            self.recentMessageTimestamp = Date()
        }
        
        /*if let  = snapshotValue?[""] as? String {
         
        } else {
         
        }*/
        
        if let ratings = snapshotValue?["ratings"] as? [String: [String: Any]] {
            self.ratings = ratings/*[Rating(ratings: ratings)]*/
            print("self.ratings \(self.ratings)")
        } else {
            self.ratings = [String: [String: Any]]()
        }
        
        var numberRatingArray: [Double] = [Double]()
        
        for rating in self.ratings {
            if let ratingNumber = rating.value["ratingNumber"] as? Double {
                numberRatingArray.append(ratingNumber)
            }
        }
        
        self.numberOfRatings = ratings.count
        coordinate = CLLocation()
        distanceFromUser = Double()
        
        self.averageRating = self.averageOf(numbers: numberRatingArray)
        print("self.averageRating \(self.averageRating)")
        
        
    }
    
    func averageOf(numbers: [Double]) -> Double {
        var sum = 0.0
        var countOfNumbers = 0
        for number in numbers {
            sum += number
            countOfNumbers += 1
        }
        if countOfNumbers == 0 {
            return 0
        }
    
        var result: Double = Double(sum) / Double(countOfNumbers)
        return result
    }

    
    /*init (uid: String, email: String, name: String, school: String, isTutor: Bool, address: String, description: String, languages: [String], availableDaysArray: [Bool], phone: String, preferredSubjects: [String], channels: [Channel], availabilityInfo: String, latitude: Double, longitude: Double, grade: String, weekDayString: String, friends: [String: Bool], coordinate: CLLocation, distanceFromUser: Double) {
        self.uid = uid
        self.email = email
        self.address = address
        self.name = name
        self.grade = grade
        self.description = description
        self.isTutor = isTutor
        self.languages = languages
        self.availableDaysArray =  availableDaysArray
        self.school = school
        self.phone = phone
        self.preferredSubjects = preferredSubjects
        self.channels = channels
        self.availabilityInfo = availabilityInfo
        self.latitude = latitude
        self.longitude = longitude
        self.weekDayString = weekDayString
        //self.grade = grade
        self.friends = friends
        self.coordinate = coordinate
        self.distanceFromUser = distanceFromUser
    }*/
}
