//
//  File.swift
//  
//
//  Created by Andrew Rennard on 07/03/2021.
//

import Foundation

public struct Settlement: Codable {
    public var name: String
    public let size: SettlementSize
    public let population: Int
    public let industries: [String]
    public let inns: [Inn]
    public let facilities: [Facility]
    public let fame: String


    public init(name: String, size: SettlementSize, population: Int, industries: [String], inns: [Inn], facilities: [Facility], fame: String) {
        self.name = name
        self.size = size
        self.population = population
        self.industries = industries
        self.inns = inns
        self.facilities = facilities
        self.fame = fame
    }
}

extension Settlement: Hashable {
    public static func == (lhs: Settlement, rhs: Settlement) -> Bool {
        lhs.name == rhs.name && lhs.population == rhs.population
    }
}

extension Settlement: CustomStringConvertible {
    public var description: String {
        "\(name) \(size.sizeDescription(for: population)) \(size): \(population). \(facilities.map{$0.rawValue}), \(inns.map{$0.name}), \(industries). \(fame)"
    }
    
}
