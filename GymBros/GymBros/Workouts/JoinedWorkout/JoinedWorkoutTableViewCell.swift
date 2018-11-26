//
//  JoinedWorkoutTableViewCell.swift
//  GymBros
//
//  Created by 이인혁 on 26/11/2018.
//  Copyright © 2018 Carnegie Mellon University IS Dept. All rights reserved.
//

import UIKit

class JoinedWorkoutTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
