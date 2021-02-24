struct Narsil {
    var text = "Hello, World!"
    
    var generator = PhraseGenerator()
    
    mutating func generate(){
        generator.loadWordLists()
        var inGenerator = Inns()
        for _ in 0..<100 {
            
//            print(generator.expand(string: "The [InnFirstName|Number] [InnSecondName] at [villageprefix][villagesuffix] [villagesecond]"))
            print(inGenerator.generate(with: generator))
        }
    }
}

