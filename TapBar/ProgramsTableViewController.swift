//
//  ProgramsTableViewController.swift
//  TapBar
//
//  Created by Azinec LLC on 5/26/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProgramsTableViewController: UITableViewController, UITextFieldDelegate {
    var refresher: UIRefreshControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var timer:Timer! = nil
    
    var array: [[String:String]] = []
    var numberOfPrograms: Int = 0
    var id: String = "-2"
    var dictionaryOfProgramsOfSelectedChannel: [[String: String]] = []
    var currentUser = UserDefaults.standard
    var titleOfChannelsArray: [String] = []
    var jsonFromProgramsArray: JSON = []
    var dateReceivedFromDatePicker: String = ""
    var mili: Int64 = 0
    var dictionaryOfRandomChannel: [[String: String]] = []
    var currentDate: String = ""
    var globalPicker:UIDatePicker! = nil
    let randomNum:Int = Int(arc4random_uniform(135) + 1)// range is 0 to 135 + 1 = 1 ...136
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var selectedDateTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var lastSynchronizationDate: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedDateTextField.delegate = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0,y: 0,width: self.view.frame.size.width,height: 44))
        
        let spaceButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self , action: #selector(self.cancelChanges))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let barButtonDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.valueChangedInDateField))
        
        toolBar.items = [spaceButton, flexibleSpace, barButtonDone]
        self.selectedDateTextField.inputAccessoryView = toolBar
        self.activityIndicator.hidesWhenStopped = true
        refresher = UIRefreshControl()
        refresher.setRefreshControl()
        refresher.addTarget(self, action: #selector(ProgramsTableViewController.updateDataWithRefreshControl), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refresher)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        progressView.setProgress(0, animated: false)
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateProgress), userInfo: progressView, repeats: true)
        timer.fire()
        if self.currentUser.array(forKey: "arrayOfChannelsTitleForProgramsTVC") == nil {
            RestRequests().getChannelsList { (response) in
                for i in 0..<response.count {
                    self.titleOfChannelsArray.insert(response[i]["name"].stringValue, at: self.titleOfChannelsArray.count)
                }
            }
        } else {
            self.titleOfChannelsArray = self.currentUser.array(forKey: "arrayOfChannelsTitleForProgramsTVC") as! [String]
        }
        globalReloadtable()
        self.tableView.reloadData()
        
    }
    
    
    
    func globalReloadtable() {
        if self.selectedDateTextField.text != "" {
            self.currentUser.set("\(self.selectedDateTextField.text!)", forKey: "dateTextFieldText")
        }
        self.mili = AdditionalToProgramsTableViewController().gettingTimeInMillisecionds(dateReceivedFromDatePicker: self.dateReceivedFromDatePicker)
        if self.currentUser.string(forKey: "databaseOfDates") != nil {
            if !self.currentUser.bool(forKey: "isRefreshed") && (self.currentUser.string(forKey: "dateTextFieldText")! == self.currentUser.string(forKey: "databaseOfDates")! || self.selectedDateTextField.text! == "") {
                let result = AdditionalToProgramsTableViewController().settingsForProgramsTVC(dateReceivedFromDatePicker: self.dateReceivedFromDatePicker, id: self.id, randomNum: self.randomNum)
                self.dictionaryOfProgramsOfSelectedChannel = result.0
                self.dictionaryOfRandomChannel = result.1
                self.selectedDateTextField.text = result.2
                self.lastSynchronizationDate.text = result.3
                AdditionalToProgramsTableViewController().activityIndicatorStopping(activityIndicator: self.activityIndicator, progressView: self.progressView)
                self.tableView.reloadData()
            }
        }
        if self.currentUser.string(forKey: "databaseOfDates") == nil || DataMilliseconds().castNSDateToStringWithTextFieldFormat() != self.currentUser.string(forKey: "dateTextFieldText")! || self.currentUser.bool(forKey: "isRefreshed") {
            self.currentUser.set(false, forKey: "isRefreshed")
            self.dictionaryOfProgramsOfSelectedChannel.removeAll()
            self.dictionaryOfRandomChannel.removeAll()
            self.activityIndicator.startAnimating()
            RestRequests().getProgramsTimeList(timestamp: mili ) { (response) in
                let realizer = GettingResponsefromServerForProgramsTVC().getResponse(response: response, id: self.id, randomNum: self.randomNum)
                self.numberOfPrograms = realizer.0
                self.dictionaryOfProgramsOfSelectedChannel = realizer.1
                self.dictionaryOfRandomChannel = realizer.2
                self.selectedDateTextField.text = realizer.3
                self.lastSynchronizationDate.text = realizer.4
                AdditionalToProgramsTableViewController().activityIndicatorStopping(activityIndicator: self.activityIndicator, progressView: self.progressView)
                self.tableView.reloadData()
            }
        }
        
    }
    
    func updateProgress() {
        self.progressView.updateProgressView()
        if self.progressView.progress == 1 {
            self.progressView.isHidden = true
        }
    }
    
    
    func valueChangedInDateField() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        selectedDateTextField.text = formatter.string(from: globalPicker.date)
        self.dateReceivedFromDatePicker = self.selectedDateTextField.text!
        
        self.selectedDateTextField.resignFirstResponder()
        globalReloadtable()
        self.tableView.reloadData()
        
    }
    
    func cancelChanges() {
        self.selectedDateTextField.text = self.currentUser.string(forKey: "currentDate")
        self.selectedDateTextField.resignFirstResponder()
    }
    
    
    func updateDataWithRefreshControl() {
        self.currentUser.set(true, forKey: "isRefreshed")
        globalReloadtable()
        self.tableView.reloadData()
        self.refresher.endRefreshing()
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.setRanges()
        textField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(self.datePickerChanged(sender:)), for: .valueChanged)
        self.globalPicker = datePicker
    }
    
    
    func datePickerChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        selectedDateTextField.text = formatter.string(from: sender.date)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.dictionaryOfProgramsOfSelectedChannel.count == 0 && self.titleOfChannelsArray.count != 0 {
            return "Teleprograms of Channel: \(self.titleOfChannelsArray[self.randomNum - 1])"
        }
        if self.dictionaryOfProgramsOfSelectedChannel.count != 0 && self.titleOfChannelsArray.count != 0 {
            return "Teleprograms of Channel: \(self.titleOfChannelsArray[Int(self.id)! - 1])"
        } else {
            return ""
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dictionaryOfProgramsOfSelectedChannel.count == 0 {
            return self.dictionaryOfRandomChannel.count
        } else {
            return self.dictionaryOfProgramsOfSelectedChannel.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "programsCell", for: indexPath) as! ProgramsTableViewCell
        if self.dictionaryOfProgramsOfSelectedChannel.count == 0 {
            cell.setUp(title: self.dictionaryOfRandomChannel[indexPath.row]["title"]!, time: dictionaryOfRandomChannel[indexPath.row]["time"]!)
        } else {
            cell.setUp(title: self.dictionaryOfProgramsOfSelectedChannel[indexPath.row]["title"]!, time: self.dictionaryOfProgramsOfSelectedChannel[indexPath.row]["time"]!)
        }
        return cell
    }
    
    
}





