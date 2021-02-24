struct Narsil {
    var text = "Hello, World!"
    
    var generator = PhraseGenerator()
    
    mutating func generate(){
        generator.loadWordLists()
        var innGenerator = Inn()
        var villageGenerator = Village()
        for _ in 0..<100 {
            
//            print(generator.expand(string: "The [InnFirstName|Number] [InnSecondName] at [villageprefix][villagesuffix] [villagesecond]"))
            print(innGenerator.generate(with: generator) + " at " + villageGenerator.generate(with: generator))
        }
    }
}

