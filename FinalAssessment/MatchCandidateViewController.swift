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
    
    var container  = UIView()
    var loadingView = UIView()
    var activityIndicator = UIActivityIndicatorView()

    
    var indexToSend = -1
   // var editRow = false
    
   // var filterOn = false
    
    @IBOutlet weak var filterView: UIView!
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var filterButton: UIButton! {
        didSet {
        filterButton.addTarget(self, action: #selector(onFilterButtonPressed), for: .touchUpInside)
        }
    }
   
  //  @IBOutlet weak var filtertext: UITextField!
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
        CustomUI().showActivityIndicatory(uiView: self.view, container: container, loadingView: loadingView, activityIndicator: activityIndicator)
        frDBref = FIRDatabase.database().reference()
        self.title = "Match Candidate"
        initSearchBar()
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
       // filterAgeOrGender(filterString: filtertext.text!)
    }
    
    func filterAgeOrGender(filterString : String) {
        filterUsers = []
        
        if filterString == ""{
        filterUsers = users
        }
        else{
            filterUsers = users.filter ({ user in
                
                return (user.gender!.lowercased() == filterString.lowercased()) || (user.age)! == filterString
                
            })
       }
    //    filterOn = true
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
                else {
               self.matchCandidateTableView.reloadData()
               CustomUI().dismissActivityIndicatory(container: self.container, activityIndicator:  self.activityIndicator)
               return
            }
            
            for (key, value) in matchDictionary {
              print(key)
              self.matchIDs.append(key)
            }
            self.matchCandidateTableView.reloadData()
            CustomUI().dismissActivityIndicatory(container: self.container, activityIndicator:  self.activityIndicator)

            //self.matchIDs.append(matchID)
            
        })
        
    
        
            
    }
    
    func initSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.definesPresentationContext = true
        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Filter age or gender"
        matchCandidateTableView.tableHeaderView = searchController.searchBar
       
    }

}

extension MatchCandidateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     //  if filtertext.isEditing == true && filtertext.text == "" {
      //  if filterOn {
        if searchController.isActive && searchController.searchBar.text != "" {
        return filterUsers.count
        
        } else {
        return users.count
        }
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
       
       
        guard let cell : MatchCandidateTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MatchCandidateTableViewCell else {
            return UITableViewCell()
        }
        
        
        cell.delegate = self
        var user = User()
        
     
        if searchController.isActive && searchController.searchBar.text != "" {
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
            let img = UIImage(named: "emptyPic")
            cell.profileImage = UIImageView(image: img)
            return cell }
        
        
            if pictureURL != "" {
                print(pictureURL)
                cell.profileImage.loadImageUsingCacheWithUrlString(pictureURL)
             
            } else {
                let img = UIImage(named: "emptyPic")
                cell.profileImage = UIImageView(image: img)
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
        
        likeProfile()
    }
    
    func matchCandidateTableviewCellHandleUnMatch(cell: MatchCandidateTableViewCell) {
      
        guard let indexPath = matchCandidateTableView.indexPath(for: cell)
            else{
                return
        }
        indexToSend = indexPath.row
        dislikeProfile()
        
        

    }

    func likeProfile() {
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
    
    func dislikeProfile() {
        var user  =  User()
        user = users[indexToSend]
        
         if matchIDs.contains(user.userID!) {
           self.warningPopUp(withTitle: "Info!!!", withMessage: "Due to you already liked with \(user.name!). So, you Can't dislike with \(user.name!)")
         } else  {
        self.warningPopUp(withTitle: "Dislike!!!", withMessage: "You diliked \(user.name!)")
        //user = users[indexToSend]
        users.remove(at: indexToSend)
        matchCandidateTableView.reloadData()
        }
        
        
        
    }

}

extension MatchCandidateViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar)
    {
        filterAgeOrGender(filterString: searchBar.text!)
    }
    
    
}

extension MatchCandidateViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterAgeOrGender(filterString: searchController.searchBar.text!)
    }
}
