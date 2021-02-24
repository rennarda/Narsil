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
}
