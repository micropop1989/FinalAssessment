//
//  MatchedProfilesViewController.swift
//  FinalAssessment
//
//  Created by ALLAN CHAI on 21/12/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class MatchedProfilesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var users : [User] = []
    
    var frDBref : FIRDatabaseReference!
    
    var matchUserID = User().currentUserUid()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        frDBref = FIRDatabase.database().reference()
        
        fetchUser()
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 99.0
        
        
        let swipeleft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeleft))
        self.view.addGestureRecognizer(swipeleft)
        
        
    

   }
    
    //todo
    func handleSwipeleft(tapGesture: UITapGestureRecognizer) {
        
    }
    
    
    
    
    func fetchUser() {
      
       // let matchUserID = "User4"
       frDBref.child("Match").child(matchUserID).observeSingleEvent(of: .value, with: { (MatchuserSnapshot) in
      
        guard let matchUserDictionary = MatchuserSnapshot.value as? [String : AnyObject]
                    else { return }
        
        for (userkey, value) in matchUserDictionary {
          
            self.frDBref.child("User").child(userkey).observeSingleEvent(of: .value, with: { (userSnapshot) in
            
                guard let userDictionary = userSnapshot.value as? [String : AnyObject]
                              else { return }
            let newUser = User()
            newUser.name = userDictionary["name"] as? String
            newUser.profilepictureURL = userDictionary["picture"] as? String
            newUser.age = userDictionary["age"] as? String
            newUser.gender = userDictionary["gender"] as? String
            newUser.email = userDictionary["email"] as? String
            self.users.append(newUser)
            
            
            self.tableView.reloadData()
            
            
            })
        }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "fromMatchProfilesSegue") {
            guard let selectedIndexPath : IndexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            let seletedProfile : User = users[selectedIndexPath.row]
            let controller : CandidateDetailViewController = segue.destination as! CandidateDetailViewController
            controller.user = seletedProfile
        }
    }

    
}

extension MatchedProfilesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "fromMatchProfilesSegue", sender: self)
    }
}

extension MatchedProfilesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
            
        }
        
        let user : User
        user = users[indexPath.row]
        cell.NameLabel.text = user.name
        
        if user.profilepictureURL == "" {
            
            let image = UIImage(named: "emptyPic")
            cell.profilePicture = UIImageView(image: image)
        } else {
            cell.profilePicture.loadImageUsingCacheWithUrlString(user.profilepictureURL!)
        }
        
        return cell
    }

}
