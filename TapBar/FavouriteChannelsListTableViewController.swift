//
//  FavouriteChannelsListTableViewController.swift
//  TapBar
//
//  Created by Azinec LLC on 5/29/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit

class FavouriteChannelsListTableViewController: UITableViewController {
    var arrayOfFavouriteChannels: [[String:String]] = []
    var id: String = "-3"
    var indexOfRow: Int = -2
    let currentUser = UserDefaults.standard
    var idOfSelectedChannel: String = "-2"
    var timer:Timer! = nil

    @IBOutlet weak var progressView: UIProgressView!
    
    
    @IBOutlet weak var sortingFromAToZ: UIBarButtonItem!
    
    @IBOutlet weak var sortingFromZToAButton: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 92.0
       self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(FavouriteChannelsListTableViewController.updateProgressView), userInfo: nil, repeats: true)
        timer.fire()
        progressView.setProgress(0, animated: true)
        if currentUser.array(forKey: "arrayOfFavoriteChannels") != nil {
            self.arrayOfFavouriteChannels = self.currentUser.array(forKey: "arrayOfFavoriteChannels") as! [[String : String]]
        }
        self.progressView.progress = 1
               }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.activityIndicator.startAnimating()

        if currentUser.array(forKey: "arrayOfFavoriteChannels") != nil {
            self.arrayOfFavouriteChannels = self.currentUser.array(forKey: "arrayOfFavoriteChannels") as! [[String : String]]
        }
        self.activityIndicator.stopAnimating()

        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrayOfFavouriteChannels.count != 0 {
            return self.arrayOfFavouriteChannels.count
            
        } else {
            return 0
        }
    }
    
    func updateProgressView(){
        self.progressView.updateProgressView()
        if self.progressView.progress == 1 {
            self.progressView.isHidden = true
        }
        
    }
    
    @IBAction func sortFromAToZ(_ sender: Any) {
        self.arrayOfFavouriteChannels = self.arrayOfFavouriteChannels.sorted {$0["name"]! < $1["name"]!}
        self.tableView.reloadData()
        
    }
    
    @IBAction func sortFromZToA(_ sender: Any) {
        self.arrayOfFavouriteChannels = self.arrayOfFavouriteChannels.sorted {$0["name"]! > $1["name"]!}
        self.tableView.reloadData()
    }
    
    // select a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.arrayOfFavouriteChannels.count != 0 {
            self.idOfSelectedChannel = self.arrayOfFavouriteChannels[indexPath.row]["id"]!
        }
        self.performSegue(withIdentifier: "fromFavouriteTableVCToProgramsTableVC", sender: self)
    }
    // end
    
    
    // prepare for seques to ProgramsTableVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromFavouriteTableVCToProgramsTableVC" {
            let destination = segue.destination as! ProgramsTableViewController
            destination.id = self.idOfSelectedChannel
        }
    }
    // end
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteChannelsCell", for: indexPath) as! FavouriteChannelsTableViewCell
        if self.arrayOfFavouriteChannels.count != 0 {
            cell.setUp(title: self.arrayOfFavouriteChannels[indexPath.row]["name"]!, channelPicture: self.arrayOfFavouriteChannels[indexPath.row]["picture"]!, website: self.arrayOfFavouriteChannels[indexPath.row]["url"]!, id: self.arrayOfFavouriteChannels[indexPath.row]["id"]!, indexOfRow: indexPath.row, tableView: self)
            
        }
        return cell
    }
    
}





