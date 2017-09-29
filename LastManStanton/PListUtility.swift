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
        
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let filePath = URL(string: rootPath)!.appendingPathComponent("Options.plist").absoluteString
        let fileManager = FileManager.default
        
        if (!(fileManager.fileExists(atPath: filePath)))
        {
            let bundle = Bundle.main.path(forResource: "Options", ofType: "plist")!
            
            do {
                try fileManager.copyItem(atPath: bundle as String, toPath: filePath)
            } catch let error as NSError {
                print(error.description)
            }
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        return plist!
    }
    
    func writeToPlist (_ key: String, value: Int) {
        
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let filePath = URL(string: rootPath)!.appendingPathComponent("Options.plist").absoluteString
        let plist = NSMutableDictionary(contentsOfFile: filePath)
        
        plist?.setValue(value, forKey: key)
        plist?.write(toFile: filePath, atomically: true)
    }

}
