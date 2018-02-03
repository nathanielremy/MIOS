//
//  SearchedUser.swift
//  MIOS
//
//  Created by Nathaniel Remy on 03/02/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import Foundation

struct SearchedUser {
    
    let registrationId: String
    let fullName: String
    let userID: String
    
    init(registrationId: String, dictionary: [String : Any]) {
        
        self.registrationId = registrationId
        self.fullName = dictionary[Constants.FirebaseDatabase.fullName] as? String ?? "No fullName"
        self.userID = dictionary[Constants.FirebaseDatabase.userId] as? String ?? "No userID"
    }
}
