struct Narsil {
    var text = "Hello, World!"
    
    var generator = PhraseGenerator()
    
    mutating func generate(){
        generator.loadWordLists()
        var innGenerator = InnName()
        var villageNameGenerator = VillageName()
        var mealGenerator = MealName()
        var humanNameGenerator = HumanName()
        var beerGenerator = BeerName()
        var beerDescriptionGenerator = BeerDescription()
        var phrases: [String] = []
        var oddityGenerator = OddityDescription()
        var settlements: [Settlement] = []
        for _ in 0..<101 {
            

//            phrases.append(
//                mealGenerator.generate(with: generator)
//                + " at "
//                + innGenerator.generate(with: generator)
//                + " in "
//                + villageNameGenerator.generate(with: generator)
//            )

//            phrases.append(
//                    innGenerator.generate(with: generator)
//                    + " in "
//                    + villageNameGenerator.generate(with: generator)
//            )

//            settlements.append(
//                SettlementGenerator.generate()
//            )

//            phrases.append(
//                    beerGenerator.generate(with: generator) + ", " +
//                    beerDescriptionGenerator.generate(with: generator)
//
//            )

//            phrases.append(
//                    beerDescriptionGenerator.generate(with: generator)
//            )
            
            
//            phrases.append(
//                humanNameGenerator.generate(with: generator)
//            )

            phrases.append(
                    oddityGenerator.generate(with: generator)
            )

            
        }
//        for (index, phrase) in phrases.sorted().enumerated() {
//            print("\(index+1): \(phrase)")
//        }

        for (index, settlement) in settlements.enumerated() {
            print("\(index+1): \(settlement.description)")
        }


    }
}

