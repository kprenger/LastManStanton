//
//  Constants.swift
//  LastManStanton
//
//  Created by Kurt Prenger on 12/2/15.
//  Copyright © 2015 My Tiny Sandbox. All rights reserved.
//

import UIKit
import ObjectMapper

class Constants: NSObject {

    static let numberOfPlayersString = "numberOfPlayers"
    static let guessTimeLimitString = "guessTimeLimit"
    static let fuzzySearchLevelString = "fuzzySearchLevel"
    static let dummyMovieTitle = "ThisIsADummyMovieNotToBeUsed"
    
    static let dateTransform = TransformOf<NSDate, String>(fromJSON: { (value: String?) -> NSDate? in
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let value = value {
            return dateFormatter.dateFromString(value)
        }
        return nil
        }, toJSON: { (value: NSDate?) -> String? in
            if let value = value {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                return dateFormatter.stringFromDate(value)
            }
            return nil
    })
}
