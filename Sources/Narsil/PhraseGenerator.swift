//
//  PhraseGenerator.swift
//  
//
//  Created by Andrew Rennard on 23/02/2021.
//

import Foundation

public struct PhraseGenerator {
    public static var shared = PhraseGenerator()
    private var words: Dictionary<String, [String]> = [:]
        
    public init(){}
    
    mutating func substitute(for keyword: String) -> String {
        var activeKeyword = keyword
        if keyword.contains("|") {
            activeKeyword = String(keyword.split(separator: "|").randomElement()!)
        }
        
        let wordToReturn: String
        let wordType = activeKeyword.lowercased()
        
        if let word = randomWord(wordType: wordType)
        {
            wordToReturn = word
            
        } else {
            wordToReturn = activeKeyword
        }

        if keyword.first!.isUppercase {
            return wordToReturn.prefix(1).capitalized + wordToReturn.dropFirst()
        } else {
            return wordToReturn
        }
    }

    mutating func expand(string: String) -> String {
        print(string)
        let regEx = try! NSRegularExpression(pattern: "\\[([\\w|\\.\\-\\d',&\\(\\)\\s]*):?(\\d+\\.\\d+)?]", options: [])
        guard let match = regEx.firstMatch(in: string, options: [], range: NSRange(string.startIndex..<string.endIndex, in: string))
        else { return string }

        let outerMatch = match.range(at: 0)
        let innerMatch = match.range(at: 1)
        let chanceMatch = match.range(at: 2)
        var chance: Double = 1.0
        if chanceMatch.location != NSNotFound {
            chance = Double(string.substring(chanceMatch)) ?? 1.0
        }
        var substitution: String = ""
        if Double.random(in: 0.0..<1.0) < chance {
             substitution = substitute(for: String(string.substring(innerMatch)))
        }
        
        // Is the match a numeric range?
        let rangeComponents = string.substring(innerMatch).split(separator: "-")
        if rangeComponents.count == 2,
           let from = Int(rangeComponents[0]),
           let to = Int(rangeComponents[1])
        {
            substitution = String(Int.random(in: from...to))
        }
        
        if string.substring(NSRange(location: 0, length: outerMatch.location)).contains(substitution){
            // word already exists, try again!
            return expand(string: string)
        } else {
            return expand(string: string.replacingCharacters(in: string.swiftRange(outerMatch), with: substitution))
        }
    }
    
    mutating func randomWord(wordType: String) -> String? {
        if let wordArray = words[wordType] {
            return wordArray.randomElement()
        }
        
        guard let fileURL = Bundle.module.url(forResource: "wordlists/\(wordType)", withExtension: "txt"),
              let lines = try? String(contentsOf: fileURL)
        else {
            return nil
        }
        words[wordType] = lines.components(separatedBy: .newlines).filter{$0.count > 0}
        return lines.components(separatedBy: .newlines).dropLast().randomElement()
    }
}
