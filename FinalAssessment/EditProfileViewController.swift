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
    @IBOutlet weak var genderPickerView: UIPickerView!
    
   
    
    @IBOutlet weak var createAccountButton: UIButton! {
        didSet {
            createAccountButton.addTarget(self, action: #selector(oncreateAccountButtonPressed), for: .touchUpInside)
        }
    }
    
     func oncreateAccountButtonPressed(button: UIButton) {
    }
    
    @IBOutlet weak var updateAccountButton: UIButton! {
        didSet {
            updateAccountButton.addTarget(self, action: #selector(updateAccountButtonPressed), for: .touchUpInside)
        }
    }
    
    func updateAccountButtonPressed(button: UIButton) {
        
    }
    
   
    
    @IBOutlet weak var backButton: UIButton!
    
    var fromVC : String? = ""
   
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        hideButton()
        intinal()
        print(fromVC)
        

       
    }
  
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
