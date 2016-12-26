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
    @IBOutlet weak var boxView: UIView!
    
     var delegate : MatchCandidateTableViewCellDelegate?
   
    
    @IBOutlet weak var matchButton: UIButton! {
        didSet {
          matchButton.addTarget(self, action: #selector(onMatchButtonPressed), for: .touchUpInside)
             CustomUI().setButtonDesign(button: matchButton , color: UIColor.dodgerBlue)
        }
    }
    
   
    
    func onMatchButtonPressed(button: UIButton) {
        delegate?.matchCandidateTableViewCellHandleMatch(cell: self)
    }
    
    
    
    @IBOutlet weak var unMatchButton: UIButton! {
        didSet {
            unMatchButton.addTarget(self, action: #selector(onUnMatchButtonPressed), for: .touchUpInside)
            CustomUI().setButtonDesign(button: unMatchButton , color: UIColor.dodgerBlue)
        }
    }
    
    func onUnMatchButtonPressed(button: UIButton) {
      
        delegate?.matchCandidateTableviewCellHandleUnMatch(cell: self)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createBoxView()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleMatchGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.addGestureRecognizer(swipeRight)
        
        let swipeleft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleUnMatchGesture))
        swipeleft.direction = UISwipeGestureRecognizerDirection.left
        self.addGestureRecognizer(swipeleft)
    }
    
    
    func createBoxView() {
        boxView.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        boxView.layer.cornerRadius = 3.0
        boxView.layer.masksToBounds = false
        
        boxView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        
        boxView.layer.shadowOffset = CGSize(width: 0, height: 0)
        boxView.layer.shadowOpacity = 0.8
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
