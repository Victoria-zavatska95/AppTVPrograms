//
//  ChannelsTableViewCell.swift
//  TapBar
//
//  Created by Azinec LLC on 5/29/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChannelsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var websiteURLLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var viewForImage: UIView!
    
    @IBOutlet weak var channelPicture: UIImageView!
    
    @IBOutlet weak var addToFavouriteButton: UIButton!
    
    @IBOutlet weak var visitWebsiteButton: UIButton!

var arrayOfFavoriteChannels: [[String:String]] = []
     var favouriteChannelsArray: [String] = []
    var jsonOfChannels: JSON = []

var pictureString: String = ""
var id: String = "-3"
var arrayOfId: [String] = []
    var currentUser = UserDefaults.standard
 
    @IBOutlet weak var removeFromFavouriteListButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        let channelsArray: String = self.currentUser.string(forKey: "channelsName")!
        self.jsonOfChannels = CastStringToJSONNSObject().stringToJSON(channelsArray)
        self.removeFromFavouriteListButton.isEnabled = false
        self.removeFromFavouriteListButton.isHidden = true
        self.viewForImage.layer.borderWidth = 2.0
        self.viewForImage.layer.borderColor = UIColor(white: 1, alpha: 0.4).cgColor
        self.channelPicture.layer.masksToBounds = true
        self.visitWebsiteButton.layer.borderColor = UIColor(white: 1, alpha: 0.4).cgColor
        self.channelPicture.layer.masksToBounds = true
        
    }
    
    
    func setUp (name: String, websiteURL : String, pictureString : String) {
        
        self.nameLabel.text = name
        self.websiteURLLabel.text = websiteURL
        
        if let imageData: NSData = NSData(contentsOf: URL(string: pictureString)!) {
            self.channelPicture.image = UIImage(data: imageData as Data)
        }
            }


    @IBAction func addToFavouriteListButton(_ sender: Any) {
        self.addToFavouriteButton.isEnabled = false
        self.addToFavouriteButton.isHidden = true
        for i in 0..<self.jsonOfChannels.count {
            if self.id == self.jsonOfChannels[i]["id"].stringValue {
                if currentUser.array(forKey: "favouriteChannelsArray") != nil{
                    
                    self.favouriteChannelsArray = (currentUser.array(forKey: "favouriteChannelsArray") as? [String])!
                    self.arrayOfFavoriteChannels = (currentUser.array(forKey: "arrayOfFavoriteChannels") as! [[String : String]])
                }
                
                self.favouriteChannelsArray.insert(self.id, at: 0)
                self.arrayOfFavoriteChannels.insert(["name": self.nameLabel.text!, "url": self.websiteURLLabel.text!, "picture": self.pictureString, "id": self.id], at: 0)
                self.currentUser.set(self.favouriteChannelsArray, forKey: "favouriteChannelsArray")
                self.currentUser.set(self.arrayOfFavoriteChannels, forKey: "arrayOfFavoriteChannels")
                
                self.addToFavouriteButton.isEnabled = true
                self.removeFromFavouriteListButton.isEnabled = true
                self.removeFromFavouriteListButton.isHidden = false
            }
        }
        

    }
    
    @IBAction func removeFromfavouriteListAction(_ sender: Any) {
        self.removeFromFavouriteListButton.isEnabled = false
        self.removeFromFavouriteListButton.isHidden = true
        
        
        
        self.favouriteChannelsArray = (currentUser.array(forKey: "favouriteChannelsArray") as? [String])!
        self.arrayOfFavoriteChannels = (currentUser.array(forKey: "arrayOfFavoriteChannels") as! [[String : String]])
        let index = self.favouriteChannelsArray.index(of: self.id)!
        self.favouriteChannelsArray.remove(at: index)
        self.arrayOfFavoriteChannels.remove(at: index)
        self.currentUser.set(self.favouriteChannelsArray, forKey: "favouriteChannelsArray")
        self.currentUser.set(self.arrayOfFavoriteChannels, forKey: "arrayOfFavoriteChannels")
        
        self.removeFromFavouriteListButton.isEnabled = true
        self.addToFavouriteButton.isEnabled = true
        self.addToFavouriteButton.isHidden = false
        
    }
    
    @IBAction func visitWebsite(_ sender: Any) {
        VisitWebsiteNSObject().visitWebsiteAndBackToApp(websiteURL: self.websiteURLLabel.text!)
    }


override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
}

}

