//
//  UserProfileVC.swift
//  MIOS
//
//  Created by Nathaniel Remy on 29/01/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class UserProfileVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: Stored properties
    var userId: String?
    var user: User?
    
    let doctorTabCellTitles = [Constants.DoctorTabCellTitles.importantPatients, Constants.DoctorTabCellTitles.allPatients, Constants.DoctorTabCellTitles.notes]
    
    let patientTabCellTitles = [Constants.PatientTabCellTitles.generalInfo, Constants.PatientTabCellTitles.patientNotes, Constants.PatientTabCellTitles.scanResults, Constants.PatientTabCellTitles.prescriptions, Constants.PatientTabCellTitles.recentInjuries, Constants.PatientTabCellTitles.conditions, Constants.PatientTabCellTitles.testResults, Constants.PatientTabCellTitles.visitSummaries, Constants.PatientTabCellTitles.affiliatedDoctors]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        
        // Register the collectionView cells
        collectionView?.register(UserProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Constants.CollectionViewCellIds.userProfileHeaderCell)
        collectionView?.register(UserTabCell.self, forCellWithReuseIdentifier: Constants.CollectionViewCellIds.userTabCell)
        
        print("Logged in user: ", Auth.auth().currentUser?.uid ?? "No UId")
        
        fetchUser()
    }
    
    fileprivate func setupSettingsButton() {
        
        guard let _ = self.userId else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear"), style: .plain, target: self, action: #selector(handleSettings))
            navigationItem.rightBarButtonItem?.tintColor = UIColor.mainGreen()
            return
        }
    }
    
    @objc func handleSettings() {
        
        //FIXME: NOT SUPPOSED TO LOGOUT
        do {
            try Auth.auth().signOut()
            
            let loginVC = LoginVC()
            let navController = UINavigationController(rootViewController: loginVC)
            self.present(navController, animated: true, completion: nil)
            
        } catch let signOutError {
            print("Failed to sign out: ", signOutError)
        }
    }
    
    fileprivate func fetchUser() {
        
        let userId = self.userId ?? (Auth.auth().currentUser?.uid ?? "")
        
        Database.fetchUserFromUserID(userID: userId) { (user) in
            
            if let user = user {
                
                self.user = user
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    self.navigationItem.title = user.fullName
                }
                self.setupSettingsButton()
                self.addProfileView(forUser: user)
            }
        }
    }
    
    fileprivate func addProfileView(forUser user: User) {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        if user.userId == currentUserId {
            return
        }
        
        Database.fetchUserFromUserID(userID: currentUserId) { (fetchedUser) in
            if let currentUser = fetchedUser {
                
                print("CurrentUSer: ", currentUser)
                
                let values = [Constants.FirebaseDatabase.userId : currentUserId,
                              Constants.FirebaseDatabase.date : Date().timeIntervalSince1970
                    ] as [String : Any]
                
                let databaseRef = Database.database().reference().child(Constants.FirebaseDatabase.userProfileViewsRef).child(user.userId).childByAutoId()
                databaseRef.updateChildValues(values, withCompletionBlock: { (err, _) in
                    
                    if let error = err {
                        print("UserProfileVC/addProfileView(): Error uploading to database: ", error)
                        return
                    }
                    
                })
            }
        }
    }
    
    //MARK: Header cell Delegate Methods
    // Add section header for collectionView as supplementary kind
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // Dequeue reusable collectionViewHeaderCell
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.CollectionViewCellIds.userProfileHeaderCell, for: indexPath) as? UserProfileHeaderCell else {
            print("UserProfileHeaderCell is unconstructable"); fatalError()
        }
        
        header.user = self.user
        
        return header
    }
    
    // Need to provide a size or the section header will not render out
    // Define the size of the section header for the collectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 255)
    }
    
    //MARK: TabCell Delegate methods
    // What is the size of each cell ?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = width / 6
        return CGSize(width: width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let user = self.user {
            if user.isDoctor {
                //FIXME: number of cells for doctor's profile
                return 3
            } else {
                return self.patientTabCellTitles.count
            }
        } else {
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewCellIds.userTabCell, for: indexPath) as! UserTabCell
        
        if let user = self.user {
            if user.isDoctor {
                cell.titleLabel.text = self.doctorTabCellTitles[indexPath.item]
            } else {
                cell.titleLabel.text = self.patientTabCellTitles[indexPath.item]
            }
        }
        
        return cell
    }
}
