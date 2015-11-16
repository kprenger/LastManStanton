//
//  MovieListViewController.swift
//  LastManStanton
//
//  Created by Kurt Prenger on 11/11/15.
//  Copyright © 2015 My Tiny Sandbox. All rights reserved.
//

import UIKit

let movieCellID = "movieCellID"

class MovieListViewController: UIViewController {
    
    var movieArray = [Movie]()
    @IBOutlet weak var movieTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getDataPushed(sender: AnyObject) {
        APIManager.sharedInstance.getMoviesForPerson(85, completion: { (array) -> Void in
            self.movieArray = array as! [Movie]
            self.movieTableView.reloadData()
        })
    }

}

extension MovieListViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(movieCellID)!
        let movie = movieArray[indexPath.row]
        
        cell.textLabel!.text = movie.title
        
        return cell
    }
}

extension MovieListViewController: UITableViewDelegate {
    
}
