//
//  VisitWebsiteNSObject.swift
//  TapBar
//
//  Created by Azinec LLC on 5/31/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit

class VisitWebsiteNSObject: NSObject {
    
    func visitWebsiteAndBackToApp(websiteURL: String) {
        if let url = NSURL(string: "\(websiteURL)") {
            UIApplication.shared.openURL(url as URL)
        }
    }
}
