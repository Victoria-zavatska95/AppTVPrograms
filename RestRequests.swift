//
//  RestRequests.swift
//  TapBar
//
//  Created by Azinec LLC on 5/25/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class RestRequests: NSObject {
    let url = "http://52.50.138.211:"
    let port = "8080/ChanelAPI/"
    var currentUser = UserDefaults.standard
    var array: [String] = []
    var currentDate: String = ""

    
    
    func getChannelsList(completitionHandler: @escaping (_ json: JSON) -> ()){
        
        Alamofire.request("\(url)\(port)chanels", method: .get).responseJSON { (response) in
            let json = JSON(response.data)
             self.currentUser.set("\(json)", forKey: "channelsName")
            completitionHandler(json)
        }
    }
    //end
    func getCategoriesList(completitionHandler: @escaping (_ json: JSON) -> ()) {
        Alamofire.request("\(url)\(port)categories", method: .get).responseJSON { (response) in
            let json = JSON(response.data)
            self.currentUser.set("\(json)", forKey: "categoriesName")
            completitionHandler(json)
        }
    }
    
    
    func getProgramsTimeList(timestamp: Int64, completitionHandler: @escaping (_ json: JSON) -> ()) {
        Alamofire.request("\(url)\(port)programs/\(timestamp)000", method: .get).responseJSON { (response) in
                 let json = JSON(response.data)
                self.currentDate = DataMilliseconds().castNSDateToStringWithTextFieldFormat()
            if self.currentUser.string(forKey: "databaseOfResponses") == nil {
                self.currentUser.set("\(json)", forKey: "databaseOfResponses")
self.currentUser.set("\(self.currentDate)", forKey: "databaseOfDates")
            } else {
//                if self.currentDate == self.currentUser.string(forKey: "dateTextFieldText")!{
//                  self.currentUser.set("\(json)", forKey: "databaseOfResponses")
//                    self.currentUser.set("\(self.currentDate)", forKey: "databaseOfDates")
//                }
            }
            completitionHandler(json)
        }           }
    
}

