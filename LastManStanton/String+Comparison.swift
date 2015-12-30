//
//  String+Comparison.swift
//  LastManStanton
//
//  Created by Kurt Prenger on 12/3/15.
//  Copyright © 2015 My Tiny Sandbox. All rights reserved.
//

import UIKit

extension String {
    
    //MARK - String mutation
    
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
    
    //MARK - Levenshtein distance functions
    
    //Pulled from this gist: https://gist.github.com/bgreenlee/52d93a1d8fa1b8c1f38b
    
    func min(numbers: Int...) -> Int {
        return numbers.reduce(numbers[0], combine: {$0 < $1 ? $0 : $1})
    }
    
    //If Levenshtein is <5, then the strings are close enough
    //
    func levenshtein(comparedString: String) -> Int {
        // create character arrays
        let a = Array(self.characters)
        let b = Array(comparedString.characters)
        
        // initialize matrix of size |a|+1 * |b|+1 to zero
        var dist = [[Int]]()
        for _ in 0...a.count {
            dist.append([Int](count: b.count + 1, repeatedValue: 0))
        }
        
        // 'a' prefixes can be transformed into empty string by deleting every char
        for i in 1...a.count {
            dist[i][0] = i
        }
        
        // 'b' prefixes can be created from empty string by inserting every char
        for j in 1...b.count {
            dist[0][j] = j
        }
        
        for i in 1...a.count {
            for j in 1...b.count {
                if a[i-1] == b[j-1] {
                    dist[i][j] = dist[i-1][j-1]  // noop
                } else {
                    dist[i][j] = min(
                        dist[i-1][j] + 1,  // deletion
                        dist[i][j-1] + 1,  // insertion
                        dist[i-1][j-1] + 1  // substitution
                    )
                }
            }
        }
        
        return dist[a.count][b.count]
    }
    
    func fuzzyCompare(comparedString: String, fuzzySearchLevel: Int) -> Bool {
        
        // 3 = Hardcore (exact match with "the," capitalization and punctuation)
        // 2 = Strict (exact match with "the" and capitalization; no punctuation)
        // 1 = Average (exact match without "the", caps, or punctuation)
        // 0 = Kind (no "the," no caps, no punctuation, and allows minor misspelling)
        //
        switch fuzzySearchLevel {
            case 3:
                return self == comparedString
            case 2:
                return self.removePunctuation == comparedString.removePunctuation
            case 1:
                return self.stripThe.removePunctuation.lowercaseString == comparedString.stripThe.removePunctuation.lowercaseString
            case 0:
                return self.stripThe.removePunctuation.lowercaseString.levenshtein(comparedString.stripThe.removePunctuation.lowercaseString) <= 3
            default:
                return self == comparedString
        }
    }
}
