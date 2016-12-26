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
    
    var indexToSend = -1
    
    var container  = UIView()
    var loadingView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var boxView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CustomUI().showActivityIndicatory(uiView: self.view, container: container, loadingView: loadingView, activityIndicator: activityIndicator)
        tableView.delegate = self
        tableView.dataSource = self
        frDBref = FIRDatabase.database().reference()
        self.title = "Matched Profile"
        
        //fetchUser()
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 99.0
        
 }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableReload()
    }
    
    func tableReload() {
        users = []
        fetchUser()

    }
    
    
    func fetchUser() {
       
       // let matchUserID = "User4"
       frDBref.child("Match").child(matchUserID).observeSingleEvent(of: .value, with: { (MatchuserSnapshot) in
      
        
        guard let matchUserDictionary = MatchuserSnapshot.value as? [String : AnyObject]
                    else { return }
        
        for (userkey, value) in matchUserDictionary {
          
            self.frDBref.child("User").child(userkey).observeSingleEvent(of: .value, with: { (userSnapshot) in
                
                
                guard let userID = userSnapshot.key as? String
                    else {
                        return
                }

            
                guard let userDictionary = userSnapshot.value as? [String : AnyObject]
                              else { return }
            let newUser = User()
            newUser.userID = userID
            newUser.name = userDictionary["name"] as? String
            newUser.profilepictureURL = userDictionary["picture"] as? String
            newUser.age = userDictionary["age"] as? String
            newUser.gender = userDictionary["gender"] as? String
            newUser.email = userDictionary["email"] as? String
            newUser.description = userDictionary["desc"] as? String
           
                self.users.append(newUser)
            
            
            self.tableView.reloadData()
            CustomUI().dismissActivityIndicatory(container: self.container, activityIndicator:  self.activityIndicator)
            
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
        
        if user.profilepictureURL != "" {
            cell.profilePicture.loadImageUsingCacheWithUrlString(user.profilepictureURL!)
            
        } else {
            let image = UIImage(named: "emptyPic")
            cell.profilePicture = UIImageView(image: image)
        }
        cell.delegate = self
        return cell
    }

}

extension MatchedProfilesViewController: MatchedProfilesTableViewCellDelegate {
    func matchedProfileTableViewCellHandleUnMatch(cell: TableViewCell) {
        guard let indexPath =  tableView.indexPath(for: cell)
            else{
                return
        }
        indexToSend = indexPath.row
        unmatchProfile()
    }
    
    func unmatchProfile() {
        var user  =  User()
        user = users[indexToSend]
        
        
        let unmatchAlret = UIAlertController(title: "Unmatch Cofirmation", message: "Are you sure you want UNMATCH!", preferredStyle: .alert)
        let noButton = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        let yesButton = UIAlertAction(title: "YES", style: .default) { (action) in
            self.frDBref.child("Match").child(self.matchUserID).child((user.userID)!).removeValue()
            self.tableReload()
        }
        
        unmatchAlret.addAction(noButton)
        unmatchAlret.addAction(yesButton)
        present(unmatchAlret, animated: true, completion: nil)
        
        
    }

}
