//
//  MovieListViewController.swift
//  LastManStanton
//
//  Created by Kurt Prenger on 11/11/15.
//  Copyright © 2015 My Tiny Sandbox. All rights reserved.
//

import UIKit

let guessedMovieCellID = "guessedMovieCellID"
let notGuessedMovieCellID = "notGuessedMovieCellID"

class MovieListViewController: UIViewController {
    
    internal var selectedPerson = Person()
    var movieArray = [Movie]()
    var correctGuesses = [Movie]()
    var movieTotal = 0
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var foundMoviesLabel: UILabel!
    @IBOutlet weak var guessTextField: UITextField!

    @IBAction func guessButtonTouched(sender: AnyObject) {
        if let guessedMovie = checkGuessInList(guessTextField.text!) {
            correctGuesses.append(guessedMovie)
            
            if let index = movieArray.indexOf({ $0.id == guessedMovie.id }) {
                movieArray.removeAtIndex(index)
            }
            
            movieTableView.beginUpdates()
            movieTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: .Left)
            movieTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: correctGuesses.count - 1, inSection: 0)], withRowAnimation: .Left)
            movieTableView.endUpdates()
        } else {
            
        }
        
        guessTextField.resignFirstResponder()
        guessTextField.text! = ""
    }
    
    @IBAction func viewTapped(sender: AnyObject) {
        guessTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foundMoviesLabel.text = "Finding movies for " + selectedPerson.name!
        
        APIManager.sharedInstance.getMoviesForPerson(selectedPerson.id!, completion: { (movieArray) -> Void in
            self.movieArray = movieArray as! [Movie]
            
            if (self.movieArray.count == 0) {
                self.showNoDataAlert()
            } else {
                self.movieTableView.reloadData()
                self.movieTotal = self.movieArray.count
                self.foundMoviesLabel.text = "Found " + String(self.movieTotal) + " movies for " + self.selectedPerson.name!
            }
        })
    }
    
    func checkGuessInList(guess: String) -> Movie? {
        for movie in movieArray {
            if (movie.title == guess) {
                if (!correctGuesses.contains{ $0.id == movie.id }) {
                    return movie
                } else {
                    //Movie has already been guessed
                }
            }
        }
        
        return nil
    }
}

extension MovieListViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return correctGuesses.count
            
            case 1:
                return movieArray.count
            
            default:
                return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Guessed: " + String(correctGuesses.count) + " of " + String(movieTotal) + " movies"
            
        case 1:
            return "Not Guessed: " + String(movieArray.count) + " of " + String(movieTotal) + " movies"
            
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier(guessedMovieCellID)!
                let movie = correctGuesses[indexPath.row]
            
                cell.textLabel!.text = movie.title
                return cell
            
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier(notGuessedMovieCellID)!
                return cell
        }
    }
}

extension MovieListViewController: UITableViewDelegate {
    
}
