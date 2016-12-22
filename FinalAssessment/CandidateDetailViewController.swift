//
//  CandidateDetailViewController.swift
//  FinalAssessment
//
//  Created by ALLAN CHAI on 21/12/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit

class CandidateDetailViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    var user  : User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfile()
       
    }

    
    @IBOutlet weak var unmatchButton: UIButton! {
        didSet {
            unmatchButton.addTarget(self, action: #selector(onUnmatchButtonPressed), for: .touchUpInside)
        }
    }
    
    
     func onUnmatchButtonPressed(button: UIButton) {
        unmatchProfile()
    }
    
    
    func loadProfile() {
        nameLabel.text = user?.name
        ageLabel.text = user?.age
        genderLabel.text = user?.gender
        emailLabel.text = user?.email
        
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
           
        }
        
        deleteAlret.addAction(noButton)
        deleteAlret.addAction(yesButton)
        present(deleteAlret, animated: true, completion: nil)
    }

}
