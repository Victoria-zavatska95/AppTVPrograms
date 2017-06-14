//
//  GettingResponsefromServerForProgramsTVC.swift
//  TapBar
//
//  Created by Azinec LLC on 6/2/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import SwiftyJSON

class GettingResponsefromServerForProgramsTVC: NSObject {
    var currentUser = UserDefaults.standard
    
    func getResponse(response: JSON, id: String, randomNum: Int) -> (Int, [[String:String]], [[String:String]], String?, String?) {
        var numberOfPrograms: Int = 0
        var dictionaryOfProgramsOfSelectedChannel: [[String:String]] = []
        var dictionaryOfRandomChannel: [[String:String]] = []
        var selectedDateTextField: String? = ""
        var lastSynchronizationDate: String? = ""
        
        
        numberOfPrograms = response.count
        for i in 0..<response.count {
            if id == response[i]["channel_id"].stringValue {
                dictionaryOfProgramsOfSelectedChannel.append(["id": response[i]["channel_id"].stringValue, "title": response[i]["title"].stringValue, "time": response[i]["time"].stringValue, "date": response[i]["date"].stringValue])
            }
            if id == "-2" && randomNum == Int(response[i]["channel_id"].stringValue) {
                dictionaryOfRandomChannel.append(["id": response[i]["channel_id"].stringValue, "title": response[i]["title"].stringValue, "time": response[i]["time"].stringValue, "date": response[i]["date"].stringValue])
            }
        }
        if dictionaryOfProgramsOfSelectedChannel.count != 0 {
            selectedDateTextField = dictionaryOfProgramsOfSelectedChannel[0]["date"]
            self.currentUser.set("\(selectedDateTextField!)", forKey: "dateTextFieldText")
        } else {
            selectedDateTextField = dictionaryOfRandomChannel[0]["date"]
            self.currentUser.set("\(selectedDateTextField!)", forKey: "dateTextFieldText")
        }
        
        self.currentUser.set("\(DataMilliseconds().formatForSyncLabel())", forKey: "lastSynchronizationWithHours")
        lastSynchronizationDate = self.currentUser.string(forKey: "lastSynchronizationWithHours")!
        return (numberOfPrograms, dictionaryOfProgramsOfSelectedChannel, dictionaryOfRandomChannel, selectedDateTextField, lastSynchronizationDate)
    }
    
}
