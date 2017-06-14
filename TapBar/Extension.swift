//
//  File.swift
//  TapBar
//
//  Created by Azinec LLC on 6/1/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    var millisecondsSince1970:Int {
        return Int(self.timeIntervalSince1970)
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}

extension UIProgressView {
    
    
    func updateProgressView() {
        if self.progress != 1 {
            self.setProgress(self.progress + 0.1, animated: true)
            
        } else {
            self.isHidden = true
        }
    }
    
    
}

extension UIRefreshControl {
    
    func setRefreshControl() {
        self.attributedTitle = NSAttributedString(string: "Pull to refresh")
    }
}

extension UIDatePicker {
    func setRanges() {
    self.minimumDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
    
   self.maximumDate = Calendar.current.date(byAdding: .day, value: +30, to: Date())
}
}
