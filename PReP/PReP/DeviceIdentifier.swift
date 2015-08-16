//
//  DeviceIdentifier.swift
//  PReP
//
//  Created by Kaelin D Hooper on 7/30/15.
//  Copyright (c) 2015 Kaelin D Hooper. All rights reserved.
//

import UIKit

class DeviceIdentifier: NSObject {
    
    class func iPad() -> Bool {
        var currentDeviceName: String = UIDevice.currentDevice().model
        if currentDeviceName.substringToIndex(advance(currentDeviceName.startIndex, 4)) == "iPad" {
            return true
        } else {
            return false
        }
    }
    
    class func iPhone() -> Bool {
        var currentDeviceName: String = UIDevice.currentDevice().model
        if currentDeviceName.substringToIndex(advance(currentDeviceName.startIndex, 6)) == "iPhone" {
            return true
        } else {
            return false
        }
    }
    
    class func iPod() -> Bool {
        var currentDeviceName: String = UIDevice.currentDevice().model
        if currentDeviceName.substringToIndex(advance(currentDeviceName.startIndex, 4)) == "iPod" {
            return true
        } else {
            return false
        }
    }
    
}
