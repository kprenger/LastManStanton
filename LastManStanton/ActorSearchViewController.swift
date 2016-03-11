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
    var alertShown = false
    
    @IBOutlet weak var personTableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.spinner.stopAnimating()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for an actor or director"
        
        personTableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
        
        //Pre-load list with popular actors
        //
        self.spinner.startAnimating()
        
        APIManager.sharedInstance.getPopularPersons { (personArray) -> Void in
            self.spinner.stopAnimating()
            self.personArray = personArray as! [Person]
            self.personTableView.reloadData()
        }
    }
    
    deinit {
        //Used to prevent a warning from occurring about dealloc'ing the VC with 
        //search controller still in place
        //
        self.searchController.view.removeFromSuperview()
    }
    
    //MARK: - Search function
    
    func findPersonsForSearchText(searchText: String) {
        self.spinner.startAnimating()
        
        APIManager.sharedInstance.getPersonFromQuery(searchText) { (personArray) -> Void in
            self.spinner.stopAnimating()
            self.personArray = personArray as! [Person]
            self.personTableView.reloadData()
        }
    }
    
    //MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == movieListSegueID) {
            let movieListController = segue.destinationViewController as! MovieListViewController
            movieListController.selectedPerson = selectedPerson
        } else {
            super.prepareForSegue(segue, sender: sender)
        }
    }
    
    //MARK: - Button touches
    
    @IBAction func closeButtonTouched(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: {})
    }
}

//MARK: - OptionsInfoViewController delegate

extension ActorSearchViewController: OptionsInfoViewControllerDelegate {
    func optionsClosed() {
        self.performSegueWithIdentifier("movieList", sender: self)
    }
}

//MARK: - TableView Data Source

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

//MARK: - TableView Delegate

extension ActorSearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let person = personArray[indexPath.row]
        selectedPerson = person
        
        return indexPath
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let optionsController = storyboard.instantiateViewControllerWithIdentifier("optionsVC") as! OptionsInfoViewController
        optionsController.isOptions = true
        optionsController.delegate = self
        
        self.presentViewController(optionsController, animated: true, completion: nil)
    }
}

//MARK: - Search Results controller

extension ActorSearchViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if (searchController.active) {
            if let searchTextCount = searchController.searchBar.text?.characters.count {
                if (searchTextCount > 2) {
                    findPersonsForSearchText(searchController.searchBar.text!)
                }
            }
        }
    }
}

//MARK: - SearchBar delegate

extension ActorSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchController.active = false
    }
}
