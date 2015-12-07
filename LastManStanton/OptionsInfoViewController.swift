//
//  OptionsInfoViewController.swift
//  LastManStanton
//
//  Created by Kurt Prenger on 12/1/15.
//  Copyright © 2015 My Tiny Sandbox. All rights reserved.
//

import UIKit

class OptionsInfoViewController: UIViewController {
    
    internal var isOptions = false

    let plist = PListUtility.sharedInstance.getPlist()
    let fuzzySearchOptions = ["Hardcore", "Strict", "Average", "Kind"]
    
    var numberOfPlayers = 1
    var guessTimeLimit = 5
    var fuzzySearchLevel = 0
    
    @IBOutlet weak var numberOfPlayersLabel: UILabel!
    @IBOutlet weak var guessTimeLimitLabel: UILabel!
    @IBOutlet weak var fuzzySearchLevelLabel: UILabel!
    
    @IBOutlet weak var numberOfPlayersStepper: UIStepper!
    @IBOutlet weak var guessTimeLimitStepper: UIStepper!
    @IBOutlet weak var fuzzySearchLevelStepper: UIStepper!
    
    //MARK - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isOptions) {
            numberOfPlayers = plist[Constants.numberOfPlayersString] as! Int
            guessTimeLimit = plist[Constants.guessTimeLimitString] as! Int
            fuzzySearchLevel = plist[Constants.fuzzySearchLevelString] as! Int
            
            numberOfPlayersStepper.value = Double(numberOfPlayers)
            guessTimeLimitStepper.value = Double(guessTimeLimit)
            fuzzySearchLevelStepper.value = Double(fuzzySearchLevel)
            
            updateLabels()
        }
    }
    
    //MARK - Update labels
    
    func updateLabels() {
        numberOfPlayersLabel.text = String(numberOfPlayers)
        guessTimeLimitLabel.text = String(guessTimeLimit)
        fuzzySearchLevelLabel.text = fuzzySearchOptions[fuzzySearchLevel]
    }
    
    //MARK - Steppers touched
    
    @IBAction func numberOfPlayersChanged(sender: UIStepper) {
        numberOfPlayers = Int(sender.value)
        updateLabels()
        PListUtility.sharedInstance.writeToPlist(Constants.numberOfPlayersString, value: numberOfPlayers)
    }
    
    @IBAction func guessTimeLimitChanged(sender: UIStepper) {
        guessTimeLimit = Int(sender.value)
        updateLabels()
        PListUtility.sharedInstance.writeToPlist(Constants.guessTimeLimitString, value: guessTimeLimit)
    }
    
    @IBAction func fuzzySearchLevelChanged(sender: UIStepper) {
        fuzzySearchLevel = Int(sender.value)
        updateLabels()
        PListUtility.sharedInstance.writeToPlist(Constants.fuzzySearchLevelString, value: fuzzySearchLevel)
    }
    
    @IBAction func closeButtonTouched(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: {})
    }
}
