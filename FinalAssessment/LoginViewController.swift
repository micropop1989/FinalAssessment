//
//  LoginViewController.swift
//  FinalAssessment
//
//  Created by ALLAN CHAI on 21/12/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
   
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
           loginButton.addTarget(self, action: #selector(onLoginButtonPressed), for: .touchUpInside)
        }
    }
    
    
    func onLoginButtonPressed(button: UIButton) {
        guard
            let email = emailLabel.text,
            let password = passwordLabel.text
            else
        {
            
            let title = "empty email and Password"
            let message = "you email and password is empty"
            let popUP = UIAlertController(title: title, message: message, preferredStyle: .alert)
             let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
             popUP.addAction(okButton)
               present(popUP, animated: true, completion: nil)

            return
        }
    }
    
    
    
    func checkLoggedInUser(){
        if FIRAuth.auth()?.currentUser == nil{
            print("No user right now, you can login")
        }
        else{
            print("there ald some user, sorry")
            //notifyExistLoggedInUser()
        }
    }

    
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.addTarget(self, action: #selector(onSignUpButtonPressed), for: .touchUpInside)
        }
    }
    
    func  onSignUpButtonPressed(button: UIButton) {
        self.performSegue(withIdentifier: "signUpSegue", sender: self)
        
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailLabel.placeholder = "Email"
        passwordLabel.placeholder = "Password"

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "signUpSegue") {
            let destination = segue.destination as! EditProfileViewController
            destination.fromVC = "LoginController"
            
            
        }
    }
    

}
