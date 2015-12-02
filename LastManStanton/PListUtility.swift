//
//  PListUtility.swift
//  LastManStanton
//
//  Created by Kurt Prenger on 12/1/15.
//  Copyright © 2015 My Tiny Sandbox. All rights reserved.
//

import UIKit

class PListUtility: NSObject {
    
    static let sharedInstance = PListUtility()
    
    func getPlist () -> NSDictionary {
        
        let rootPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let filePath = NSURL(string: rootPath)!.URLByAppendingPathComponent("Options.plist").absoluteString
        let fileManager = NSFileManager.defaultManager()
        
        if (!(fileManager.fileExistsAtPath(filePath)))
        {
            let bundle = NSBundle.mainBundle().pathForResource("Options", ofType: "plist")!
            
            do {
                try fileManager.copyItemAtPath(bundle as String, toPath: filePath)
            } catch let error as NSError {
                error.description
            }
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        return plist!
    }
    
    func writeToPlist (key: String, value: Int) {
        
        let rootPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let filePath = NSURL(string: rootPath)!.URLByAppendingPathComponent("Options.plist").absoluteString
        let plist = NSMutableDictionary(contentsOfFile: filePath)
        
        plist?.setValue(value, forKey: key)
        plist?.writeToFile(filePath, atomically: true)
    }

}
