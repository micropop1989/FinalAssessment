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
    
    var userID = User().currentUserUid()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frDBref = FIRDatabase.database().reference()
        
        
        
        featchUser()
        
    }

    
    @IBOutlet weak var editButton: UIButton! {
        didSet {
            editButton.addTarget(self, action: #selector(onEditButtonPressed), for: .touchUpInside)
        }
    }
    
    func onEditButtonPressed(button: UIButton) {
         self.performSegue(withIdentifier: "myProfileSegue", sender: self)
    }
    
    
    @IBOutlet weak var logoutButton: UIButton! {
        didSet {
            logoutButton.addTarget(self, action: #selector(onLogOutButtonPressed), for: .touchUpInside)
        }
    }
    
    func onLogOutButtonPressed(button: UIButton) {
        let logoutAlret = UIAlertController(title: "Logout Comfirmation", message: "yer or no", preferredStyle: .alert)
        let noButton = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        let yesButton = UIAlertAction(title: "YES", style: .default) { (action) in
            do
            {
                try FIRAuth.auth()?.signOut()
            }
            catch let logoutError {
                print(logoutError)
            }
            self.notifySuccessLogout()
        }
        
        logoutAlret.addAction(noButton)
        logoutAlret.addAction(yesButton)
        present(logoutAlret, animated: true, completion: nil)
    }
    
    
    func notifySuccessLogout ()
    {
        let UserLogoutNotification = Notification (name: Notification.Name(rawValue: "UserLogoutNotification"), object: nil, userInfo: nil)
        NotificationCenter.default.post(UserLogoutNotification)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "myProfileSegue") {
            let destination = segue.destination as! EditProfileViewController
            destination.fromVC = "My Profile"
            
            
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
            let newUser = User()
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
