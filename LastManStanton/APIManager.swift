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
    let plist = Bundle.main.infoDictionary
    
    let host = "https://api.themoviedb.org/"
    let apiVersion = "3"
    let personRoute = "/person/"
    let searchRoute = "/search/"
    
    var apiKey: String
    
    override init() {
        apiKey = plist!["tmdbAPIKey"] as! String
    }
    
    func getMoviesForPerson(_ personID: Int, completion: @escaping (_ movieArray: [Movie]) -> Void) {
        let URL = host + apiVersion + personRoute + String(personID) + "/movie_credits"
        
        Alamofire.request(URL, method: .get, parameters: ["api_key": apiKey])
            .responseObject{(response: DataResponse<PersonMovieCredits>) in
                
                var movieArray = [Movie]()
                
                if let person = response.result.value {
                    movieArray.append(contentsOf: person.cast!)
                    movieArray.append(contentsOf: person.crew!.filter({$0.job == "Director"}))
                    
                    movieArray = Array(Set<Movie>(movieArray))
                }
                
                //Only return movies that have been released
                //
                completion(movieArray.filter({$0.releaseDate?.compare(Date()) != ComparisonResult.orderedDescending}))
        }
    }
    
    func getPersonFromQuery(_ nameSearch: String, completion: @escaping (_ personArray: [Person]) -> Void) {
        let URL = host + apiVersion + searchRoute + "person"
        
        Alamofire.request(URL, method: .get, parameters: ["query": nameSearch, "api_key": apiKey])
            .responseObject{(response: DataResponse<PersonSearchResult>) in
                
                var personArray = [Person]()
                
                if let searchResult = response.result.value {
                    if let results = searchResult.results {
                        personArray = self.filterPersonResults(results) as! [Person]
                    }
                }
                
                completion(personArray)
        }
    }
    
    func getPopularPersons(_ completion: @escaping (_ personArray: [Person]) -> Void) {
        let URL = host + apiVersion + personRoute + "popular"
        
        Alamofire.request(URL, method: .get, parameters: ["api_key": apiKey])
            .responseObject{(response: DataResponse<PersonSearchResult>) in
                
                var personArray = [Person]()
                
                if let searchResult = response.result.value {
                    if let results = searchResult.results {
                        personArray = self.filterPersonResults(results) as! [Person]
                    }
                }
                
                completion(personArray)
        }
    }
    
    func filterPersonResults(_ resultArray: [Person]) -> NSArray {
        let personsThatAreKnown = resultArray.filter({ ($0.knownFor?.count)! > 2 })
        return personsThatAreKnown.filter({ ($0.knownFor?.filter({ $0.mediaType! == "movie" }).count)! > 0 }) as NSArray
    }
}
