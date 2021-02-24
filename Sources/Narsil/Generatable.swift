//
//  File.swift
//  
//
//  Created by Andrew Rennard on 23/02/2021.
//

import Foundation
protocol Generatable {
    var patterns: [String] { get set}
    var patternFileName: String { get }
    
    mutating func loadPatterns()
    mutating func generate(with generator: PhraseGenerator) -> String
}

extension Generatable {
    mutating func generate(with generator: PhraseGenerator) -> String {
        if patterns.count == 0 {
            loadPatterns()
        }
        return generator.expand(string: patterns.randomElement()!)
    }
    
    mutating func loadPatterns() {
        guard let fileURL = Bundle.module.url(forResource: "patterns/\(patternFileName)", withExtension: "txt"),
              let lines = try? String(contentsOf: fileURL)
        else {
            return
        }
        patterns = lines.components(separatedBy: .newlines).dropLast()
    }
}


struct Inn: Generatable {
    var patterns: [String] = []
    var patternFileName: String = "inns"
}


struct Village: Generatable {
    var patterns: [String] = []
    var patternFileName: String = "village"
}
