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
    var someoneGuessedCorrect = false
    var madeItThroughRound = false
    var fuzzySearchLevel = 1
    var guessTimeLimit = 1
    var numberOfPlayers = 1
    var currentPlayer = 1
    var currentTime = 0
    
    var timer = NSTimer()
    
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var foundMoviesLabel: UILabel!
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var whoseTurnLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var guessButton: UIView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guessTextField.delegate = self
        
        whoseTurnLabel.text = "Player 1's turn"
        numberOfPlayers = plist[Constants.numberOfPlayersString] as! Int
        guessTimeLimit = plist[Constants.guessTimeLimitString] as! Int
        fuzzySearchLevel = plist[Constants.fuzzySearchLevelString] as! Int
        currentTime = guessTimeLimit * 60
        timerLabel.text = Formatters.timeFormat(currentTime)
        
        for _ in 1...numberOfPlayers {
            playersInGame.append(true)
        }
        
        foundMoviesLabel.text = "Finding movies for " + selectedPerson.name!
        
        APIManager.sharedInstance.getMoviesForPerson(selectedPerson.id!, completion: { (movieArray) -> Void in
            self.spinner.stopAnimating()
            self.movieArray = movieArray as! [Movie]
            self.allMovieArray = movieArray as! [Movie]
            
            if (self.movieArray.count == 0) {
                self.showNoDataAlert()
            } else {
                self.movieTableView.reloadData()
                
                if (self.allMovieArray.count != 1) {
                    self.foundMoviesLabel.text = "Found " + String(self.allMovieArray.count) + " movies for " + self.selectedPerson.name! } else {
                    self.foundMoviesLabel.text = "Found " + String(self.allMovieArray.count) + " movie for " + self.selectedPerson.name!
                }
                self.showStartGameAlert({self.startTimer()})
            }
        })
    }
    
    //MARK: - Game functions
    
    func correctAnswer(guessedMovie: Movie) {
        someoneGuessedCorrect = true
        playersInGame[currentPlayer - 1] = true
        
        incrementPlayer()
        
        if (!gameOver) {
            showGuessResultAlert(GuessType.Correct, playerNumber: currentPlayer, clickedOK: {self.startTimer()})
        }
        
        correctGuesses.insert(guessedMovie, atIndex: 0)
        
        if let index = movieArray.indexOf({ $0.id == guessedMovie.id }) {
            movieArray.removeAtIndex(index)
        }
        
        updateMovieTable()
    }
    
    func incorrectAnswer(isTimeExpired: Bool) {
        let guessType = (isTimeExpired ? GuessType.TimeUp : GuessType.Incorrect)

        playersInGame[currentPlayer - 1] = false
        incrementPlayer()
        
        if (!gameOver) {
            showGuessResultAlert(guessType, playerNumber: currentPlayer, clickedOK: {self.startTimer()})
        }
    }
    
    func incrementPlayer() {
        
        let playersStillPlaying = playersInGame.filter({ $0 })
        currentPlayer += 1
        
        if (currentPlayer > numberOfPlayers) {
            madeItThroughRound = true
            currentPlayer = 1
        }
        
        if (!playersInGame[currentPlayer - 1] && playersStillPlaying.count > 1) {
            incrementPlayer()
            return
        }
        
        if (playersStillPlaying.count < 2 && madeItThroughRound) {
            timer.invalidate()
            var winningPlayer = 0
            
            if let playerIndex = playersInGame.indexOf(true) {
                winningPlayer = playerIndex + 1
            }
            
            showEndGameAlert(winningPlayer, someoneGuessedCorrect: someoneGuessedCorrect,
                clickedShowAnswers: {
                    self.guessButton.userInteractionEnabled = false
                    self.guessButton.alpha = 0.3
                    self.guessTextField.userInteractionEnabled = false
                    self.guessTextField.alpha = 0.3
                    self.correctGuesses = self.allMovieArray.sort({ $0.title < $1.title })
                    self.movieArray = [Movie]()
                    self.movieTableView.reloadData()
                },
                clickedRedo:  {
                    self.correctGuesses = [Movie]()
                    self.movieArray = self.allMovieArray
                    self.movieTableView.reloadData()
                    
                    self.gameOver = false
                    self.someoneGuessedCorrect = false
                    self.playersInGame = [Bool]()
                    for _ in 1...self.numberOfPlayers {
                        self.playersInGame.append(true)
                    }
                    self.currentPlayer = self.numberOfPlayers
                    self.incrementPlayer()
                    self.madeItThroughRound = false
                    
                    self.showStartGameAlert({self.startTimer()})
                },
                clickedStartOver: {
                    self.performSegueWithIdentifier(startOverSegueID, sender: self)
            })
            gameOver = true
            return
        }
        
        currentTime = guessTimeLimit * 60
        timerLabel.text = Formatters.timeFormat(currentTime)
        whoseTurnLabel.text = "Player " + String(currentPlayer) + "'s turn"
    }
    
    func checkGuessInList(guess: String) -> Movie? {
        if (guess.removePunctuation.isEmpty) {
            self.showGuessResultAlert(GuessType.BlankGuess, playerNumber: 1, clickedOK: {})
            
            return Movie(dummyMovie: true)
        }
        
        for movie in allMovieArray {
            if let title = movie.title {
                if (title.fuzzyCompare(guess, fuzzySearchLevel: fuzzySearchLevel)) {
                    if (!correctGuesses.contains{ $0.id == movie.id }) {
                        return movie
                    } else {
                        self.showGuessResultAlert(GuessType.AlreadyGuessed, playerNumber: 1, clickedOK: {})
                        
                        return Movie(dummyMovie: true)
                    }
                }
            }
        }
        
        return nil
    }
    
    func updateMovieTable() {
        movieTableView.beginUpdates()
        movieTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: .Left)
        movieTableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Left)
        movieTableView.headerViewForSection(0)?.textLabel?.text = tableView(movieTableView, titleForHeaderInSection: 0)
        movieTableView.headerViewForSection(1)?.textLabel?.text = tableView(movieTableView, titleForHeaderInSection: 1)
        movieTableView.endUpdates()
    }
    
    //MARK: - Timer functions
    
    func startTimer() {
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timeIncrement", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    func timeIncrement() {
        currentTime -= 1
        if (currentTime <= 0) {
            timeExpired()
        } else {
            timerLabel.text = Formatters.timeFormat(currentTime)
        }
    }
    
    func timeExpired() {
        timer.invalidate()
        incorrectAnswer(true)
    }
    
    //MARK: - Button touches
    
    @IBAction func closeButtonTouched(sender: AnyObject) {
        timer.invalidate()
    }
    
    @IBAction func guessButtonTouched(sender: AnyObject) {
        if let guessedMovie = checkGuessInList(guessTextField.text!) {
            if (guessedMovie.title != Constants.dummyMovieTitle) {
                timer.invalidate()
                correctAnswer(guessedMovie)
            }
        } else {
            timer.invalidate()
            incorrectAnswer(false)
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
        var returnString = ""
        
        switch section {
            case 0:
                returnString = "Guessed: " + String(correctGuesses.count)
            
            case 1:
                returnString = "Not Guessed: " + String(movieArray.count)
            
            default:
                return ""
            }
        
        if (allMovieArray.count != 1) {
            returnString += " of " + String(allMovieArray.count) + " movies"
        } else {
            returnString += " of " + String(allMovieArray.count) + " movie"
        }
        
        return returnString
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

//MARK - TextField delegate

extension MovieListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        guessTextField.resignFirstResponder()
        guessButtonTouched(self)
        
        return true
    }
}
