//
//  APIManager.swift
//  LastManStanton
//
//  Created by Kurt Prenger on 11/11/15.
//  Copyright © 2015 My Tiny Sandbox. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class APIManager: NSObject {
    
    static let sharedInstance = APIManager()
    let host = "https://api.themoviedb.org/"
    let apiVersion = "3"
    let personRoute = "/person/"
    let plist = NSBundle.mainBundle().infoDictionary
    
    var apiKey: String
    
    override init() {
        apiKey = plist!["tmdbAPIKey"] as! String
    }

    func getMoviesForPerson(personID: Int, completion: (movieArray: NSArray) -> Void) {
        let URL = host + apiVersion + personRoute + String(personID) + "/movie_credits"
        
        Alamofire.request(.GET, URL, parameters: ["api_key": apiKey])
            .responseObject { (response: Response<Person, NSError>) in
                
                var movieArray = [Movie]()
                
                if let person = response.result.value {
                    movieArray = person.cast!
                }
                
                completion(movieArray: movieArray)
        }
    }
    
}
