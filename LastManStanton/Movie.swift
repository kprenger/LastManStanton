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
    var job: String?
    
    required init(_ map: Map) {
        
    }
    
    init () {
        
    }
    
    init (dummyMovie: Bool) {
        if (dummyMovie) {
            title = Constants.dummyMovieTitle
        }
    }
    
    func mapping(map: Map) {
        character <- map["character"]
        id <- map["id"]
        title <- map["title"]
        originalTitle <- map["original_title"]
        releaseDate <- (map["release_date"], Constants.dateTransform)
        posterImagePath <- map["poster_path"]
        job <- map["job"]
    }
    
}
