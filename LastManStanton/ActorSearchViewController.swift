//
//  ActorSearchViewController.swift
//  LastManStanton
//
//  Created by Kurt Prenger on 11/16/15.
//  Copyright © 2015 My Tiny Sandbox. All rights reserved.
//

import UIKit
import ReachabilitySwift
import Crashlytics

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
            self.personArray = personArray
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
    
    func findPersonsForSearchText(_ searchText: String) {
        self.spinner.startAnimating()
        
        APIManager.sharedInstance.getPersonFromQuery(searchText) { (personArray) -> Void in
            self.spinner.stopAnimating()
            self.personArray = personArray
            self.personTableView.reloadData()
        }
    }
    
    //MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == movieListSegueID) {
            let movieListController = segue.destination as! MovieListViewController
            movieListController.selectedPerson = selectedPerson
            
            Answers.logLevelStart("Start Game", customAttributes: ["actorName":selectedPerson.name!])
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    //MARK: - Button touches
    
    @IBAction func closeButtonTouched(_ sender: AnyObject) {
        dismiss(animated: true, completion: {})
        
        Answers.logCustomEvent(withName: "Button Press", customAttributes: ["buttonType":"Close", "closedView":"Actor Search"])
    }
}

//MARK: - OptionsInfoViewController delegate

extension ActorSearchViewController: OptionsInfoViewControllerDelegate {
    func optionsClosed() {
        guard let reachability = Reachability() else {
            self.showNoNetworkAlert({ self.closeButtonTouched(self) })
            return
        }
            
        if (reachability.currentReachabilityStatus == .notReachable) {
            self.showNoNetworkAlert({ self.closeButtonTouched(self) })
        } else {
            self.performSegue(withIdentifier: "movieList", sender: self)
        }
    }
}

//MARK: - TableView Data Source

extension ActorSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: nameCellID)!
        let person = personArray[indexPath.row]
        
        cell.textLabel!.text = person.name
        
        return cell
    }
}

//MARK: - TableView Delegate

extension ActorSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let person = personArray[indexPath.row]
        selectedPerson = person
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let optionsController = storyboard.instantiateViewController(withIdentifier: "optionsVC") as! OptionsInfoViewController
        optionsController.isOptions = true
        optionsController.delegate = self
        
        searchController.isActive = false
        present(optionsController, animated: true, completion: nil)
    }
}

//MARK: - Search Results controller

extension ActorSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if (searchController.isActive) {
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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
    }
}
