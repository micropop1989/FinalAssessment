//
//  MatchCandidateTableViewCell.swift
//  FinalAssessment
//
//  Created by ALLAN CHAI on 21/12/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit

class MatchCandidateTableViewCell: UITableViewCell {

    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
   
    @IBOutlet weak var ageLabel: UILabel!
    
     var delegate : MatchCandidateTableViewCellDelegate?
   
    
    @IBOutlet weak var matchButton: UIButton! {
        didSet {
          matchButton.addTarget(self, action: #selector(onMatchButtonPressed), for: .touchUpInside)
        }
    }
    
   
    
    func onMatchButtonPressed(button: UIButton) {
        delegate?.matchCandidateTableViewCellHandleMatch(cell: self)
    }
    
    
    
    @IBOutlet weak var unMatchButton: UIButton! {
        didSet {
            unMatchButton.addTarget(self, action: #selector(onUnMatchButtonPressed), for: .touchUpInside)
        }
    }
    
    func onUnMatchButtonPressed(button: UIButton) {
      
        delegate?.matchCandidateTableviewCellHandleUnMatch(cell: self)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleMatchGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.addGestureRecognizer(swipeRight)
        
        let swipeleft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleUnMatchGesture))
        swipeleft.direction = UISwipeGestureRecognizerDirection.left
        self.addGestureRecognizer(swipeleft)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func handleMatchGesture(gesture: UIGestureRecognizer) {
        delegate?.matchCandidateTableViewCellHandleMatch(cell: self)
    }
    
    func handleUnMatchGesture(gesture: UIGestureRecognizer) {
        delegate?.matchCandidateTableviewCellHandleUnMatch(cell: self)
    }

}

protocol MatchCandidateTableViewCellDelegate {
    func matchCandidateTableViewCellHandleMatch(cell : MatchCandidateTableViewCell)
    func matchCandidateTableviewCellHandleUnMatch(cell : MatchCandidateTableViewCell)
    
}
