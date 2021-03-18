//
//  File.swift
//  
//
//  Created by AndyRennard on 01/03/2021.
//

import Foundation

public struct SettlementGenerator {
    public static let sharedGenerator = PhraseGenerator()
    public static func generate() -> Settlement {
        var villageNameGenerator = VillageName()
        var oddityGenerator = OddityDescription()
        var industryGenerator = IndustryDescription()

        let name = villageNameGenerator.generate()
        let size = SettlementSize.generate()
        let population = size.generatePopulation()
        let fame = oddityGenerator.generate()
        
        var facilities: [Facility] = []
        for facility in Facility.allCases {
            if Double.random(in: 0..<1.0) < facility.probability * size.facilityProbability {
                facilities.append(facility)
            }
        }
        
        var inns: [Inn] = []
        if facilities.contains(.inn) {
            inns = generateInns(forPopulation: population, size: size)
        }
        
        var industries: [String] = []
        for _ in 0..<size.numberOfIndustries(for: population) {
            industries.append(industryGenerator.generate())
        }
        
        return Settlement(name: name, size: size, population: population, industries: industries , inns: inns, facilities: facilities, fame: fame)
    }
    
    static func generateInns(forPopulation population: Int, size: SettlementSize) -> [Inn] {
        var innNameGenerator = InnName()
        var mealGenerator = MealName()
        var beerGenerator = BeerName()
        var beerDescription = BeerDescription()

        var inns: [Inn] = []
        for _ in 0..<size.numberOfInns(for: population) {
            let innName = innNameGenerator.generate()
            var meals: [String] = []
            var beers: [Beer] = []
            
            for _ in 0..<Int.random(in: 2...4) {
                meals.append(mealGenerator.generate())
            }
            for _ in 0..<Int.random(in: 2...3) {
                beers.append(Beer(name: beerGenerator.generate(), description: beerDescription.generate()))
            }
            
            inns.append(Inn(name: innName, food: meals, beer: beers))
        }
        return inns
    }
    
    public static func regenerateName(for settlement: Settlement) -> Settlement {
        var villageNameGenerator = VillageName()

        return Settlement(name: villageNameGenerator.generate(), size: settlement.size, population: settlement.population, industries: settlement.industries , inns: settlement.inns, facilities: settlement.facilities, fame: settlement.fame)
    }

    public static func regenerateInns(for settlement: Settlement) -> Settlement {
        
        return Settlement(name: settlement.name, size: settlement.size, population: settlement.population, industries: settlement.industries , inns: generateInns(forPopulation: settlement.population, size: settlement.size), facilities: settlement.facilities, fame: settlement.fame)
    }

}
