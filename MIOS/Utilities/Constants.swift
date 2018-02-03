//
//  Constants.swift
//  MIOS
//
//  Created by Nathaniel Remy on 29/01/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import Foundation

class Constants {
    
    struct FirebaseStorage {
        static let profileImages = "profile_images"
    }
    
    struct FirebaseDatabase {
        static let usersRef = "users"
        static let doctorRegistrationIdRef = "doctorRegistrationIds"
        static let patientRegistrationIdRef = "patientRegistrationIds"
        static let orginisationRef = "orginisation"
        static let doctorRegistrationLimit = "doctorRegistrationLimit"
        static let signedUpDoctors = "signedUpDoctors"
        static let allMIOSIds = "allMIOSIds"
        
        static let userId = "userId"
        static let fullName = "fullName"
        static let email = "email"
        static let birthdate = "birthdate"
        static let sex = "sex"
        static let profileImageURLString = "profileImageURLString"
        static let registrationID = "registrationID"
        static let isDoctor = "isDoctor"
        static let miosId = "miosId"
    }
    
    struct CollectionViewCellIds {
        static let userProfileHeaderCell = "userProfileHeaderCell"
        static let userTabCell = "userTabCell"
        static let searchedUserCell = "searchedUserCell"
    }
    
    struct PatientTabCellTitles {
        static let generalInfo = "General Information"
        static let patientNotes = "Notes"
        static let scanResults = "Scan Results"
        static let prescriptions = "Prescriptions"
        static let recentInjuries = "Recent Injuries"
        static let conditions = "Conditions"
        static let testResults = "Test Results"
        static let visitSummaries = "Visit Summaries"
        static let affiliatedDoctors = "Affiliated Doctors"
    }
}
