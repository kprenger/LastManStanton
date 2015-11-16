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
