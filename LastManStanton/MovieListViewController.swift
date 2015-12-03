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
let startOverSegueID = "startOverSegue"

class MovieListViewController: UIViewController {
    
    let plist = PListUtility.sharedInstance.getPlist()
    
    internal var selectedPerson = Person()
    var allMovieArray = [Movie]()
    var movieArray = [Movie]()
    var correctGuesses = [Movie]()
    var playersInGame = [Bool]()
    
    var gameOver = false
    var guessTimeLimit = 1
    var numberOfPlayers = 1
    var currentPlayer = 1
    
    var timer = NSTimer()
    
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var foundMoviesLabel: UILabel!
    @IBOutlet weak var guessTextField: UITextField!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfPlayers = plist[Constants.numberOfPlayersString] as! Int
        guessTimeLimit = plist[Constants.guessTimeLimitString] as! Int
        
        for _ in 1...numberOfPlayers {
            playersInGame.append(true)
        }
        
        foundMoviesLabel.text = "Finding movies for " + selectedPerson.name!
        
        APIManager.sharedInstance.getMoviesForPerson(selectedPerson.id!, completion: { (movieArray) -> Void in
            self.movieArray = movieArray as! [Movie]
            self.allMovieArray = movieArray as! [Movie]
            
            if (self.movieArray.count == 0) {
                self.showNoDataAlert()
            } else {
                self.movieTableView.reloadData()
                self.foundMoviesLabel.text = "Found " + String(self.allMovieArray.count) + " movies for " + self.selectedPerson.name!
                self.showStartGameAlert({self.startTimer()})
            }
        })
    }
    
    //MARK: - Game functions
    
    func incrementPlayer() {
        let playersStillPlaying = playersInGame.filter({ $0 })
        if (playersStillPlaying.count <= 1) {
            timer.invalidate()
            showEndGameAlert(playersInGame,
                clickedShowAnswers: {
                    self.correctGuesses = self.allMovieArray.sort({ $0.title < $1.title })
                    self.movieArray = [Movie]()
                    self.movieTableView.reloadData()
                },
                clickedStartOver: {
                    self.performSegueWithIdentifier(startOverSegueID, sender: self)
            })
            gameOver = true
            return
        }
        
        currentPlayer += 1
        if (currentPlayer > numberOfPlayers) {
            currentPlayer = 1
        }
        
        if (!playersInGame[currentPlayer - 1]) {
            incrementPlayer()
        }
    }
    
    func checkGuessInList(guess: String) -> Movie? {
        for movie in allMovieArray {
            if (movie.title == guess) {
                if (!correctGuesses.contains{ $0.id == movie.id }) {
                    return movie
                } else {
                    self.showGuessResultAlert(GuessType.AlreadyGuessed, playerNumber: 1, clickedOK: {})
                    
                    return Movie(dummyMovie: true)
                }
            }
        }
        
        return nil
    }
    
    func updateMovieTable() {
        movieTableView.beginUpdates()
        movieTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: .Left)
        movieTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: correctGuesses.count - 1, inSection: 0)], withRowAnimation: .Left)
        movieTableView.headerViewForSection(0)?.textLabel?.text = tableView(movieTableView, titleForHeaderInSection: 0)
        movieTableView.headerViewForSection(1)?.textLabel?.text = tableView(movieTableView, titleForHeaderInSection: 1)
        movieTableView.endUpdates()
    }
    
    //MARK: - Timer functions
    
    func startTimer() {
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(Double(guessTimeLimit * 60), target: self, selector: "timeExpired", userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    func timeExpired() {
        timer.invalidate()
        showGuessResultAlert(GuessType.TimeUp, playerNumber: currentPlayer, clickedOK: {
            self.startTimer()
            self.incrementPlayer()
        })
    }
    
    //MARK: - Button touches
    
    @IBAction func closeButtonTouched(sender: AnyObject) {
        timer.invalidate()
    }
    
    @IBAction func guessButtonTouched(sender: AnyObject) {
        if let guessedMovie = checkGuessInList(guessTextField.text!) {
            if (guessedMovie.title == Constants.dummyMovieTitle) {
                guessTextField.resignFirstResponder()
                guessTextField.text! = ""
                
                return
            }
            
            playersInGame[currentPlayer - 1] = true
            incrementPlayer()
            
            if (!gameOver) {
                showGuessResultAlert(GuessType.Correct, playerNumber: currentPlayer, clickedOK: {self.startTimer()})
            }
            
            correctGuesses.append(guessedMovie)
            
            if let index = movieArray.indexOf({ $0.id == guessedMovie.id }) {
                movieArray.removeAtIndex(index)
            }
            
            updateMovieTable()
        } else {
            playersInGame[currentPlayer - 1] = false
            incrementPlayer()
            
            if (!gameOver) {
                showGuessResultAlert(GuessType.Incorrect, playerNumber: currentPlayer, clickedOK: {self.startTimer()})
            }
        }
        
        guessTextField.resignFirstResponder()
        guessTextField.text! = ""
    }
    
    @IBAction func viewTapped(sender: AnyObject) {
        guessTextField.resignFirstResponder()
    }
}

//MARK: - TableView Data Source

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
            return "Guessed: " + String(correctGuesses.count) + " of " + String(allMovieArray.count) + " movies"
            
        case 1:
            return "Not Guessed: " + String(movieArray.count) + " of " + String(allMovieArray.count) + " movies"
            
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

//MARK: - TableView Delegate

extension MovieListViewController: UITableViewDelegate {
    
}
