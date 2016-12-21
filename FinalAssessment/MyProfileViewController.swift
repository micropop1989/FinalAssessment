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
         self.performSegue(withIdentifier: "myProfileSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "myProfileSegue") {
            let destination = segue.destination as! EditProfileViewController
            destination.fromVC = "My Profile"
            
            
        }
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
            
            
            guard let userDictionary = userSnapshot.value as? [String : AnyObject]
                else
            {
                return
            }
            let newUser = User(dict: userDictionary)
           newUser.name = userDictionary["name"] as? String
           newUser.age = userDictionary["age"] as? String
            newUser.gender  = (userDictionary["gender"] as? String)!
            newUser.email = (userDictionary["email"] as? String)!
            newUser.profilepictureURL = userDictionary["picture"] as? String
            
            
            self.nameLabel.text = newUser.name
            self.ageLabel.text = newUser.age
            self.genderLabel.text = newUser.gender
            self.emailLabel.text = newUser.email
            if newUser.profilepictureURL == "" {
                
                let image = UIImage(named: "emptyPic.jpg")
                self.profileImage = UIImageView(image: image)
            } else {
                self.profileImage.loadImageUsingCacheWithUrlString(newUser.profilepictureURL!)
            }
            
        })
        
            

    }
    

}
