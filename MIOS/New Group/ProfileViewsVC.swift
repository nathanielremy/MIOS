//
//  ProfileViewsVC.swift
//  MIOS
//
//  Created by Nathaniel Remy on 03/02/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfileViewsVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: Stored properties
    var profileViews = [ProfileView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        
        navigationItem.title = "Viewed my Profile"
        
        collectionView?.register(ProfileViewCell.self, forCellWithReuseIdentifier: Constants.CollectionViewCellIds.profileViewCell)
        
        fetchProfileViews()
    }
    
    fileprivate func fetchProfileViews() {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let databaseRef = Database.database().reference().child(Constants.FirebaseDatabase.userProfileViewsRef).child(currentUserId)
        databaseRef.observeSingleEvent(of: .value, with: { (dataSnapshot) in
            
            guard let dataDictionary = dataSnapshot.value as? [String : Any] else {
                print("ProfileViewsVC/fetchProfileViews(): could not convert dataSnapshot to [String:Any]"); return
            }
            
            dataDictionary.forEach({ (key, value) in
                
                guard let dictionary = value as? [String : Any] else { return }
                guard let uid = dictionary[Constants.FirebaseDatabase.userId] as? String else { return }
                
                Database.fetchUserFromUserID(userID: uid, completion: { (fetchedUser) in
                    if let user = fetchedUser {
                        let profView = ProfileView(user: user, dictionary: dictionary)
                        self.profileViews.append(profView)
                        self.profileViews.sort(by: { (view1, view2) -> Bool in
                            return view1.date.compare(view2.date) == .orderedDescending
                        })
                        self.collectionView?.reloadData()
                    }
                })
             })
        }) { (error) in
            print("ProfileViewsVC/fetchProfileViews(): Error retrieving data: ", error)
        }
    }
    
    fileprivate func handleZeroViews() {
        
        //FIXME: HANDLE ZERO VIEWS
        
    }
    
    func alert(title: String, message: String) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .cancel , handler: nil)
        alertController.addAction(okAction)
        
        return alertController
    }
    
    //MARK: CollectionViewDelegate methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let numberOfItems = self.profileViews.count
        
        if numberOfItems == 0 {
            handleZeroViews()
            return self.profileViews.count
        } else {
            return self.profileViews.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewCellIds.profileViewCell, for: indexPath) as! ProfileViewCell
        
        cell.profileView = self.profileViews[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: 86)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedUser = self.profileViews[indexPath.item]
        
        let layout = UICollectionViewFlowLayout()
        
        let userProfileVC = UserProfileVC(collectionViewLayout: layout)
        userProfileVC.userId = selectedUser.user.userId
        
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
}
