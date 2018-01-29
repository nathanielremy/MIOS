//
//  User.swift
//  MIOS
//
//  Created by Nathaniel Remy on 29/01/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import Foundation

struct User {
    
    let userId: String
    
    let fullName: String
    let email: String
    let birthdate: Date?
    let isDoctor: Bool
    let miosId: String
    let profileImageURLString: String
    let sex: String
    
    init(userId: String, dictionary: [String : Any]) {
        
        self.userId = userId
        self.fullName = dictionary[Constants.FirebaseDatabase.fullName] as? String ?? "No name"
        self.email = dictionary[Constants.FirebaseDatabase.email] as? String ?? "No email"
        
        let dateString = dictionary[Constants.FirebaseDatabase.birthdate] as? String ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" //Your date format
        let date = dateFormatter.date(from: dateString) //according to date format your date string
        self.birthdate = date
        
        
        let isDoctor = dictionary[Constants.FirebaseDatabase.isDoctor] as? Int ?? 2
        if isDoctor == 1 {
            self.isDoctor = true
        } else if isDoctor == 0 {
            self.isDoctor = false
        } else {
            fatalError()
        }
        
        self.miosId = dictionary[Constants.FirebaseDatabase.miosId] as? String ?? "No miosId"
        self.profileImageURLString = dictionary[Constants.FirebaseDatabase.profileImageURLString] as? String ?? "No URLString"
        self.sex = dictionary[Constants.FirebaseDatabase.sex] as? String ?? "No sex"
    }
}
