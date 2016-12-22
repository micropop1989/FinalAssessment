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
    @IBOutlet weak var matchButton: UIButton! {
        didSet {
          matchButton.addTarget(self, action: #selector(onMatchButtonPressed), for: .touchUpInside)
        }
    }
    
    func onMatchButtonPressed(button: UIButton) {
        
    }
    
    
    
    @IBOutlet weak var unMatchButton: UIButton! {
        didSet {
            unMatchButton.addTarget(self, action: #selector(onUnMatchButtonPressed), for: .touchUpInside)
        }
    }
    
    func onUnMatchButtonPressed(button: UIButton) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
