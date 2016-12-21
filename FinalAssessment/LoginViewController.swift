//
//  LoginViewController.swift
//  FinalAssessment
//
//  Created by ALLAN CHAI on 21/12/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        emailLabel.placeholder = "Email"
        passwordLabel.placeholder = "Password"

    }

}
