//
//  OptionsInfoViewController.swift
//  LastManStanton
//
//  Created by Kurt Prenger on 12/1/15.
//  Copyright © 2015 My Tiny Sandbox. All rights reserved.
//

import UIKit
import Crashlytics

protocol OptionsInfoViewControllerDelegate: class {
    func optionsClosed()
}

class OptionsInfoViewController: UIViewController {
    
    internal var isOptions = false

    let plist = PListUtility.sharedInstance.getPlist()
    let fuzzySearchOptions = ["Kind", "Average", "Strict", "Hardcore"]
    let fuzzySearchDescriptions = ["Kind of a match (no capitalization, \"the\" or punctuation needed; allows for minor misspelling)",
        "Semi match (no capitalization, \"the,\" or punctuation needed)",
        "Near match (capitalization and \"the\" required; no punctuation)",
        "Exact match (capitalization, \"the,\" and punctuation required)"]
    
    var numberOfPlayers = 1
    var guessTimeLimit = 5
    var fuzzySearchLevel = 0
    
    weak var delegate:OptionsInfoViewControllerDelegate?
    
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var numberOfPlayersLabel: UILabel!
    @IBOutlet weak var guessTimeLimitLabel: UILabel!
    @IBOutlet weak var fuzzySearchLevelLabel: UILabel!
    @IBOutlet weak var comparisonDescription: UITextView!
    
    @IBOutlet weak var numberOfPlayersStepper: UIStepper!
    @IBOutlet weak var guessTimeLimitStepper: UIStepper!
    @IBOutlet weak var fuzzySearchLevelStepper: UIStepper!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (isOptions) {
            numberOfPlayers = plist[Constants.numberOfPlayersString] as! Int
            guessTimeLimit = plist[Constants.guessTimeLimitString] as! Int
            fuzzySearchLevel = plist[Constants.fuzzySearchLevelString] as! Int
            
            numberOfPlayersStepper.value = Double(numberOfPlayers)
            guessTimeLimitStepper.value = Double(guessTimeLimit)
//            fuzzySearchLevelStepper.value = Double(fuzzySearchLevel)
            
            updateLabels()
        } else {
            let build = Bundle.main.infoDictionary!["CFBundleVersion"]
            let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"]
            versionLabel.text = "Version: \(version!) (\(build!))"
            
            Answers.logContentView(withName: "Info View", contentType: "Info", contentId: "info-1", customAttributes: nil)
        }
    }
    
    //MARK: - Update labels
    
    func updateLabels() {
        numberOfPlayersLabel.text = "Number of Players: \(String(numberOfPlayers))"
        guessTimeLimitLabel.text = "Time Limit (minutes): \(String(guessTimeLimit))"
//        fuzzySearchLevelLabel.text = fuzzySearchOptions[fuzzySearchLevel]
//        comparisonDescription.text = fuzzySearchDescriptions[fuzzySearchLevel]
    }
    
    //MARK: - Steppers touched
    
    @IBAction func numberOfPlayersChanged(_ sender: UIStepper) {
        numberOfPlayers = Int(sender.value)
        updateLabels()
        PListUtility.sharedInstance.writeToPlist(Constants.numberOfPlayersString, value: numberOfPlayers)
    }
    
    @IBAction func guessTimeLimitChanged(_ sender: UIStepper) {
        guessTimeLimit = Int(sender.value)
        updateLabels()
        PListUtility.sharedInstance.writeToPlist(Constants.guessTimeLimitString, value: guessTimeLimit)
    }
    
    @IBAction func fuzzySearchLevelChanged(_ sender: UIStepper) {
        fuzzySearchLevel = Int(sender.value)
        updateLabels()
        PListUtility.sharedInstance.writeToPlist(Constants.fuzzySearchLevelString, value: fuzzySearchLevel)
    }
    
    //MARK: - Close button touched
    
    @IBAction func closeButtonTouched(_ sender: AnyObject) {
        dismiss(animated: true, completion: {
            if let delegate = self.delegate {
                delegate.optionsClosed()
            }
        })
        
        var viewType = "Info View"
        
        if (isOptions) {
            viewType = "Options View"
        }
        
        Answers.logCustomEvent(withName: "Button Press", customAttributes: ["buttonType":"Close", "closedView":viewType])
    }
}
