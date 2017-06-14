//
//  DataMilliseconds.swift
//  TapBar
//
//  Created by Azinec LLC on 6/1/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit

class DataMilliseconds: NSObject {
    func currentTimeMillis() -> Int64{
        let nowDouble = NSDate().timeIntervalSince1970
        return Int64(nowDouble)
    }
    
    
    func selectedTimeMillis(selectedDate: String) -> Int64{
        let dateStr = selectedDate
        
        // Set date format
        let dateFmt = DateFormatter()
        dateFmt.timeZone = NSTimeZone.local
        dateFmt.calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian) as Calendar!
        dateFmt.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone!
        dateFmt.dateFormat =  "dd/MM/yyyy"
        
        // Get NSDate for the given string
        let date: Date = dateFmt.date(from: dateStr)!
        return  Int64(date.millisecondsSince1970)//Int64(nowDouble*1000)
    }

    func castNSDateToString() -> String {
        let today = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentData:String = dateFormatter.string(from: today as Date)
    return currentData

}
    
    func castNSDateToStringWithTextFieldFormat() -> String {
        let today = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let currentData:String = dateFormatter.string(from: today as Date)
        return currentData
    }
    
    
    func formatForSyncLabel() -> String {
        let today = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy    HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.local
        let currentData = dateFormatter.string(from: today as Date)
return currentData
    }
}
