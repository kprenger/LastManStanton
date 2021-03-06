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
    
    @IBAction func startOver(_ segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func startGameButtonTouched(_ sender: AnyObject) {
        guard let reachability = Reachability() else {
            self.showNoNetworkAlert({})
            return
        }
        
        if (reachability.currentReachabilityStatus == .notReachable) {
            self.showNoNetworkAlert({})
        } else {
            performSegue(withIdentifier: knowNameSegueID, sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == knowNameSegueID) {
            let actorController = segue.destination as! ActorSearchViewController
            actorController.isSuggestion = false
        } else if (segue.identifier == needSuggestionSegueID) {
            let actorController = segue.destination as! ActorSearchViewController
            actorController.isSuggestion = true
        } else if (segue.identifier == optionsSegueID) {
            let optionsInfoController = segue.destination as! OptionsInfoViewController
            optionsInfoController.isOptions = true
        } else if (segue.identifier == infoSegueID) {
            let optionsInfoController = segue.destination as! OptionsInfoViewController
            optionsInfoController.isOptions = false
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
