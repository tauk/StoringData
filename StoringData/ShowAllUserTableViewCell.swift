//
//  ShowAllUserTableViewCell.swift
//  StoringData
//
//  Created by Tauseef Kamal on 12/12/16.
//  Copyright © 2016 Tauseef Kamal. All rights reserved.
//

import UIKit

class ShowAllUserTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
