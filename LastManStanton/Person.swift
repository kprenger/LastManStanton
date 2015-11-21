//
//  Person.swift
//  LastManStanton
//
//  Created by Kurt Prenger on 11/16/15.
//  Copyright © 2015 My Tiny Sandbox. All rights reserved.
//

import UIKit
import ObjectMapper

class Person: Mappable {
    
    var id: Int?
    var name: String?
    var biography: String?
    var profileImagePath: String?
    var birthday: NSDate?
    var deathday: NSDate?
    var birthPlace: String?
    var popularity: Float?
    
    required init(_ map: Map) {
        
    }
    
    init () {
        
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
        
        id <- map["id"]
        name <- map["name"]
        biography <- map["biography"]
        profileImagePath <- map["profile_path"]
        birthday <- (map["birthday"], dateTransform)
        deathday <- (map["deathday"], dateTransform)
        birthPlace <- map["place_of_birth"]
        popularity <- map["popularity"]
    }
    
}

class PersonMovieCredits: Mappable {
    
    var cast: [Movie]?
    var crew: [Movie]?
    var id: String?
    
    required init(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        cast <- map["cast"]
        crew <- map["crew"]
        id <- map["id"]
    }

}

class PersonSearchResult: Mappable {
    
    var page: Int?
    var totalPages: Int?
    var totalResults: Int?
    var results: [Person]?
    
    required init(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        page <- map["page"]
        totalPages <- map["total_pages"]
        totalResults <- map["total_results"]
        results <- map["results"]
    }
    
}
