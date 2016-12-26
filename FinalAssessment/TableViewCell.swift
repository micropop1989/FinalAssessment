//
//  TableViewCell.swift
//  FinalAssessment
//
//  Created by ALLAN CHAI on 21/12/2016.
//  Copyright © 2016 Wherevership. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var boxView: UIView!
    
    var delegate : MatchedProfilesTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
       CustomUI().createBoxView(boxView: boxView, contentView: contentView)
        
        let swipeleft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleUnMatchGesture))
        swipeleft.direction = UISwipeGestureRecognizerDirection.left
        self.addGestureRecognizer(swipeleft)
        
    }
   
    func handleUnMatchGesture(gesture : UIGestureRecognizer) {
        delegate?.matchedProfileTableViewCellHandleUnMatch(cell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

protocol MatchedProfilesTableViewCellDelegate {
    func matchedProfileTableViewCellHandleUnMatch(cell : TableViewCell)
    
}
