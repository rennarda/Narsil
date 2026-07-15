import Testing
@testable import Narsil

struct DungeonRoomDetailsTests {
    @Test
    func generatedDetailIncludesAtmosphereAndStatue() {
        var generator = DungeonRoomDetailsGenerator(features: [.statue])

        let detail = generator.generate()

        #expect(detail.atmosphere.isEmpty == false)
        #expect(detail.oddity.localizedCaseInsensitiveContains("statue"))
    }

    @Test
    func statueDetailsAlwaysNameTheirSubjectAndMaterial() {
        var subjectGenerator = Generator(pattern: "dungeonroomstatuesubject")
        subjectGenerator.loadPatterns()
        var materialGenerator = Generator(pattern: "dungeonroomstatuematerial")
        materialGenerator.loadPatterns()
        var generator = DungeonRoomDetailsGenerator(features: [.statue])

        for _ in 0..<20 {
            let oddity = generator.generate().oddity.lowercased()
            #expect(
                subjectGenerator.patterns.contains {
                    oddity.contains($0.lowercased())
                }
            )
            #expect(
                materialGenerator.patterns.contains {
                    oddity.contains($0.lowercased())
                }
            )
        }
    }

    @Test
    func generatedDetailNamesAFeatureRoomWithAnAdjectiveAndPurpose() {
        var generator = DungeonRoomDetailsGenerator(features: [.fountain])

        let detail = generator.generate()

        #expect(detail.roomName.split(separator: " ").count >= 2)
        #expect(detail.roomName.localizedCaseInsensitiveContains("fountain"))
    }

    @Test(arguments: [
        (DungeonRoomFeature.fountain, "fountain"),
        (DungeonRoomFeature.brazier, "brazier"),
        (DungeonRoomFeature.crevasse, "crevasse")
    ])
    func generatedDetailUsesTheSuppliedRoomFeature(
        feature: DungeonRoomFeature,
        noun: String
    ) {
        var generator = DungeonRoomDetailsGenerator(features: [feature])

        let detail = generator.generate()

        #expect(detail.oddity.localizedCaseInsensitiveContains(noun))
    }

    @Test(arguments: [
        ([DungeonRoomFeature.statue, .brazier], "statue"),
        ([DungeonRoomFeature.fountain, .altar], "fountain")
    ])
    func statuesAndFountainsTakePriorityOverOtherRoomFeatures(
        features: [DungeonRoomFeature],
        noun: String
    ) {
        var generator = DungeonRoomDetailsGenerator(features: features)

        for _ in 0..<20 {
            #expect(
                generator.generate().oddity
                    .localizedCaseInsensitiveContains(noun)
            )
        }
    }

    @Test
    func aRoomWithAStatueAndFountainAlwaysDescribesBoth() {
        var generator = DungeonRoomDetailsGenerator(features: [.statue, .fountain])

        for _ in 0..<20 {
            let oddity = generator.generate().oddity.lowercased()
            #expect(oddity.contains("statue"))
            #expect(oddity.contains("fountain"))
        }
    }

    @Test(arguments: [
        (DungeonRoomExit.woodenDoor, "wooden door"),
        (DungeonRoomExit.secretDoor, "secret door"),
        (DungeonRoomExit.barredGate, "iron bars"),
        (DungeonRoomExit.archway, "archway"),
        (DungeonRoomExit.corridor(.north), "north")
    ])
    func generatedDetailDescribesTheSuppliedExit(
        exit: DungeonRoomExit,
        noun: String
    ) {
        var generator = DungeonRoomDetailsGenerator(exits: [exit])

        #expect(
            generator.generate().exits.joined(separator: " ")
                .localizedCaseInsensitiveContains(noun)
        )
    }

    @Test(arguments: [
        DungeonRoomExit.woodenDoor,
        .secretDoor,
        .barredGate,
        .archway
    ])
    func doorDescriptionsAlwaysStateTheirCondition(exit: DungeonRoomExit) {
        let conditionWords = [
            "locked", "jammed", "open", "ajar", "shut",
            "closed", "barred", "sealed", "blocked", "broken"
        ]
        var generator = DungeonRoomDetailsGenerator(exits: [exit])

        for _ in 0..<20 {
            let description = generator.generate().exits.joined(separator: " ").lowercased()
            #expect(conditionWords.contains { description.contains($0) })
        }
    }

    @Test
    func exitsAndOccupantsAreSeparateFromTheRoomOddity() {
        var generator = DungeonRoomDetailsGenerator(
            features: [.statue],
            exits: [.barredGate, .corridor(.east)]
        )

        let detail = generator.generate()

        #expect(detail.oddity.localizedCaseInsensitiveContains("statue"))
        #expect(detail.oddity.localizedCaseInsensitiveContains("iron bars") == false)
        #expect(detail.exits.count == 2)
        #expect(detail.exits.contains { $0.localizedCaseInsensitiveContains("iron bars") })
        #expect(detail.exits.contains { $0.localizedCaseInsensitiveContains("east") })
    }

    @Test(arguments: [
        (DungeonRoomWaterDepth.damp, ["damp", "wet", "water", "moisture"]),
        (.moderate, ["water", "wading", "shin", "ankle", "flooded"]),
        (.deep, ["deep", "water", "submerged"])
    ])
    func waterAwareAtmospheresDescribeTheWater(
        depth: DungeonRoomWaterDepth,
        expectedWords: [String]
    ) {
        var generator = DungeonRoomDetailsGenerator(waterDepth: depth)

        for _ in 0..<20 {
            let atmosphere = generator.generate().atmosphere.lowercased()
            let describesWater = expectedWords.contains { atmosphere.contains($0) }
            #expect(describesWater)
        }
    }

    @Test
    func containerDetailExpandsItsConditionAndType() {
        var generator = Generator(pattern: "dungeonroomcontainer")

        for _ in 0..<20 {
            let detail = generator.generate()
            #expect(detail.contains("[") == false)
            #expect(detail.split(separator: " ").count >= 2)
        }
    }

    @Test
    func containerContentsUseResolvedDungeonAndTreasureDetails() {
        var generator = Generator(pattern: "dungeonroomcontainercontents")

        for _ in 0..<20 {
            let contents = generator.generate()
            #expect(contents.isEmpty == false)
            #expect(contents.contains("[") == false)
        }
    }

    @Test
    func roomObjectOdditiesUseAnExpandedDedicatedTable() {
        var generator = Generator(pattern: "dungeonroomobjectoddity")
        generator.loadPatterns()

        let hasExpandedList = generator.patterns.count >= 30
        #expect(hasExpandedList)
        guard hasExpandedList else { return }

        for _ in 0..<20 {
            #expect(generator.generate().contains("[") == false)
        }
    }

    @Test
    func roomInterestingThingsGiveObjectsAHighSelectionWeight() {
        var generator = Generator(pattern: "dungeonroominterestingthing")
        generator.loadPatterns()

        let objectReferences = generator.patterns.filter {
            $0 == "[dungeonroomobject]"
        }
        #expect(objectReferences.count >= 12)
    }

    @Test
    func occupantGeneratorProducesResolvedCurrentOrRecentPresences() {
        var generator = Generator(pattern: "dungeonroomoccupant")

        for _ in 0..<20 {
            let description = generator.generate()
            #expect(description.isEmpty == false)
            #expect(description.contains("[") == false)
        }
    }

    @Test
    func currentOccupantGeneratorIncludesAResolvedDispositionAndActivity() {
        var generator = Generator(pattern: "dungeonroomcurrentoccupant")

        for _ in 0..<20 {
            let description = generator.generate()
            #expect(description.contains(",") == true)
            #expect(description.contains("[") == false)
        }
    }

    @Test
    func currentGroupGeneratorIncludesAResolvedGroupActivity() {
        var generator = Generator(pattern: "dungeonroomcurrentgroup")

        for _ in 0..<20 {
            let description = generator.generate()
            #expect(description.contains(",") == true)
            #expect(description.contains("[") == false)
        }
    }
}
