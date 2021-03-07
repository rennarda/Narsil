//
//  File.swift
//  
//
//  Created by Andrew Rennard on 07/03/2021.
//

import Foundation

public enum SettlementSize: String {
    case outpost, hamlet, village, town, city

    static func generate() -> SettlementSize {
        let random = Double.random(in: 0..<1)
        if 0.0..<0.1 ~= random {
            return .outpost
        } else if 0.1..<0.3 ~= random {
            return .hamlet
        } else if 0.3..<0.75 ~= random {
            return .village
        } else if 0.75..<0.95 ~= random {
            return .town
        } else {
            return .city
        }
    }
    
    func generatePopulation() -> Int {
        return Int.random(in: minPop..<maxPop)
    }
    
    var minPop: Int {
        switch self {
            case .outpost:
                return 4
            case .hamlet:
                return 10
            case .village:
                return 100
            case .town:
                return 400
            case .city:
                return 5_000
        }
    }

    var maxPop: Int {
        switch self {
            case .outpost:
                return 10
            case .hamlet:
                return 200
            case .village:
                return 400
            case .town:
                return 5000
            case .city:
                return 500_000
        }
    }

    public func sizeDescription(for population: Int) -> String {
        if population < Int(Double(maxPop) * 0.4) {
            return "small"
        } else if population > Int(Double(maxPop) * 0.8) {
            return "large"
        } else {
            return "medium"
        }
    }
    
    var facilityProbability: Double {
        switch self {
            case .outpost:
                return 0.1
            case .hamlet:
                return 0.3
            case .village:
                return 0.8
            case .town:
                return 1.0
            case .city:
                return 1.9
        }
    }
    
    // how many inns per 1000 people?
    func numberOfInns(for population:Int) -> Int {
        let factor = Double(population) / Double(self.maxPop)
        switch self {
            case .city:
                return max(10,Int(Double.random(in: 10...20) * factor))
            case .town:
                return max(4, Int(Double.random(in: 4...10) * factor))
            case .village:
                return max(1, Int(Double.random(in: 1...4) * factor))
            case .hamlet:
                return max(1, Int(Double.random(in: 1...2) * factor))
            case .outpost:
                return 1
        }
    }

    // how many inns per 1000 people?
    func numberOfIndustries(for population:Int) -> Int {
        let factor = Double(population) / Double(self.maxPop)
        switch self {
            case .city:
                return max(5,Int(Double.random(in: 5...8) * factor))
            case .town:
                return max(3, Int(Double.random(in: 3...5) * factor))
            case .village:
                return max(1, Int(Double.random(in: 1...3) * factor))
            case .hamlet, .outpost:
                return 1
        }
    }
}
