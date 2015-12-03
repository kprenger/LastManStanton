//
//  ActorSearchViewController.swift
//  LastManStanton
//
//  Created by Kurt Prenger on 11/16/15.
//  Copyright © 2015 My Tiny Sandbox. All rights reserved.
//

import UIKit

let movieListSegueID = "movieList"
let nameCellID = "nameCellID"

class ActorSearchViewController: UIViewController {
    
    internal var isSuggestion = false
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var personArray = [Person]()
    var selectedPerson = Person()
    
    @IBOutlet weak var personTableView: UITableView!

    //MARK - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        if (!isSuggestion) {
            personTableView.tableHeaderView = searchController.searchBar
            searchController.searchBar.sizeToFit()
        } else {
            APIManager.sharedInstance.getPopularPersons { (personArray) -> Void in
                self.personArray = personArray as! [Person]
                
                if (self.personArray.count == 0) {
                    self.showNoDataAlert()
                } else {
                    self.personTableView.reloadData()
                }
            }
        }
    }
    
    deinit {
        //Used to prevent a warning from occurring about dealloc'ing the VC with 
        //search controller still in place
        //
        self.searchController.view.removeFromSuperview()
    }
    
    //MARK - Search function
    
    func findPersonsForSearchText(searchText: String) {
        APIManager.sharedInstance.getPersonFromQuery(searchText) { (personArray) -> Void in
            self.personArray = personArray as! [Person]
            
            if (self.personArray.count == 0 && searchText != "") {
                self.showNoDataAlert()
            } else {
                self.personTableView.reloadData()
            }
        }
    }
    
    //MARK - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == movieListSegueID) {
            let movieListController = segue.destinationViewController as! MovieListViewController
            movieListController.selectedPerson = selectedPerson
        } else {
            super.prepareForSegue(segue, sender: sender)
        }
    }
    
    //MARK - Button touches
    
    @IBAction func closeButtonTouched(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: {})
    }
}

//MARK - TableView Data Source

extension ActorSearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(nameCellID)!
        let person = personArray[indexPath.row]
        
        cell.textLabel!.text = person.name
        
        return cell
    }
}

//MARK - TableView Delegate

extension ActorSearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let person = personArray[indexPath.row]
        selectedPerson = person
        
        return indexPath
    }
}

//MARK - Search Results controller

extension ActorSearchViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if (searchController.active) {
            findPersonsForSearchText(searchController.searchBar.text!)
        }
    }
}
