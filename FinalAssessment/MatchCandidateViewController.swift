//
//  MatchCandidateViewController.swift
//  FinalAssessment
//
//  Created by ALLAN CHAI on 21/12/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MatchCandidateViewController: UIViewController {
    var users : [User] = []
    
    var frDBref : FIRDatabaseReference!
    
    var userID = User().currentUserUid()

   
    @IBOutlet weak var matchCandidateTableView: UITableView! {
        didSet {
            matchCandidateTableView.delegate = self
            matchCandidateTableView.dataSource = self
            
            
            matchCandidateTableView.tableFooterView = UIView()
            matchCandidateTableView.rowHeight = UITableViewAutomaticDimension
            matchCandidateTableView.estimatedRowHeight = 99.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
               frDBref = FIRDatabase.database().reference()
    
        fetchUser()
    }
    
    func fetchUser() {
        
     frDBref.child("User").observe(.childAdded, with: { (userSnapshot) in
        
        guard let userId = userSnapshot.key as? String
            else {
                return
        }

        
        guard let userDictionary = userSnapshot.value as? [String : AnyObject]
                else { return }
            
        let newUser = User()
        if userId != self.userID {
            newUser.userID = userId
            newUser.name = userDictionary["name"] as! String
            newUser.profilepictureURL = userDictionary["picture"] as! String
            
            newUser.age = userDictionary["age"] as! String
            newUser.gender = userDictionary["gender"] as! String
            self.users.append(newUser)

        }
              self.matchCandidateTableView.reloadData()
                    
            })
    }

}

extension MatchCandidateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
       
       
        guard let cell : MatchCandidateTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MatchCandidateTableViewCell else {
            return UITableViewCell()
        }
        
        
        
        let user : User
        user = users[indexPath.row]
        
        
        
            cell.nameLabel.text = user.name
            cell.ageLabel.text = user.age
            cell.genderLabel.text = user.gender
            
            if user.profilepictureURL == "" {
                
                let image = UIImage(named: "emptyPic")
                cell.profileImage = UIImageView(image: image)
            } else {
                cell.profileImage.loadImageUsingCacheWithUrlString(user.profilepictureURL!)
            }

    return cell
            
        }

        
    
}

extension MatchCandidateViewController: UITableViewDelegate {
    
}
