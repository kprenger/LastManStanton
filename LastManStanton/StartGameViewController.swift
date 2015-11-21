//
//  StartGameViewController.swift
//  LastManStanton
//
//  Created by Kurt Prenger on 11/16/15.
//  Copyright © 2015 My Tiny Sandbox. All rights reserved.
//

import UIKit

let knowNameSegueID = "knowName"
let needSuggestionSegueID = "needSuggestion"

class StartGameViewController: UIViewController {
    
    var selectedPersonID = 85
    
    @IBAction func startOver(segue: UIStoryboardSegue) {
        
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
        } else {
            super.prepareForSegue(segue, sender: sender)
        }
    }
}
