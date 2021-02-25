//
//  File.swift
//  
//
//  Created by Andrew Rennard on 23/02/2021.
//

import Foundation
public protocol Generatable {
    var patterns: [String] { get set}
    var patternFileName: String { get }
    
    mutating func loadPatterns()
    mutating func generate(with generator: PhraseGenerator) -> String
}

public extension Generatable {
    mutating func generate(with generator: PhraseGenerator) -> String {
        if patterns.count == 0 {
            loadPatterns()
        }
        let pattern = patterns.randomElement()!
        return generator.expand(string: pattern)
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
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


public struct Inn: Generatable {
    public var patterns: [String] = []
    public var patternFileName: String = "inns"    
    public init(){}
}


public struct Village: Generatable {
    public var patterns: [String] = []
    public var patternFileName: String = "village"
    public init(){}
}

public struct Meal: Generatable {
    public var patterns: [String] = []
    public var patternFileName: String = "meal"
    public init(){}
}

public struct HumanName: Generatable {
    public var patterns: [String] = []
    public var patternFileName: String = "humanname"
    public init(){}
}
