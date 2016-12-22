//
//  EditProfileViewController.swift
//  FinalAssessment
//
//  Created by ALLAN CHAI on 21/12/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class EditProfileViewController: UIViewController {

    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var genderPickerView: UIPickerView! {
        didSet {
            genderPickerView.delegate = self
            genderPickerView.dataSource = self
        }
    }
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var genderLabel: UILabel!
    var gender = ["Male", "Female"]
   
    
    @IBOutlet weak var createAccountButton: UIButton! {
        didSet {
            createAccountButton.addTarget(self, action: #selector(oncreateAccountButtonPressed), for: .touchUpInside)
        }
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        hideButton()
        intinal()
        print(fromVC)
        
        genderLabel.isUserInteractionEnabled = true
        profilePicture.isUserInteractionEnabled = true
        let genderLabeltap = UITapGestureRecognizer(target:self,action:#selector(self.tapToShowPickerView(sender:)))
        let chooseImage = UITapGestureRecognizer(target:self, action:#selector(self.tapToOpenImagePicker(sender:)))
        genderLabel.addGestureRecognizer(genderLabeltap)
        
        profilePicture.addGestureRecognizer(chooseImage)
}

     func oncreateAccountButtonPressed(button: UIButton) {
    }
    
    @objc  private func tapToShowPickerView(sender: UITapGestureRecognizer) {
        genderPickerView.isHidden = false
    }
    
    @objc  private func tapToOpenImagePicker(sender: UITapGestureRecognizer) {
        self.warningPopUp(withTitle: "tesstg", withMessage: "haha")
    }
    
    
    
    
    @IBOutlet weak var updateAccountButton: UIButton! {
        didSet {
            updateAccountButton.addTarget(self, action: #selector(updateAccountButtonPressed), for: .touchUpInside)
        }
    }
    
    func updateAccountButtonPressed(button: UIButton) {
        
    }
    
   
    
   
    
    var fromVC : String? = ""
   
   
    
    func hideButton() {
        if fromVC == "LoginController" {
            createAccountButton.isHidden = false
            updateAccountButton.isHidden = true
            
        } else if fromVC == "My Profile" {
            createAccountButton.isHidden = true
            updateAccountButton.isHidden = false
        }
    }
    
    
    func intinal() {
        descriptionText.placeholder  = "descriptionText"
        passwordText.placeholder = "passwordText"
        emailText.placeholder = "email"
        nameText.placeholder = "name"
        ageText.placeholder = "age"
        
        
    }
   
}

extension EditProfileViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]
    }
}

extension EditProfileViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderLabel.text = gender[row]
        pickerView.isHidden = true
    }
}
