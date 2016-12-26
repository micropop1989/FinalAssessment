//
//  User.swift
//  FinalAssessment
//
//  Created by ALLAN CHAI on 21/12/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth


class User {
    var userID : String? = ""
    var name : String? = ""
    var age : String? = ""
    var gender : String? = ""
    var email : String? = ""
    var password : String? = ""
    var description : String? = ""
    var profilepictureURL : String? = ""
    
    
   

 /*   func signIn(uid: String) {
        let defaults = UserDefaults.standard
        defaults.set(uid, forKey: "uid")
    }
    
    func isSignedIn() -> Bool {
        if let _ = UserDefaults.standard.value(forKey: "uid") as? String {
            return true
        } else {
            return false
        }
    }
    
    func loadUid() -> String {
        return (UserDefaults.standard.value(forKey: "uid") as? String)!
    } 
 */
    
    
    func currentUserUid() -> String {
        guard let user = FIRAuth.auth()?.currentUser
            else{
                return ""
        }
        
        return user.uid
    }
    
    func userlogout() {
        do
        {
            try FIRAuth.auth()?.signOut()
        }
        catch let logoutError {
            print(logoutError)
        }
        self.notifySuccessLogout()
    }
    
    
    func notifySuccessLogout ()
    {
        let UserLogoutNotification = Notification (name: Notification.Name(rawValue: "UserLogoutNotification"), object: nil, userInfo: nil)
        NotificationCenter.default.post(UserLogoutNotification)
    }
    
    
    func prepareUserDictionary(name : String, email : String, pictureURL : String, desc : String, gender : String, age : String) -> [String : String]{
        var dict = [String : String]()
        dict["name"] = name
        dict["email"] = email
        dict["picture"] = pictureURL
        dict["desc"] = desc
        dict["gender"] = gender
        dict["age"] = age
        return dict
    }

    
    
   


    
}
