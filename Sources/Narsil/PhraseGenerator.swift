//
//  File.swift
//  
//
//  Created by Andrew Rennard on 23/02/2021.
//

import Foundation

struct PhraseGenerator {
    var words: Dictionary<WordType, [String]> = [:]
    
    func substitute(for keyword: String) -> String {
        var activeKeyword = keyword
        if keyword.contains("|") {
            activeKeyword = String(keyword.split(separator: "|").randomElement()!)
        }
        
        guard let wordType = WordType(rawValue: activeKeyword.lowercased()),
              let wordArray = words[wordType],
              let word = wordArray.randomElement()
        else { return "INVALID" }

        if keyword.first!.isUppercase {
            return word.prefix(1).capitalized + word.dropFirst()
        } else {
            return word
        }
    }

    func expand(string: String) -> String {
        let regEx = try! NSRegularExpression(pattern: "\\[([\\w|]*)]", options: [])
        guard let match = regEx.firstMatch(in: string, options: [], range: NSRange(string.startIndex..<string.endIndex, in: string))
        else { return string }

        let outerMatch = match.range(at: 0)
        let innerMatch = match.range(at: 1)
        let substitution = substitute(for: String(string.substring(innerMatch)))
        return expand(string: string.replacingCharacters(in: string.swiftRange(outerMatch), with: substitution))
    }
    
    mutating func loadWordLists(){
        WordType.allCases.forEach { type in
            guard let fileURL = Bundle.module.url(forResource: "wordlists/\(type.rawValue)", withExtension: "txt"),
                  let lines = try? String(contentsOf: fileURL)
            else {
                return
            }
            words[type] = lines.components(separatedBy: .newlines).dropLast()
        }
        print(words)
    }
}
