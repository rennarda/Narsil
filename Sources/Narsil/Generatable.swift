//
//  File.swift
//  
//
//  Created by Andrew Rennard on 23/02/2021.
//

import Foundation
public enum CapitalisationType {
    case initial, word, none
}

public protocol Generatable {
    var patterns: [String] { get set}
    var patternFileName: String { get }
    var capitalisation: CapitalisationType { get }

    mutating func loadPatterns()
    mutating func generate(with generator: PhraseGenerator) -> String
}

public extension Generatable {
    mutating func generate(with generator: PhraseGenerator) -> String {
        if patterns.count == 0 {
            loadPatterns()
        }
        let pattern = patterns.randomElement()!
        let phrase = generator.expand(string: pattern)
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
     
        if capitalisation == .initial {
            return phrase.prefix(1).capitalized + phrase.dropFirst()
        } else if capitalisation == .word {
            
            return phrase.split(separator: " ").map {
                $0.prefix(1).capitalized + $0.dropFirst()
            }.joined(separator: " ")
        } else {
            return phrase
        }
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


public struct InnName: Generatable {
    public var patterns: [String] = []
    public var patternFileName: String = "inns"
    public var capitalisation = CapitalisationType.word
    public init(){}
}


public struct VillageName: Generatable {
    public var patterns: [String] = []
    public var patternFileName: String = "villagename"
    public var capitalisation = CapitalisationType.word
    public init(){}
}

public struct MealName: Generatable {
    public var patterns: [String] = []
    public var patternFileName: String = "meal"
    public var capitalisation = CapitalisationType.initial
    public init(){}
}

public struct HumanName: Generatable {
    public var patterns: [String] = []
    public var patternFileName: String = "humanname"
    public var capitalisation = CapitalisationType.word
    public init(){}
}

public struct DwarfName: Generatable {
    public var patterns: [String] = []
    public var patternFileName: String = "dwarfname"
    public var capitalisation = CapitalisationType.word
    public init(){}
}

public struct ElfName: Generatable {
    public var patterns: [String] = []
    public var patternFileName: String = "elfname"
    public var capitalisation = CapitalisationType.word
    public init(){}
}

public struct OrcName: Generatable {
    public var patterns: [String] = []
    public var patternFileName: String = "orcname"
    public var capitalisation = CapitalisationType.word
    public init(){}
}

public struct BeerName: Generatable {
    public var patterns: [String] = []
    public var patternFileName: String = "beer"
    public var capitalisation = CapitalisationType.word
    public init(){}
}

public struct BeerDescription: Generatable {
    public var patterns: [String] = []
    public var patternFileName: String = "beerdescription"
    public var capitalisation = CapitalisationType.initial
    public init(){}
}

public struct OddityDescription: Generatable {
    public var patterns: [String] = []
    public var patternFileName: String = "oddity"
    public var capitalisation = CapitalisationType.initial
    public init(){}
}

public struct IndustryDescription: Generatable {
    public var patterns: [String] = []
    public var patternFileName: String = "industry"
    public var capitalisation = CapitalisationType.initial
    public init(){}
}

public struct LocationDescription: Generatable {
    public var patterns: [String] = []
    public var patternFileName: String = "location"
    public var capitalisation = CapitalisationType.initial
    public init(){}
}

public struct ActionOracle: Generatable {
    public var patterns: [String] = []
    public var patternFileName: String = "action"
    public var capitalisation = CapitalisationType.initial
    public init(){}
}

public struct DangerOracle: Generatable {
    public var patterns: [String] = []
    public var patternFileName: String = "danger"
    public var capitalisation = CapitalisationType.initial
    public init(){}
}
