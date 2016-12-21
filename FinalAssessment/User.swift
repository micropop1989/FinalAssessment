//
//  User.swift
//  FinalAssessment
//
//  Created by ALLAN CHAI on 21/12/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import Foundation


class User {
    var userID : String? = ""
    var name : String? = ""
    var age : String? = ""
    var gender : String? = ""
    var email : String? = ""
    var password : String? = ""
    var description : String? = ""
    var profilepictureURL : String? = ""
    
    
     init(dict: [String:AnyObject]){
        
         name = dict["name"] as? String
        age = dict["age"] as? String
        email = dict["email"] as? String
        gender = dict["gender"] as? String
        description = dict["desc"] as? String
        
        
    }
    
}
