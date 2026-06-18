import XCTest
@testable import Narsil


final class NarsilTests: XCTestCase {
    var phraseGenerator = PhraseGenerator()
    let iterations = 101
    
    func generate(_ generator:Generatable) {
        var generatorCopy = generator
        for _ in 0..<iterations {
            print(generatorCopy.generate())
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

    func testAction(){
        generate(ActionOracle())
    }

    func testDanger(){
        generate(DangerOracle())
    }

    func testGeneric(){
        generate(Generator(pattern: "plothook"))
//        generate(Generator(pattern: "treasure"))
    }

    func testModernName() {
        generate(Generator(pattern: "modernmale"))
        generate(Generator(pattern: "modernfemale"))
    }

    func testHumanNameUsesMedievalEnglishResources() {
        var generator = HumanName()
        generator.loadPatterns()

        XCTAssertFalse(generator.patterns.isEmpty)
        XCTAssertFalse(generator.patterns.contains { $0.localizedCaseInsensitiveContains("syllable") })
        XCTAssertFalse(generator.patterns.contains { $0.localizedCaseInsensitiveContains("[Surname]") })
        XCTAssertTrue(generator.patterns.allSatisfy { $0.localizedCaseInsensitiveContains("medievalenglish") })
        XCTAssertFalse(generator.patterns.contains { $0.contains("[MedievalEnglish") })

        for _ in 0..<iterations {
            let name = generator.generate()

            XCTAssertFalse(name.contains("["))
            XCTAssertFalse(name.contains("]"))
            XCTAssertGreaterThanOrEqual(name.split(separator: " ").count, 2)
        }
    }

    func testHumanNamePreservesMedievalParticles() {
        let generator = HumanName()

        guard case .none = generator.capitalisation else {
            XCTFail("HumanName should preserve resource casing so particles like 'of', 'the', and 'atte' remain lowercase.")
            return
        }
    }

    func testMedievalEnglishLocativeBynamesUseGeneratedVillageNames() {
        var generator = Generator(pattern: "medievalenglishlocativebyname", capitalisation: .none)
        generator.loadPatterns()

        XCTAssertTrue(generator.patterns.contains { $0.localizedCaseInsensitiveContains("[villagename]") })
        XCTAssertFalse(generator.patterns.contains { $0.hasPrefix("of ") && !$0.localizedCaseInsensitiveContains("[villagename]") })
    }

    func testMedievalEnglishSurnamesAreBroadAndUnique() {
        var generator = Generator(pattern: "medievalenglishsurname", capitalisation: .none)
        generator.loadPatterns()

        let uniqueSurnames = Set(generator.patterns)

        XCTAssertGreaterThanOrEqual(generator.patterns.count, 150)
        XCTAssertEqual(generator.patterns.count, uniqueSurnames.count)
    }

    func testIndefiniteArticleCorrectionOnlyChangesStandaloneArticle() {
        XCTAssertEqual("a apple".correctIndefiniteArticle(), "an apple")
        XCTAssertEqual("Juliana of York".correctIndefiniteArticle(), "Juliana of York")
    }
    
    func testCyberpunkJob(){
        generate(Generator(pattern: "cyberpunkjob"))
//        generate(Generator(pattern: "cyberpunkcomplication"))
    }

    func testGangName(){
        generate(Generator(pattern: "gangname"))
    }

    func testHandle(){
        generate(Generator(pattern: "handle"))
    }

    func testShipName(){
        generate(Generator(pattern: "shipname"))
    }

}
