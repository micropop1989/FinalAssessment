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

    @IBOutlet weak var logInTitleLable: UILabel!
      
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
           loginButton.addTarget(self, action: #selector(onLoginButtonPressed), for: .touchUpInside)
        }
    }
    
    
    func onLoginButtonPressed(button: UIButton) {
       guard
            let email = emailTextField.text,
            let password = passwordTextField.text
            else
        {
            
           
            self.warningPopUp(withTitle: "Error", withMessage: "email and name error")

            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {(user, error) in
            //if no error and user exist
            if let authError = error {
                //display the error
                print("login error \(authError)")
                
                self.warningPopUp(withTitle: "Log in Error", withMessage: "Email or Password no matched")
                
                return
            }
            
            //testing
            print("loggged in")
          //  helper().currentUserInfo()
            
            guard let firUser = user else {
                self.warningPopUp(withTitle: "Log in Error", withMessage: "No found the User")
                //auth success but user not found
                // weird bug
                return
            }

            //self.warningPopUp(withTitle: "Login Seccess", withMessage: "")
           // let user = User()
            //user.currentUserInfo()
            
            print("loggged in")
            
           self.notifySuccessLogin()
        })
    
/*
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NaviTabBarController") as! UITabBarController
        let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil) */
    }
    
    
    
    func checkLoggedInUser(){
        if FIRAuth.auth()?.currentUser == nil{
            print("No user right now, you can login")
        }
        else{
            print("there ald some user, sorry")
            notifyExistLoggedInUser()
        }
    }
    
    func notifySuccessLogin ()
    {
        let AuthSuccessNotification = Notification (name: Notification.Name(rawValue: "AuthSuccessNotification"), object: nil, userInfo: nil)
        NotificationCenter.default.post(AuthSuccessNotification)
    }
    
    func notifyExistLoggedInUser ()
    {
        let ExistLoggedInUserNotification = Notification (name: Notification.Name(rawValue: "ExistLoggedInUserNotification"), object: nil, userInfo: nil)
        NotificationCenter.default.post(ExistLoggedInUserNotification)
    }


    
    
    @IBOutlet weak var signUpButton: UIButton! {
        didSet {
            signUpButton.addTarget(self, action: #selector(onSignUpButtonPressed), for: .touchUpInside)
        }
    }
    
    func  onSignUpButtonPressed(button: UIButton) {
        self.performSegue(withIdentifier: "signUpSegue", sender: self)
        
        

    }
    
    
    func initLoginView() {
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        CustomUI().setGradientBackgroundColor(view: self.view, firstColor: UIColor.midNightBlue, secondColor: UIColor.dodgerBlue)
        
        CustomUI().setLoginLabel(lable: logInTitleLable)
        CustomUI().setButtonDesign(button: loginButton, color: UIColor.orange)
        CustomUI().setButtonDesign(button: signUpButton, color: UIColor.orange)
        
     
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkLoggedInUser()
         initLoginView()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "signUpSegue") {
            let destination = segue.destination as! EditProfileViewController
            destination.fromVC = "LoginController"
            
            
        }
    }
    
    
    
    

}
