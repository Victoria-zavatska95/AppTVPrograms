//
//  ProgramsTableViewCell.swift
//  TapBar
//
//  Created by Azinec LLC on 5/31/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit

class ProgramsTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
   
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setUp(title: String, time: String) {
        timeLabel.text = time
        titleLabel.text = title
          }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
