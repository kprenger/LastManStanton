//
//  Movie.swift
//  LastManStanton
//
//  Created by Kurt Prenger on 11/11/15.
//  Copyright © 2015 My Tiny Sandbox. All rights reserved.
//

import UIKit
import ObjectMapper

class Movie: Mappable {
    
    var character: String?
    var id: Int?
    var title: String?
    var originalTitle: String?
    var releaseDate: NSDate?
    var posterImagePath: String?
    
    required init(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        let dateTransform = TransformOf<NSDate, String>(fromJSON: { (value: String?) -> NSDate? in
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
        
        character <- map["character"]
        id <- map["id"]
        title <- map["title"]
        originalTitle <- map["original_title"]
        releaseDate <- (map["release_date"], dateTransform)
        posterImagePath <- map["poster_path"]
    }
    
}
