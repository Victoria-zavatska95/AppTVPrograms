//
//  UniversalTableViewCell.swift
//  TapBar
//
//  Created by Azinec LLC on 5/26/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit

class UniversalTableViewCell: UITableViewCell {

    @IBOutlet weak var categoriesPicture: UIImageView!
    
    @IBOutlet weak var viewForImage: UIView!
    var pictureString: String = ""

    let nameLabel: UILabel! = UILabel(frame: CGRect(x: 85, y: 11, width: 239, height: 24))
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(nameLabel)
        
            }

   
        func setUp(title: String, pictureString: String) {
            nameLabel.text = title
            self.categoriesPicture.layer.masksToBounds = true
            if URL(string: pictureString) != nil {
            if let imageData: NSData = NSData(contentsOf: URL(string: pictureString)!) {
                self.categoriesPicture.image = UIImage(data: imageData as Data)
            }
            } else {
                self.categoriesPicture.image = UIImage(named: "default_photo")
            }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
