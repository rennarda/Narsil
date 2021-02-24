struct Narsil {
    var text = "Hello, World!"
    
    var generator = PhraseGenerator()
    
    mutating func generate(){
        generator.loadWordLists()
        var innGenerator = Inn()
        var villageGenerator = Village()
        var mealGenerator = Meal()
        var humanNameGenerator = HumanName()
        var phrases: [String] = []
        for _ in 0..<101 {
            

//            phrases.append(
//                mealGenerator.generate(with: generator)
//                + " at "
//                + innGenerator.generate(with: generator)
//                + " in "
//                + villageGenerator.generate(with: generator)
//            )

//            phrases.append(
//                    innGenerator.generate(with: generator)
//                    + " in "
//                    + villageGenerator.generate(with: generator)
//            )

            phrases.append(
                humanNameGenerator.generate(with: generator)
            )

            
            
        }
        for (index, phrase) in phrases.sorted().enumerated() {
            print("\(index+1): \(phrase)")
        }
    }
}

