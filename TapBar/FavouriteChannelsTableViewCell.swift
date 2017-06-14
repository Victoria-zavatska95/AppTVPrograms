//
//  FavouriteChannelsTableViewCell.swift
//  TapBar
//
//  Created by Azinec LLC on 5/29/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit

class FavouriteChannelsTableViewCell: UITableViewCell {
  
    @IBOutlet weak var viewForImage: UIView!
    
    @IBOutlet weak var channelPicture: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var websiteURLLabel: UILabel!
    
    @IBOutlet weak var removeFromFavouriteListButton: UIButton!
    
    @IBOutlet weak var visitWebsiteButton: UIButton!
    
    var arrayOfFavouriteChannels: [[String:String]] = []
       var favouriteChannelsArray: [String] = []
    var pictureString: String = ""
    var id: String = "-3"
    var indexOfRow: Int = -2
    var currentUser = UserDefaults.standard
    var channelId : String = ""

       var variableTableView: FavouriteChannelsListTableViewController! = nil

      override func awakeFromNib() {
        super.awakeFromNib()
        if self.currentUser.value(forKey: "arrayOfFavoriteChannels") != nil {
            self.arrayOfFavouriteChannels = self.currentUser.value(forKey: "arrayOfFavoriteChannels") as! [[String : String]]
                   }
        self.viewForImage.layer.cornerRadius = 49.0
        self.viewForImage.layer.borderWidth = 2.0
        self.viewForImage.layer.borderColor = UIColor(white: 1, alpha: 0.4).cgColor
        self.channelPicture.layer.cornerRadius = 49.0
        
        self.channelPicture.layer.masksToBounds = true
        
}
    
    
    // set up the information from the Table View Controller (PointsDescriptionTableViewController)
    func setUp(title: String, channelPicture: String, website: String, id: String, indexOfRow: Int, tableView: FavouriteChannelsListTableViewController! = nil) {
        if tableView != nil {
            self.variableTableView = tableView
        }
        self.nameLabel.adjustsFontSizeToFitWidth = true
        self.nameLabel.text = title
        self.pictureString = channelPicture
        self.websiteURLLabel.text = website
        self.id = id
        self.indexOfRow = indexOfRow
        if let imageData: NSData = NSData(contentsOf: URL(string: self.pictureString)!) {

        self.channelPicture.image = UIImage(data: imageData as Data)
        }
    }
    // end
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBAction func removeFromFavouriteChannelsList(_ sender: Any) {
        if self.currentUser.array(forKey: "arrayOfFavoriteChannels") != nil {
            self.arrayOfFavouriteChannels = self.currentUser.array(forKey: "arrayOfFavoriteChannels") as! [[String : String]]
             self.favouriteChannelsArray = (currentUser.array(forKey: "favouriteChannelsArray") as? [String])!
        }
      
        self.arrayOfFavouriteChannels.remove(at: self.indexOfRow)
        self.favouriteChannelsArray.remove(at: self.indexOfRow)
        self.currentUser.set(self.arrayOfFavouriteChannels, forKey: "arrayOfFavoriteChannels")
        self.currentUser.set(self.favouriteChannelsArray, forKey: "favouriteChannelsArray")
        self.variableTableView.arrayOfFavouriteChannels = self.arrayOfFavouriteChannels
        self.variableTableView.tableView.reloadData()
            }
    
    @IBAction func visitWebsiteAction(_ sender: Any) {
        VisitWebsiteNSObject().visitWebsiteAndBackToApp(websiteURL: self.websiteURLLabel.text!)
    }


}

