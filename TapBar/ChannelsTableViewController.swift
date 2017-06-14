//
//  ChannelsTableViewController.swift
//  TapBar
//
//  Created by Azinec LLC on 5/26/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChannelsTableViewController: UITableViewController {
        var refresher: UIRefreshControl!
    var array: [[String:String]] = []
    var notSelectedArray: [[String:String]] = []
    var currentUser = UserDefaults.standard
    var selectedChannelId: String = "-2"
    var numberOfChannels: Int = -2
    var arrayOfTitlesOfChannels: [String] = []
     var favouriteChannelsArray: [String] = []
    var idOfSelectedChannel: String = "-2"
    var arrayOfChannelsTitleForProgramsTVC: [String] = []
    var timer:Timer! = nil

    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentSize.height = 92.0
        tableView.rowHeight = 92.0
        activityIndicator.startAnimating()
        progressView.setProgress(0, animated: false)
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateProgressView), userInfo: progressView, repeats: true)
        timer.fire()
        RestRequests().getChannelsList { (response) in
            for i in 0..<response.count {
                self.arrayOfChannelsTitleForProgramsTVC.append(response[i]["name"].stringValue)
                         if self.selectedChannelId == response[i]["category_id"].stringValue {
                    self.array.append(["name": response[i]["name"].stringValue, "url": response[i]["url"].stringValue, "picture": response[i]["picture"].stringValue, "category_id": response[i]["category_id"].stringValue, "id": response[i]["id"].stringValue])
                }else {
                    self.notSelectedArray.append(["name": response[i]["name"].stringValue, "url": response[i]["url"].stringValue, "picture": response[i]["picture"].stringValue, "category_id": response[i]["category_id"].stringValue, "id": response[i]["id"].stringValue])
                }
            }
            self.currentUser.set(self.arrayOfChannelsTitleForProgramsTVC, forKey: "arrayOfChannelsTitleForProgramsTVC")

            self.numberOfChannels = response.count
              self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
            
        }
        self.progressView.progress = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.currentUser.array(forKey: "arrayOfFavoriteChannels") != nil {
            self.favouriteChannelsArray = self.currentUser.array(forKey: "favouriteChannelsArray") as! [String]
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateProgressView(){
        self.progressView.updateProgressView()
        if self.progressView.progress == 1 {
            self.progressView.isHidden = true
        }

    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.array.count == 0 {
            return numberOfChannels
        } else {
            return self.array.count
        }
    }
    
    // select a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.array.count != 0 {
            self.idOfSelectedChannel = self.array[indexPath.row]["id"]!
        } else {
            self.idOfSelectedChannel = self.notSelectedArray[indexPath.row]["id"]!
        }
        self.performSegue(withIdentifier: "fromChannelsTableVCToProgramsTableVC", sender: self)
    }
    // end
    
    
    // prepare for seques to DetailedDescriptionViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromChannelsTableVCToProgramsTableVC" {
            
            let destination = segue.destination as! ProgramsTableViewController
            destination.id = self.idOfSelectedChannel
        }
    }
    // end
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "channelsCell", for: indexPath) as! ChannelsTableViewCell
        
        if self.array.count == 0 {
            let channelsArray: String = self.currentUser.string(forKey: "channelsName")!
            let jsonFromChannelsArray: JSON = CastStringToJSONNSObject().stringToJSON(channelsArray)
            
            cell.setUp(name: jsonFromChannelsArray[indexPath.row]["name"].stringValue, websiteURL: jsonFromChannelsArray[indexPath.row]["url"].stringValue, pictureString: jsonFromChannelsArray[indexPath.row]["picture"].stringValue)
            
            cell.id = jsonFromChannelsArray[indexPath.row]["id"].stringValue
            cell.pictureString = jsonFromChannelsArray[indexPath.row]["picture"].stringValue
            if currentUser.array(forKey: "favouriteChannelsArray") != nil{
                cell.favouriteChannelsArray = (currentUser.array(forKey: "favouriteChannelsArray") as? [String])!
            }
        } else {
            
            cell.setUp(name: self.array[indexPath.row]["name"]!, websiteURL: self.array[indexPath.row]["url"]!, pictureString: self.array[indexPath.row]["picture"]!)
            cell.id = self.array[indexPath.row]["id"]!
            cell.pictureString = self.array[indexPath.row]["picture"]!
            
        }
        
        if self.favouriteChannelsArray.index(of: cell.id) != nil {
            cell.addToFavouriteButton.isHidden = true
            cell.removeFromFavouriteListButton.isHidden = false
             cell.removeFromFavouriteListButton.isEnabled = true
        } else {
            cell.addToFavouriteButton.isHidden = false
            cell.addToFavouriteButton.isEnabled = true
            cell.removeFromFavouriteListButton.isHidden = true
        }
        
        return cell
    }
    
    
}










