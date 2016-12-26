//
//  CandidateDetailViewController.swift
//  FinalAssessment
//
//  Created by ALLAN CHAI on 21/12/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CandidateDetailViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    
       @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    var user  : User?
    var currentUserID = User().currentUserUid()
    
    var frDBref : FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frDBref = FIRDatabase.database().reference()
        
        loadProfile()
        
        self.title = user?.name
       
    }

    
    @IBOutlet weak var unmatchButton: UIButton! {
        didSet {
            unmatchButton.addTarget(self, action: #selector(onUnmatchButtonPressed), for: .touchUpInside)
             CustomUI().setButtonDesign(button: unmatchButton , color: UIColor.dodgerBlue)
        }
    }
    
    
     func onUnmatchButtonPressed(button: UIButton) {
        unmatchProfile()
    }
    
    
    func loadProfile() {
       // nameLabel.text = user?.name
        ageLabel.text = user?.age
        genderLabel.text = user?.gender
        emailLabel.text = user?.email
        descriptionLabel.text = user?.description
        
        if user?.profilepictureURL == "" {
            
            let image = UIImage(named: "emptyPic.jpg")
            profilePicture = UIImageView(image: image)
        } else {
            profilePicture.loadImageUsingCacheWithUrlString((user?.profilepictureURL!)!)
        }
    }
    
    func unmatchProfile() {
        let deleteAlret = UIAlertController(title: "Unmatch Cofirmation", message: "Are you sure you want UNMATCH!", preferredStyle: .alert)
        let noButton = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        let yesButton = UIAlertAction(title: "YES", style: .default) { (action) in
           self.frDBref.child("Match").child(self.currentUserID).child((self.user?.userID)!).removeValue()
            self.navigationController?.popViewController(animated: true)
        }
        
        deleteAlret.addAction(noButton)
        deleteAlret.addAction(yesButton)
        present(deleteAlret, animated: true, completion: nil)
    }

}
