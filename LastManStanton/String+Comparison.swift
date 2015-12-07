//
//  String+Comparison.swift
//  LastManStanton
//
//  Created by Kurt Prenger on 12/3/15.
//  Copyright © 2015 My Tiny Sandbox. All rights reserved.
//

import UIKit

extension String {
    
    var removePunctuation: String {
        get {
            return self.decomposedStringWithCanonicalMapping.componentsSeparatedByCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet).joinWithSeparator("")
        }
    }
    
    var stripThe: String {
        get {
            let wordsMinusThe = self.splitIntoWords().filter({ $0.lowercaseString != "the" })
            return wordsMinusThe.joinWithSeparator("")
        }
    }
    
    func splitIntoWords() -> [String] {
        
        let range = Range<String.Index>(start: self.startIndex, end: self.endIndex)
        var words = [String]()
        
        self.enumerateSubstringsInRange(range, options: NSStringEnumerationOptions.ByWords) { (substring, _, _, _) -> () in
            words.append(substring!)
        }
        
        return words
    }
    
    func fuzzyCompare(comparedString: String, fuzzySearchLevel: Int) -> Bool {
        let hardcore = comparedString
        let strict = comparedString.removePunctuation
        let average = comparedString.stripThe.removePunctuation.lowercaseString
        let kind = ""
        
        // 0 = Hardcore (exact match with "the," capitalization and punctuation)
        // 1 = Strict (exact match with "the" and capitalization; no punctuation)
        // 2 = Average (exact match without "the", caps, or punctuation)
        // 3 = Kind (no "the," no caps, no punctuation, and allows minor misspelling)
        //"".join(start.componentsSeparatedByCharactersInSet(NSCharacterSet.letterCharacte‌​rSet().invertedSet))
        switch fuzzySearchLevel {
            case 0:
                return self == comparedString
            case 1:
                return self.removePunctuation == comparedString.removePunctuation
            case 2:
                return self.stripThe.removePunctuation.lowercaseString == comparedString.stripThe.removePunctuation.lowercaseString
            case 3:
                return self.removePunctuation == comparedString.removePunctuation
            default:
                return self == comparedString
        }
    }
}
