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
    
    static let dateTransform = TransformOf<Date, String>(fromJSON: { (value: String?) -> Date? in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let value = value {
            return dateFormatter.date(from: value)
        }
        return nil
        }, toJSON: { (value: Date?) -> String? in
            if let value = value {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                return dateFormatter.string(from: value)
            }
            return nil
    })
}
