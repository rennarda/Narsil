//
//  File.swift
//  
//
//  Created by Andrew Rennard on 23/02/2021.
//

import Foundation

struct Word: Codable {
    let name: String
    let frequency: Int
    
    init(_ name: String, frequency: Int? = 1) {
        self.name = name
        self.frequency = frequency!
    }
}

struct WordGroup: Codable {
    let words: [Word]
    lazy var allWords: [String] = {
        var tempWords: [String] = []
        _ = words.map { word in
            tempWords.append(contentsOf: [String](repeating: word.name, count: word.frequency))
        }
        return tempWords
    }()
    
    init(_ words: [String]) {
        self.words = words.map { string in
            Word(string)
        }
    }
    
    init(words: [Word]) {
        self.words = words
    }
    
    mutating func random() -> String {
        allWords.randomElement() ?? ""
    }
}
