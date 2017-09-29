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
        case correct
        case incorrect
        case timeUp
        case alreadyGuessed
        case blankGuess
    }
    
    func showNoNetworkAlert(_ clickedOK: @escaping () -> Void) {
        let alert = UIAlertController(title: "No Network Connection", message: "This app requires an internet connection for the most enjoyment. Please ensure you are connected.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in clickedOK()}))
        
        self.present(alert, animated: true, completion: {})
    }

    func showNoDataAlert() {
        let alert = UIAlertController(title: "No Data Found", message: "No data was found. Please ensure you are connected to the internet.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: {})
    }
    
    func showGuessResultAlert(_ correct: GuessType, playerNumber: Int, clickedOK: @escaping () -> Void) {
        var title = ""
        var message = ""
        
        switch correct {
            case .correct:
                title = "Correct!"
                message = "Good guess! It is now Player " + String(playerNumber) + "'s turn."
            case .incorrect:
                title = "Incorrect!"
                message = "I'm sorry, but that is wrong. It is now Player " + String(playerNumber) + "'s turn."
            case .timeUp:
                title = "Time's up!"
                message = "I'm sorry, but you took too long. It is now Player " + String(playerNumber) + "'s turn."
            case .alreadyGuessed:
                title = "Already guessed!"
                message = "That movie was already correctly guessed. Try again!"
            case .blankGuess:
                title = "Invalid answer!"
                message = "Please enter a valid answer (with letters and numbers)!"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            _ in clickedOK()}))
        
        self.present(alert, animated: true, completion: {})
        
        //Sets auto-dismiss for alert after 5 seconds
        //
        let delay = 5.0 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) { () -> Void in
            if (alert.isViewLoaded && alert.view.window != nil) {
                clickedOK()
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func showStartGameAlert(_ clickedOK: @escaping () -> Void) {
        let alert = UIAlertController(title: "Start!", message: "Player 1, you are up.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in clickedOK()}))
        
        self.present(alert, animated: true, completion: {})
        
        //Sets auto-dismiss for alert after 5 seconds
        //
        let delay = 5.0 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) { () -> Void in
            if (alert.isViewLoaded && alert.view.window != nil) {
                clickedOK()
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func showEndGameAlert(_ currentPlayer: Int, someoneGuessedCorrect: Bool, clickedShowAnswers: @escaping () -> Void, clickedRedo: @escaping () -> Void, clickedStartOver: @escaping () -> Void) {
        var message = ""
        
        if (someoneGuessedCorrect) {
            message = "Player " + String(currentPlayer) + " wins!"
        } else {
            message = "No one guessed correctly. It's a tie!"
        }
        
        let alert = UIAlertController(title: "Game Over!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Show All Movies", style: .default, handler: {_ in clickedShowAnswers()}))
        alert.addAction(UIAlertAction(title: "Redo This Person", style: .default, handler: {_ in clickedRedo()}))
        alert.addAction(UIAlertAction(title: "Pick a New Person", style: .default, handler: {_ in clickedStartOver()}))
        
        self.present(alert, animated: true, completion: {})
    }
    
    func showMovieMasterAlert(_ actorName: String, clickedStartOver: @escaping () -> Void) {
        let message = "You certainly know \(actorName)'s body of work! Why not play someone else?"
        let alert = UIAlertController(title: "Wow!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Pick a New Person", style: .default, handler: { _ in clickedStartOver()}))
        
        self.present(alert, animated: true, completion: {})
    }
}
