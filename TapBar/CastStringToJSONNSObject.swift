//
//  CastStringToJSONNSObject.swift
//  TapBar
//
//  Created by Azinec LLC on 6/6/17.
//  Copyright © 2017 Azinec LLC. All rights reserved.
//

import UIKit
import SwiftyJSON
class CastStringToJSONNSObject: NSObject {
    
    // cast String to JSON
    func stringToJSON(_ jsonString:String) -> JSON {
        do {
            if let data:Data = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false){
                if jsonString != "error" {
                    let jsonResult:JSON = JSON(data: data)
                    return jsonResult
                }
            }
        }
        catch _ as NSError {
            
        }
        
        return nil
    }
    // end
}
