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
    var birthday: Date?
    var deathday: Date?
    var birthPlace: String?
    var popularity: Float?
    var knownFor: [Movie]?
    
    required init(map: Map) {
        
    }
    
    init () {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        biography <- map["biography"]
        profileImagePath <- map["profile_path"]
        birthday <- (map["birthday"], Constants.dateTransform)
        deathday <- (map["deathday"], Constants.dateTransform)
        birthPlace <- map["place_of_birth"]
        popularity <- map["popularity"]
        knownFor <- map["known_for"]
    }
    
}

class PersonMovieCredits: Mappable {
    
    var cast: [Movie]?
    var crew: [Movie]?
    var id: String?
    
    required init(map: Map) {
        
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
    
    required init(map: Map) {
        
    }
    
    func mapping(map: Map) {
        page <- map["page"]
        totalPages <- map["total_pages"]
        totalResults <- map["total_results"]
        results <- map["results"]
    }
    
}
