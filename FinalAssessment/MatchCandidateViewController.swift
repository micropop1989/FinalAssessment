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
    var users = [User]()
    var matchIDs = [String]()
    var filterUsers = [User]()
    
    var frDBref : FIRDatabaseReference!
    
    var currentUserID = User().currentUserUid()
    
    var indexToSend = -1
    var editRow = false
    @IBOutlet weak var filterButton: UIButton! {
        didSet {
        filterButton.addTarget(self, action: #selector(onFilterButtonPressed), for: .touchUpInside)
        }
    }
   
    @IBOutlet weak var filterLabel: UITextField!
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
    
        fetchData()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       //fetchData()
    }
    
    func fetchData() {
        fetchUser()
        fetchMatch()
    }
    
    
    func onFilterButtonPressed(button: UIButton) {
        filterAgeOrGender(filterString: filterLabel.text!)
    }
    
    func filterAgeOrGender(filterString : String) {
        filterUsers = []
        
        if filterString == ""{
            filterUsers = users
        }
        else{
            filterUsers = users.filter ({ user in
                
                return (user.gender!.lowercased().contains(filterString.lowercased())) || (user.age)!.contains(filterString)
                
            })
        }
        
        self.matchCandidateTableView.reloadData()

    }

    
    func fetchUser() {
        users = []
        frDBref.child("User").observe(.childAdded, with: { (userSnapshot) in
        
        guard let userId = userSnapshot.key as? String
            else {
                return
        }

        
        guard let userDictionary = userSnapshot.value as? [String : AnyObject]
                else { return }
            
        let newUser = User()
        if userId != self.currentUserID {
            newUser.userID = userId
            newUser.name = userDictionary["name"] as! String
            newUser.profilepictureURL = userDictionary["picture"] as! String
            
            newUser.age = userDictionary["age"] as! String
            newUser.gender = userDictionary["gender"] as! String
            self.users.append(newUser)

        }
            
                    
            })
    }
    
    
    func fetchMatch() {
        matchIDs = []
        frDBref.child("Match").child(currentUserID).observeSingleEvent(of: .value, with: { (matchSnapshot) in
            
            guard let matchDictionary = matchSnapshot.value as? [String : AnyObject]
                else { return }
            
            for (key, value) in matchDictionary {
              print(key)
              self.matchIDs.append(key)
            }
            self.matchCandidateTableView.reloadData()
            //self.matchIDs.append(matchID)
            
        })
        
    
        
            
    }

}

extension MatchCandidateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterButton.isTouchInside {
            return filterUsers.count
        } else {
        return users.count    }
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
       
       
        guard let cell : MatchCandidateTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MatchCandidateTableViewCell else {
            return UITableViewCell()
        }
        
        
        cell.delegate = self
        var user = User()
        
       
        if filterButton.isTouchInside {
            user = filterUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        
        
            cell.nameLabel.text = user.name
            cell.ageLabel.text = user.age
            cell.genderLabel.text = user.gender
        
        if matchIDs.contains(user.userID!) {
            cell.matchButton.setTitle("Liked", for: .normal)
            cell.unMatchButton.isHidden = true
            } else {
            cell.matchButton.setTitle("Like", for: .normal)
            cell.unMatchButton.isHidden = false
            
        }
        
          guard  let pictureURL = user.profilepictureURL else
          {
            let image = UIImage(named: "emptyPic")
            cell.profileImage = UIImageView(image: image)
            return cell }
        
        
            if pictureURL != "" {
                print(pictureURL)
                cell.profileImage.loadImageUsingCacheWithUrlString(pictureURL)
             
            } else {
                let image = UIImage(named: "emptyPic")
                cell.profileImage = UIImageView(image: image)
            }
        

    return cell
            
        }

        
    
}

extension MatchCandidateViewController: UITableViewDelegate {
    
}

extension MatchCandidateViewController: MatchCandidateTableViewCellDelegate {
    func matchCandidateTableViewCellHandleMatch(cell: MatchCandidateTableViewCell) {
        guard let indexPath = matchCandidateTableView.indexPath(for: cell)
            else{
                return
        }
        indexToSend = indexPath.row
        
        matchProfile()
    }
    
    func matchCandidateTableviewCellHandleUnMatch(cell: MatchCandidateTableViewCell) {
      
guard let indexPath = matchCandidateTableView.indexPath(for: cell)
            else{
                return
        }
        indexToSend = indexPath.row
        unmatchProfile()
        
        

    }

    func matchProfile() {
        var user  =  User()
        user = users[indexToSend]
        
        if matchIDs.contains(user.userID!) {
           self.warningPopUp(withTitle: "Liked!!!", withMessage: "You Already liked with \(user.name!)")
       
        } else {
            
            
            frDBref.child("Match").child(self.currentUserID).child(user.userID!).setValue(true)
                
            fetchMatch()
                
               // self.matchCandidateTableView.reloadRows(at: [indexPath], with: .none)
                
            }
        }
    
    func unmatchProfile() {
        var user  =  User()
        user = users[indexToSend]
        
         if matchIDs.contains(user.userID!) {
           self.warningPopUp(withTitle: "Info!!!", withMessage: "You Can't liked with \(user.name!)")
         } else  {
        self.warningPopUp(withTitle: "Dislike!!!", withMessage: "You diliked \(user.name!)")
        //user = users[indexToSend]
        users.remove(at: indexToSend)
        matchCandidateTableView.reloadData()
        }
        
        
        
    }

}
