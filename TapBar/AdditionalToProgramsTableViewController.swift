//
//  AdditionalToProgramsTableViewController.swift
//  TapBar
//
//  Created by Azinec LLC on 6/2/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit


class AdditionalToProgramsTableViewController: NSObject {
    var currentUser = UserDefaults.standard
    
    
    func settingsForProgramsTVC(dateReceivedFromDatePicker: String, id: String, randomNum: Int) -> ([[String:String]], [[String:String]], String?, String?) {
        var dictionaryOfProgramsOfSelectedChannel: [[String:String]] = []
        var dictionaryOfRandomChannel: [[String:String]] = []
        var textOfselectedDateTextField: String? = ""
        var lastSynchronizationDate: String? = ""
        let responsesArray: String = self.currentUser.string(forKey: "databaseOfResponses")!
        let response = CastStringToJSONNSObject().stringToJSON(responsesArray)
        for i in 0..<response.count {
            if id == response[i]["channel_id"].stringValue {
                dictionaryOfProgramsOfSelectedChannel.append(["id": response[i]["channel_id"].stringValue, "title": response[i]["title"].stringValue, "time": response[i]["time"].stringValue, "date": response[i]["date"].stringValue])
            }
            if id == "-2" && randomNum == Int(response[i]["channel_id"].stringValue) {
                dictionaryOfRandomChannel.append(["id": response[i]["channel_id"].stringValue, "title": response[i]["title"].stringValue, "time": response[i]["time"].stringValue, "date": response[i]["date"].stringValue])
            }
        }
        if dictionaryOfProgramsOfSelectedChannel.count != 0 {
            textOfselectedDateTextField = dictionaryOfProgramsOfSelectedChannel[0]["date"]
        } else {
            textOfselectedDateTextField = dictionaryOfRandomChannel[0]["date"]
        }
        
        
        if self.currentUser.string(forKey: "lastSynchronizationWithHours") != nil {
            lastSynchronizationDate = self.currentUser.string(forKey: "lastSynchronizationWithHours")
        }
        self.currentUser.set(textOfselectedDateTextField!, forKey: "currentDate")
        
        return (dictionaryOfProgramsOfSelectedChannel, dictionaryOfRandomChannel, textOfselectedDateTextField,  lastSynchronizationDate)
    }
    
    
    
    
    
    func gettingTimeInMillisecionds(dateReceivedFromDatePicker: String) -> Int64 {
        var mili: Int64 = 0
        if self.currentUser.string(forKey: "databaseOfDates") != nil {
            if dateReceivedFromDatePicker != "" && dateReceivedFromDatePicker != self.currentUser.string(forKey: "databaseOfDates")! {
                mili = DataMilliseconds().selectedTimeMillis(selectedDate: dateReceivedFromDatePicker)
            } else {
                mili = DataMilliseconds().currentTimeMillis()
            }
            if dateReceivedFromDatePicker == self.currentUser.string(forKey: "databaseOfDates")! {
                mili = DataMilliseconds().currentTimeMillis()
            }
        } else {
            mili = DataMilliseconds().currentTimeMillis()
        }
        return mili
    }
    
    
    
    func activityIndicatorStopping(activityIndicator: UIActivityIndicatorView, progressView: UIProgressView) {
        activityIndicator.stopAnimating()
        if activityIndicator.isAnimating == false {
            progressView.progress = 1
        }
        
    }
}

