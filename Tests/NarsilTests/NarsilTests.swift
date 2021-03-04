import XCTest
@testable import Narsil


final class NarsilTests: XCTestCase {
    var phraseGenerator = PhraseGenerator()
    let iterations = 101
    
    func generate(_ generator:Generatable) {
        var generatorCopy = generator
        for _ in 0..<iterations {
            print(generatorCopy.generate(with: phraseGenerator))
        }
    }

    func testOddities() {
        generate(OddityDescription())
    }

    func testMeals(){
        generate(MealName())
    }
    
    func testInns(){
        generate(InnName())
    }
    
    func testBeers(){
        generate(BeerName())
    }
    
    func testVillages(){
        generate(VillageName())
    }

    func testLocation(){
        generate(LocationDescription())
    }

}
