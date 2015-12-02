//
//  UIViewController+ShowAlert.swift
//  LastManStanton
//
//  Created by Kurt Prenger on 12/1/15.
//  Copyright © 2015 My Tiny Sandbox. All rights reserved.
//

import UIKit

extension UIViewController {

    func showNoDataAlert () {
        let alert = UIAlertController(title: "No Data Found", message: "No data was found. Please ensure you are connected to the internet.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: {})
    }
}
