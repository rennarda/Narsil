//
//  File.swift
//  
//
//  Created by AndyRennard on 01/03/2021.
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

public struct Inn {
    public let name: String
    public let food: [String]
    public let beer: [Beer]
}

extension Inn: Hashable {
    public static func == (lhs: Inn, rhs: Inn) -> Bool {
        lhs.name == rhs.name
    }
}

public enum Facility: String, CaseIterable {
    case mill, smith, forester, tradingPost, temple, militia, stable, guild, inn
    
    var probability: Double {
        switch self {
            case .mill:
                return 0.8
            case .smith:
                return 0.8
            case .forester:
                return 0.45
            case .tradingPost:
                return 0.95
            case .temple:
                return 0.75
            case .militia:
                return 0.5
            case .stable:
                return 0.6
            case .guild:
                return 0.45
            case .inn:
                return 0.95
        }
    }
}

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

public struct Settlement {
    public let name: String
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

public struct SettlementGenerator {
    public static func generate() -> Settlement {
        let generator = PhraseGenerator()
        var villageNameGenerator = VillageName()
        var innNameGenerator = InnName()
        var mealGenerator = MealName()
        var beerGenerator = BeerName()
        var beerDescription = BeerDescription()
        var oddityGenerator = OddityDescription()
        var industryGenerator = IndustryDescription()

        let name = villageNameGenerator.generate(with: generator)
        let size = SettlementSize.generate()
        let population = size.generatePopulation()
        let fame = oddityGenerator.generate(with: generator)
        
        var facilities: [Facility] = []
        for facility in Facility.allCases {
            if Double.random(in: 0..<1.0) < facility.probability * size.facilityProbability {
                facilities.append(facility)
            }
        }
        
        var inns: [Inn] = []
        if facilities.contains(.inn) {
            for _ in 0..<size.numberOfInns(for: population) {
                let innName = innNameGenerator.generate(with: generator)
                var meals: [String] = []
                var beers: [Beer] = []
                
                for _ in 0..<Int.random(in: 2...4) {
                    meals.append(mealGenerator.generate(with: generator))
                }
                for _ in 0..<Int.random(in: 2...3) {
                    beers.append(Beer(name: beerGenerator.generate(with: generator), description: beerDescription.generate(with: generator)))
                }

                inns.append(Inn(name: innName, food: meals, beer: beers))
            }
        }
        
        var industries: [String] = []
        for _ in 0..<size.numberOfIndustries(for: population) {
            industries.append(industryGenerator.generate(with: generator))
        }
        
        return Settlement(name: name, size: size, population: population, industries: industries , inns: inns, facilities: facilities, fame: fame)
    }
}
