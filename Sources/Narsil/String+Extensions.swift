//
//  File.swift
//  
//
//  Created by Andrew Rennard on 23/02/2021.
//

import Foundation

extension String {
    func substring(_ range: NSRange) -> Substring {
        return self[swiftRange(range)]
    }
    
    func swiftRange(_ range: NSRange) -> Range<String.Index> {
        String.Index(utf16Offset: range.location, in: self)..<String.Index(utf16Offset: range.location + range.length, in: self)
    }
    
    func correctIndefiniteArticle() -> String {
        let regEx = try! NSRegularExpression(pattern:"\\b([aA])\\s[aeiou]", options: [])
        guard let match = regEx.firstMatch(in: self, options: [], range: NSRange(startIndex..<endIndex, in: self))
        else { return self }
        let articleRange = match.range(at: 1)
        return self.replacingCharacters(in: swiftRange(articleRange), with: "an")
    }
    
}
