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
   
    @IBOutlet weak var profileImage: UIImageView!
    var frDBref : FIRDatabaseReference!
    
    var userID = User().currentUserUid()
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frDBref = FIRDatabase.database().reference()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        featchUser()
        
        
    }

    
    @IBOutlet weak var editButton: UIButton! {
        didSet {
            editButton.addTarget(self, action: #selector(onEditButtonPressed), for: .touchUpInside)
            CustomUI().setButtonDesign(button: editButton, color: UIColor.dodgerBlue)
        }
    }
    
    func onEditButtonPressed(button: UIButton) {
         self.performSegue(withIdentifier: "myProfileSegue", sender: self)
       
    }
    
    
    @IBOutlet weak var logoutButton: UIButton! {
        didSet {
            logoutButton.addTarget(self, action: #selector(onLogOutButtonPressed), for: .touchUpInside)
             CustomUI().setButtonDesign(button: logoutButton , color: UIColor.dodgerBlue)
        }
    }
    
    func onLogOutButtonPressed(button: UIButton) {
        let logoutAlret = UIAlertController(title: "Logout Comfirmation", message: "Are you sure you want LOG OUT!", preferredStyle: .alert)
        let noButton = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        let yesButton = UIAlertAction(title: "YES", style: .default) { (action) in
           self.user.userlogout()
        }
        
        logoutAlret.addAction(noButton)
        logoutAlret.addAction(yesButton)
        present(logoutAlret, animated: true, completion: nil)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "myProfileSegue") {
            let destination = segue.destination as! EditProfileViewController
            destination.fromVC = "My Profile"
            destination.user = user
            
            
        }
    }

   
    
    

    func featchUser() {
       // guard let userid = station?.stationID
         //   else{ return }
   
       // let userid = "User4"
      
        frDBref.child("User").child(userID).observeSingleEvent(of: .value, with: { (userSnapshot) in
            
            
            
            guard let userDictionary = userSnapshot.value as? [String : AnyObject]
                else
            {
                return
            }
            
           self.user.userID = self.userID
           self.user.name = userDictionary["name"] as? String
           self.user.age = userDictionary["age"] as? String
            self.user.gender  = userDictionary["gender"] as? String
            self.user.email = userDictionary["email"] as? String
            self.user.profilepictureURL = userDictionary["picture"] as? String
            self.user.description = userDictionary["desc"] as? String
            
            
           // self.user = newUser
            self.fillInDetail()
           
        })
    }
 
    
    func fillInDetail() {
    //nameLabel.text = user.name
    ageLabel.text = user.age
    genderLabel.text = user.gender
    emailLabel.text = user.email
    title = user.name
    if user.profilepictureURL == "" {
    
    let image = UIImage(named: "emptyPic.jpg")
    self.profileImage = UIImageView(image: image)
    } else {

    self.profileImage.loadImageUsingCacheWithUrlString(user.profilepictureURL!)
    }
    }
    

}
