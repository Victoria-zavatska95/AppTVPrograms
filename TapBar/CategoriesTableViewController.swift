//
//  CategoriesTableViewController.swift
//  TapBar
//
//  Created by Azinec LLC on 5/29/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import SwiftyJSON
class CategoriesTableViewController: UITableViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var array: [String] = []
    var selectedCategorySecond: Int = -3
    var numberOfCategories: Int = 0
    var jsonFromCategoriesArray: JSON = []
    @IBOutlet weak var progressView: UIProgressView!
    
    
    
    var currentUser = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 92.0
        activityIndicator.startAnimating()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CategoriesTableViewController.updateProgressView), userInfo: nil, repeats: true)
        progressView.setProgress(0, animated: true)
        RestRequests().getCategoriesList { (response) in
            let categoriesArray: String = self.currentUser.string(forKey: "categoriesName")!
            self.jsonFromCategoriesArray = CastStringToJSONNSObject().stringToJSON(categoriesArray)
            self.numberOfCategories = self.jsonFromCategoriesArray.count
           AdditionalToProgramsTableViewController().activityIndicatorStopping(activityIndicator: self.activityIndicator, progressView: self.progressView)
            self.tableView.reloadData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.navigationController?.isNavigationBarHidden = false
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
        return self.numberOfCategories
        
    }
    
    // select a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCategorySecond = indexPath.row + 1
        self.performSegue(withIdentifier: "fromCategoryTVCToChannelsTVC", sender: self)
    }
    // end
    
    func updateProgressView() {
        self.progressView.updateProgressView()
        if self.progressView.progress == 1 {
            self.progressView.isHidden = true
        }

           }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesCell", for: indexPath) as! UniversalTableViewCell
        cell.setUp(title: self.jsonFromCategoriesArray[indexPath.row]["title"].stringValue, pictureString: self.jsonFromCategoriesArray[indexPath.row]["picture"].stringValue)
        cell.pictureString = self.jsonFromCategoriesArray[indexPath.row]["picture"].stringValue
        
        return cell
    }
    
    
    // prepare for seques to DetailedDescriptionViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromCategoryTVCToChannelsTVC" {
            let destination = segue.destination as! ChannelsTableViewController
            destination.selectedChannelId = "\(self.selectedCategorySecond)"
        }
    }
    // end
    
}


