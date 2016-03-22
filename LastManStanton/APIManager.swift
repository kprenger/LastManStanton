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
    let plist = NSBundle.mainBundle().infoDictionary
    
    let host = "https://api.themoviedb.org/"
    let apiVersion = "3"
    let personRoute = "/person/"
    let searchRoute = "/search/"
    
    var apiKey: String
    
    override init() {
        apiKey = plist!["tmdbAPIKey"] as! String
    }
    
    func getMoviesForPerson(personID: Int, completion: (movieArray: NSArray) -> Void) {
        let URL = host + apiVersion + personRoute + String(personID) + "/movie_credits"
        
        Alamofire.request(.GET, URL, parameters: ["api_key": apiKey])
            .responseObject{(response: Response<PersonMovieCredits, NSError>) in
                
                var movieArray = [Movie]()
                
                if let person = response.result.value {
                    movieArray.appendContentsOf(person.cast!)
                    movieArray.appendContentsOf(person.crew!.filter({$0.job == "Director"}))
                    
                    movieArray = Array(Set<Movie>(movieArray))
                }
                
                //Only return movies that have been released
                //
                completion(movieArray: movieArray.filter({$0.releaseDate?.compare(NSDate()) != NSComparisonResult.OrderedDescending}))
        }
    }
    
    func getPersonFromQuery(nameSearch: String, completion: (personArray: NSArray) -> Void) {
        let URL = host + apiVersion + searchRoute + "person"
        
        Alamofire.request(.GET, URL, parameters: ["query": nameSearch, "api_key": apiKey])
            .responseObject{(response: Response<PersonSearchResult, NSError>) in
                
                var personArray = [Person]()
                
                if let searchResult = response.result.value {
                    if let results = searchResult.results {
                        personArray = self.filterPersonResults(results) as! [Person]
                    }
                }
                
                completion(personArray: personArray)
        }
    }
    
    func getPopularPersons(completion: (personArray: NSArray) -> Void) {
        let URL = host + apiVersion + personRoute + "popular"
        
        Alamofire.request(.GET, URL, parameters: ["api_key": apiKey])
            .responseObject{(response: Response<PersonSearchResult, NSError>) in
                
                var personArray = [Person]()
                
                if let searchResult = response.result.value {
                    if let results = searchResult.results {
                        personArray = self.filterPersonResults(results) as! [Person]
                    }
                }
                
                completion(personArray: personArray)
        }
    }
    
    func filterPersonResults(resultArray: [Person]) -> NSArray {
        let personsThatAreKnown = resultArray.filter({ $0.knownFor?.count > 2 })
        return personsThatAreKnown.filter({ $0.knownFor?.filter({ $0.mediaType == "movie" }).count > 0 })
    }
}
