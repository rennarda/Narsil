//
//  File.swift
//  
//
//  Created by Andrew Rennard on 07/03/2021.
//

import Foundation

public struct Inn: Codable {
    public let name: String
    public let food: [String]
    public let beer: [Beer]
}

extension Inn: Hashable {
    public static func == (lhs: Inn, rhs: Inn) -> Bool {
        lhs.name == rhs.name
    }
}
