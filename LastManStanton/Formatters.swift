//
//  Formatters.swift
//  LastManStanton
//
//  Created by Kurt Prenger on 12/3/15.
//  Copyright © 2015 My Tiny Sandbox. All rights reserved.
//

import UIKit

class Formatters: NSObject {
    
    class func timeFormat(_ time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        
        var minuteString = "00"
        var secondString = "00"
        
        if (minutes < 10) {
            minuteString = "0" + String(minutes)
        } else {
            minuteString = String(minutes)
        }
        
        if (seconds < 10) {
            secondString = "0" + String(seconds)
        } else {
            secondString = String(seconds)
        }
        
        return minuteString + ":" + secondString
    }
}
