struct Narsil {
    var text = "Hello, World!"
    
    var generator = PhraseGenerator()
    
    mutating func generate(){
        generator.loadWordLists()
        var innGenerator = Inn()
        var villageGenerator = Village()
        var phrases: [String] = []
        for _ in 0..<101 {
            
//            print(generator.expand(string: "The [InnFirstName|Number] [InnSecondName] at [villageprefix][villagesuffix] [villagesecond]"))
            phrases.append(innGenerator.generate(with: generator) + " at " + villageGenerator.generate(with: generator))
//            print(innGenerator.generate(with: generator) + " at " + villageGenerator.generate(with: generator))
        }
        for (index, phrase) in phrases.sorted().enumerated() {
            print("\(index+1): \(phrase)")
        }
    }
}

