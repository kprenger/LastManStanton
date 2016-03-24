//
//  StartGameViewController.swift
//  LastManStanton
//
//  Created by Kurt Prenger on 11/16/15.
//  Copyright © 2015 My Tiny Sandbox. All rights reserved.
//

import UIKit
import ReachabilitySwift

let knowNameSegueID = "knowName"
let needSuggestionSegueID = "needSuggestion"
let optionsSegueID = "optionsSegue"
let infoSegueID = "infoSegue"

class StartGameViewController: UIViewController {
    
    var selectedPersonID = 85
    
    @IBAction func startOver(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func startGameButtonTouched(sender: AnyObject) {
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            
            if (reachability.currentReachabilityStatus == .NotReachable) {
                self.showNoNetworkAlert({})
            } else {
                performSegueWithIdentifier(knowNameSegueID, sender: self)
            }
        } catch {
            self.showNoNetworkAlert({})
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == knowNameSegueID) {
            let actorController = segue.destinationViewController as! ActorSearchViewController
            actorController.isSuggestion = false
        } else if (segue.identifier == needSuggestionSegueID) {
            let actorController = segue.destinationViewController as! ActorSearchViewController
            actorController.isSuggestion = true
        } else if (segue.identifier == optionsSegueID) {
            let optionsInfoController = segue.destinationViewController as! OptionsInfoViewController
            optionsInfoController.isOptions = true
        } else if (segue.identifier == infoSegueID) {
            let optionsInfoController = segue.destinationViewController as! OptionsInfoViewController
            optionsInfoController.isOptions = false
        } else {
            super.prepareForSegue(segue, sender: sender)
        }
    }
}
