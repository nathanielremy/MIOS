//
//  SexAndBirthdateVC.swift
//  MIOS
//
//  Created by Nathaniel Remy on 29/01/2018.
//  Copyright © 2018 Nathaniel Remy. All rights reserved.
//

import UIKit
import Firebase

class SexAndBirthdateVC: UIViewController {
    
    //MARK: Stored properties
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.hidesWhenStopped = true
        ai.color = UIColor.mainGreen()
        
        return ai
    }()
    
    let birthdateTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Select your Birthdate"
        label.textColor = UIColor.mainGreen()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        
        return dp
    }()
    
    @objc func handleDatePicker() {
        nextButton.isEnabled = true
        nextButton.backgroundColor = UIColor.mainGreen().withAlphaComponent(1)
    }
    
    let sexTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Select your Sex"
        label.textColor = UIColor.mainGreen()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    let sexPickerView: UIPickerView = {
        let pv = UIPickerView()
        
        return pv
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.tintColor = .white
        button.backgroundColor = UIColor.mainGreen().withAlphaComponent(0.3)
        button.layer.cornerRadius = 25
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleNextButton() {
        
        enableAndActivate(true)
        
        guard let age = datePicker.date.age, age > 5, age < 110 else {
            enableAndActivate(false)
            present(alert(title: "Invalid age", message: "Please select an age between 5 and 110 years old."), animated: true, completion: nil)
            return
        }
        
        storeAgeAndSex()
    }
    
    fileprivate func storeAgeAndSex() {
        
        guard let currentUserID = Auth.auth().currentUser?.uid else { fatalError("SexAndBirthdateVC/storeAgeAndSex(): No currentUserID") }
        
        var sex: String
        
        if sexPickerView.selectedRow(inComponent: 0) == 0 {
            sex = "male"
        } else if sexPickerView.selectedRow(inComponent: 0) == 1 {
            sex = "female"
        } else {
            sex = "other"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let stringDate = dateFormatter.string(from: datePicker.date)
        
        let values = [Constants.FirebaseDatabase.sex : sex, Constants.FirebaseDatabase.birthdate : stringDate] as [String : Any]
        
        let databaseRef = Database.database().reference().child(Constants.FirebaseDatabase.usersRef).child(currentUserID)
        databaseRef.updateChildValues(values, withCompletionBlock: { (err, databaseReference) in
            
            if let error = err {
                print("Failed to save user birthdate and sex into database", error)
                DispatchQueue.main.async {
                    self.enableAndActivate(false)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.enableAndActivate(false)
                let miosIdVC = MIOSIdVC()
                self.navigationController?.pushViewController(miosIdVC, animated: true)
            }
        })
    }
    
    fileprivate func enableAndActivate(_ bool: Bool) {
        
        if bool {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        birthdateTextLabel.isEnabled = !bool
        datePicker.isEnabled = !bool
        sexTextLabel.isEnabled = !bool
        sexPickerView.isHidden = bool
        nextButton.isEnabled = !bool
        navigationItem.backBarButtonItem?.isEnabled = !bool
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Birthdate and Sex"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        setupView()
    }
    
    fileprivate func setupView() {
        
        view.addSubview(birthdateTextLabel)
        birthdateTextLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: nil, height: nil)
        
        view.addSubview(datePicker)
        datePicker.anchor(top: birthdateTextLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 25, paddingLeft: 20, paddingBottom: 0, paddingRight: -20, width: nil, height: 100)
        
        view.addSubview(sexTextLabel)
        sexTextLabel.anchor(top: datePicker.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: nil, height: nil)
        
        view.addSubview(sexPickerView)
        sexPickerView.anchor(top: sexTextLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 25, paddingLeft: 20, paddingBottom: 0, paddingRight: -20, width: nil, height: 100)
        sexPickerView.dataSource = self
        sexPickerView.delegate = self
        
        view.addSubview(nextButton)
        nextButton.anchor(top: nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: -20, paddingRight: 0, width: 200, height: 50)
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func alert(title: String, message: String) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .cancel , handler: nil)
        alertController.addAction(okAction)
        
        return alertController
    }
}

extension SexAndBirthdateVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if row == 0 {
            return "Male"
        } else if row == 1 {
            return "Female"
        } else {
            return "Other"
        }
    }
}
