import Foundation

public enum DungeonRoomFeature: String, Hashable, Sendable {
    case stairway
    case shrine
    case fountain
    case library
    case armory
    case barracks
    case throne
    case cavern
    case vault
    case camp
    case bridge
    case column
    case statue
    case debris
    case brazier
    case altar
    case crevasse
    case woodenDoor
    case secretDoor
    case barredGate
    case archway

    fileprivate var oddityPattern: String {
        "dungeonroom\(rawValue)"
    }

    fileprivate var roomNamePattern: String {
        switch self {
        case .woodenDoor, .secretDoor, .barredGate, .archway:
            "dungeonroomname"
        default:
            "dungeonroom\(rawValue)name"
        }
    }
}

public enum DungeonRoomExitDirection: String, Hashable, Sendable {
    case north
    case east
    case south
    case west
}

public enum DungeonRoomDoorCondition: String, CaseIterable, Codable, Hashable, Sendable {
    case open
    case ajar
    case closed
    case jammed
    case locked
    case sealed
    case barred
    case broken
    case blocked

    public var hasLock: Bool {
        self == .locked
    }

    fileprivate var descriptionPattern: String {
        "dungeonroomdoorcondition\(rawValue)"
    }
}

public enum DungeonRoomWaterDepth: String, Codable, Hashable, Sendable {
    case damp
    case shallow
    case moderate
    case deep

    fileprivate var atmospherePattern: String {
        switch self {
        case .damp: "dungeonroomwaterdamp"
        case .shallow: "dungeonroomwatershallow"
        case .moderate: "dungeonroomwatermoderate"
        case .deep: "dungeonroomwaterdeep"
        }
    }
}

public enum DungeonRoomExit: Hashable, Sendable {
    case woodenDoor
    case secretDoor
    case barredGate
    case archway
    case corridor(DungeonRoomExitDirection)

    fileprivate var descriptionPattern: String {
        switch self {
        case .woodenDoor: "dungeonroomwoodendoor"
        case .secretDoor: "dungeonroomsecretdoor"
        case .barredGate: "dungeonroombarredgate"
        case .archway: "dungeonroomarchway"
        case .corridor(.north): "dungeonroomcorridornorth"
        case .corridor(.east): "dungeonroomcorridoreast"
        case .corridor(.south): "dungeonroomcorridorsouth"
        case .corridor(.west): "dungeonroomcorridorwest"
        }
    }

    public var availableDoorConditions: [DungeonRoomDoorCondition] {
        switch self {
        case .archway:
            [.open, .jammed, .sealed, .broken, .blocked]
        case .corridor:
            []
        case .woodenDoor, .secretDoor, .barredGate:
            DungeonRoomDoorCondition.allCases
        }
    }

    public func description(
        condition: DungeonRoomDoorCondition? = nil
    ) -> String {
        var descriptionGenerator = Generator(pattern: descriptionPattern)
        let description = descriptionGenerator.generate()
        guard let condition = condition ?? availableDoorConditions.randomElement() else {
            return description
        }

        var conditionGenerator = Generator(pattern: condition.descriptionPattern)
        return "\(description) \(conditionGenerator.generate())"
    }
}

public struct DungeonRoomDescription: Equatable, Sendable {
    public let roomName: String
    public let atmosphere: String
    public let oddity: String
    public let danger: String?
    public let occupants: String?
    public let exits: [String]

    public init(
        roomName: String,
        atmosphere: String,
        oddity: String,
        danger: String? = nil,
        occupants: String? = nil,
        exits: [String] = []
    ) {
        self.roomName = roomName
        self.atmosphere = atmosphere
        self.oddity = oddity
        self.danger = danger
        self.occupants = occupants
        self.exits = exits
    }
}

public struct DungeonRoomDetailsGenerator {
    public var features: [DungeonRoomFeature]
    public var exits: [DungeonRoomExit]
    public var waterDepth: DungeonRoomWaterDepth?
    private var atmosphereGenerator: Generator

    public init(
        features: [DungeonRoomFeature] = [],
        exits: [DungeonRoomExit] = [],
        waterDepth: DungeonRoomWaterDepth? = nil
    ) {
        self.features = features
        self.exits = exits
        self.waterDepth = waterDepth
        atmosphereGenerator = Generator(
            pattern: waterDepth?.atmospherePattern ?? "dungeonroomatmosphere"
        )
    }

    public mutating func generate() -> DungeonRoomDescription {
        let atmosphere = atmosphereGenerator.generate()
        let roomFeatures = features.filter { feature in
            feature != .woodenDoor
                && feature != .secretDoor
                && feature != .barredGate
                && feature != .archway
        }
        let notableFeatures = roomFeatures.filter {
            $0 == .statue || $0 == .fountain
        }
        let feature = notableFeatures.randomElement() ?? roomFeatures.randomElement()
        let oddityFeatures: [DungeonRoomFeature]
        if notableFeatures.isEmpty {
            oddityFeatures = feature.map { [$0] } ?? []
        } else {
            oddityFeatures = notableFeatures
        }
        let roomNamePattern = feature?.roomNamePattern ?? "dungeonroomname"
        let oddity: String
        if oddityFeatures.isEmpty {
            var oddityGenerator = Generator(pattern: "dungeonroominterestingthing")
            oddity = oddityGenerator.generate()
        } else {
            oddity = oddityFeatures.map { feature in
                var oddityGenerator = Generator(pattern: feature.oddityPattern)
                return oddityGenerator.generate()
            }
            .joined(separator: " ")
        }
        var roomNameGenerator = Generator(
            pattern: roomNamePattern,
            capitalisation: .word
        )
        let occupants: String?
        if Int.random(in: 0..<5) == 0 {
            var occupantGenerator = Generator(pattern: "dungeonroomoccupant")
            occupants = occupantGenerator.generate()
        } else {
            occupants = nil
        }
        let danger: String?
        if Int.random(in: 0..<3) == 0 {
            var dangerGenerator = Generator(pattern: "dungeonroomdanger")
            danger = dangerGenerator.generate()
        } else {
            danger = nil
        }
        let exitDescriptions = exits.map { $0.description() }

        return DungeonRoomDescription(
            roomName: roomNameGenerator.generate(),
            atmosphere: atmosphere,
            oddity: oddity,
            danger: danger,
            occupants: occupants,
            exits: exitDescriptions
        )
    }
}
