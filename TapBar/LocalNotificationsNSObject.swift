//
//  LocalNotificationsNSObject.swift
//  TapBar
//
//  Created by Azinec LLC on 6/1/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import UserNotifications

class LocalNotificationsNSObject: NSObject {
    let localNotification = UILocalNotification()
    
    
    
    func reloadProgramsTimeList(hour: Int, minute: Int) {
        let calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var dateFire = Date()
        
        var fireComponents=(calendar as NSCalendar).components([.day, .month, .year, .hour, .minute] , from:dateFire)
        
        fireComponents.hour = hour
        fireComponents.minute = minute
        
        dateFire = calendar.date(from: fireComponents)!
        
        let localNotification = UILocalNotification()
        
        localNotification.userInfo = ["syncMyData": true]
        localNotification.fireDate = dateFire
        localNotification.alertBody = "Your datebase of teleprograms was successfully updated"
        localNotification.repeatInterval = .day
        localNotification.soundName   = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }   
    
    
}
