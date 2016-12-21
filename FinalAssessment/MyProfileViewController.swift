//
//  MyProfileViewController.swift
//  FinalAssessment
//
//  Created by ALLAN CHAI on 21/12/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MyProfileViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var frDBref : FIRDatabaseReference!
    
    @IBOutlet weak var editButton: UIButton! {
        didSet {
            editButton.addTarget(self, action: #selector(onEditButtonPressed), for: .touchUpInside)
        }
    }
    
    func onEditButtonPressed(button: UIButton) {
        
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        frDBref = FIRDatabase.database().reference()
        
        featchUser()
        
    }
    

    func featchUser() {
       // guard let userid = station?.stationID
         //   else{ return }
   
        let userid = "User1"
      
        frDBref.child("User").child(userid).observeSingleEvent(of: .value, with: { (userSnapshot) in
            
            let newUser = User()
            guard let UserDictionary = userSnapshot.value as? [String : AnyObject]
                else
            {
                return
            }
            
           newUser.name = UserDictionary["Name"] as? String
           newUser.age = UserDictionary["age"] as? Int
            newUser.gender  = (UserDictionary["gender"] as? String)!
            newUser.email = (UserDictionary["email"] as? String)!
            
            
            self.nameLabel.text = newUser.name
            self.ageLabel.text = "\(newUser.age)"
            self.genderLabel.text = newUser.gender
            self.emailLabel.text = newUser.email
            
        })
        
            

    }
    

}
