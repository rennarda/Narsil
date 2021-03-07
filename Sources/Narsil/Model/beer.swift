//
//  File.swift
//  
//
//  Created by Andrew Rennard on 07/03/2021.
//

import Foundation

public struct Beer {
    public let name: String
    public let description: String
}
extension Beer: Hashable {
    public static func == (lhs: Beer, rhs: Beer) -> Bool {
        lhs.name == rhs.name
    }
}
