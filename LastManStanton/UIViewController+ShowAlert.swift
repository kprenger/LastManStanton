//
//  UIViewController+ShowAlert.swift
//  LastManStanton
//
//  Created by Kurt Prenger on 12/1/15.
//  Copyright © 2015 My Tiny Sandbox. All rights reserved.
//

import UIKit

extension UIViewController {
    
    enum GuessType {
        case Correct
        case Incorrect
        case TimeUp
        case AlreadyGuessed
        case BlankGuess
    }
    
    func showNoNetworkAlert(clickedOK: () -> Void) {
        let alert = UIAlertController(title: "No Network Connection", message: "This app requires an internet connection for the most enjoyment. Please ensure you are connected.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {_ in clickedOK()}))
        
        self.presentViewController(alert, animated: true, completion: {})
    }

    func showNoDataAlert() {
        let alert = UIAlertController(title: "No Data Found", message: "No data was found. Please ensure you are connected to the internet.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    func showGuessResultAlert(correct: GuessType, playerNumber: Int, clickedOK: () -> Void) {
        var title = ""
        var message = ""
        
        switch correct {
            case .Correct:
                title = "Correct!"
                message = "Good guess! It is now Player " + String(playerNumber) + "'s turn."
            case .Incorrect:
                title = "Incorrect!"
                message = "I'm sorry, but that is wrong. It is now Player " + String(playerNumber) + "'s turn."
            case .TimeUp:
                title = "Time's up!"
                message = "I'm sorry, but you took too long. It is now Player " + String(playerNumber) + "'s turn."
            case .AlreadyGuessed:
                title = "Already guessed!"
                message = "That movie was already correctly guessed. Try again!"
            case .BlankGuess:
                title = "Invalid answer!"
                message = "Please enter a valid answer (with letters and numbers)!"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
            _ in clickedOK()}))
        
        self.presentViewController(alert, animated: true, completion: {})
        
        //Sets auto-dismiss for alert after 5 seconds
        //
        let delay = 5.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
            if (alert.isViewLoaded() && alert.view.window != nil) {
                clickedOK()
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func showStartGameAlert(clickedOK: () -> Void) {
        let alert = UIAlertController(title: "Start!", message: "Player 1, you are up.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {_ in clickedOK()}))
        
        self.presentViewController(alert, animated: true, completion: {})
        
        //Sets auto-dismiss for alert after 5 seconds
        //
        let delay = 5.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
            if (alert.isViewLoaded() && alert.view.window != nil) {
                clickedOK()
                alert.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func showEndGameAlert(currentPlayer: Int, someoneGuessedCorrect: Bool, clickedShowAnswers: () -> Void, clickedRedo: () -> Void, clickedStartOver: () -> Void) {
        var message = ""
        
        if (someoneGuessedCorrect) {
            message = "Player " + String(currentPlayer) + " wins!"
        } else {
            message = "No one guessed correctly. It's a tie!"
        }
        
        let alert = UIAlertController(title: "Game Over!", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Show All Movies", style: .Default, handler: {_ in clickedShowAnswers()}))
        alert.addAction(UIAlertAction(title: "Redo This Person", style: .Default, handler: {_ in clickedRedo()}))
        alert.addAction(UIAlertAction(title: "Pick a New Person", style: .Default, handler: {_ in clickedStartOver()}))
        
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    func showMovieMasterAlert(actorName: String, clickedStartOver: () -> Void) {
        let message = "You certainly know \(actorName)'s body of work! Why not play someone else?"
        let alert = UIAlertController(title: "Wow!", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Pick a New Person", style: .Default, handler: { _ in clickedStartOver()}))
        
        self.presentViewController(alert, animated: true, completion: {})
    }
}
