//
//  File.swift
//  
//
//  Created by Andrew Rennard on 21/03/2021.
//

import Foundation

@propertyWrapper
struct Constrained {
    var value: Double
    var maxValue: Double = 1.0
    var minValue: Double = 0.0
    
    var wrappedValue: Double {
        get {
            value
        }
        set {
            value = max(min(newValue, maxValue), minValue)
        }
    }
}

public struct Weather {
    @Constrained(value: 0.5, maxValue: 1.0, minValue: 0.0)
    public var cloudValue

    @Constrained(value: 0.5, maxValue: 1.0, minValue: 0.0)
    public var precipitationValue

    @Constrained(value: 0.5, maxValue: 1.0, minValue: 0.0)
    public var tempValue

    @Constrained(value: 0.5, maxValue: 1.0, minValue: 0.0)
    public var windValue

    public init(){}
    
    public mutating func generate() {
        windValue = update(value: windValue)
        tempValue = update(value: tempValue)
        precipitationValue = update(value: precipitationValue)
        cloudValue = update(value: cloudValue)
        print(tempDescription, windDescription, cloudDescription, precipitationDescription)
    }
    
    private func update(value: Double) -> Double {
        let randomValue = Double.random(in: 0.0...1.0)
        if randomValue > value {
            return value + 0.1
        } else if randomValue < value {
            return value - 0.1
        } else {
            return value
        }
    }
    
    public var windDescription: String {
        switch windValue {
            case 0.0..<0.2:
                return "Exceptionally Calm"
            case 0.2..<0.4:
                return "Unusually Calm"
            case 0.4..<0.5:
                return "Settled"
            case 0.5..<0.6:
                return "Breezy"
            case 0.6..<0.7:
                return "Windy"
            case 0.7..<0.8:
                return "Unusually Windy"
            case 0.8..<1.0:
                return "Exceptionally Windy"
            default:
                return "Unknown"
        }
    }

    public var tempDescription: String {
        switch tempValue {
            case 0.0..<0.2:
                return "10º below normal"
            case 0.2..<0.3:
                return "5º below normal"
            case 0.3..<0.4:
                return "2-3º below normal"
            case 0.4..<0.6:
                return "Average"
            case 0.6..<0.7:
                return "2-3º above normal"
            case 0.7..<0.8:
                return "5º above normal"
            case 0.8..<1.0:
                return "10º above normal"
            default:
                return "Unknown"
        }
    }

    public var cloudDescription: String {
        switch cloudValue {
            case 0.0..<0.2:
                return "Exceptionally Clear"
            case 0.2..<0.3:
                return "Unusually Clear"
            case 0.3..<0.4:
                return "Scattered Clouds"
            case 0.4..<0.6:
                return "Broken Clouds"
            case 0.6..<0.7:
                return "Cloudy"
            case 0.7..<0.8:
                return "Very Cloudy"
            case 0.8..<1.0:
                return "Exceptionally Cloudy"
            default:
                return "Unknown"
        }
    }

    public var precipitationDescription: String {
        switch (cloudValue, precipitationValue) {
            case (0.0..<0.3, _), (_, 0.0..<0.5):
                return "None"
            case (0.3..<0.6,0.5..<0.6):
                return "Light scattered showers"
            case (0.3..<0.6,0.6..<0.7):
                return "Scattered showers"
            case (0.3..<0.6,0.7..<0.8):
                return "Scattered heavy showers"
            case (0.3..<0.6,0.8..<1.0):
                return "Scattered downpoars"
            case (0.6..<1.0, 0.5..<0.6):
                return "Drizzle"
            case (0.6..<1.0, 0.6..<0.7):
                return "Light persistent rain"
            case (0.6..<1.0, 0.7..<0.8):
                return "Persistent rain"
            case (0.6..<1.0, 0.8..<0.9):
                return "Persistent heavy rain"
            case (0.6..<1.0, 0.9..<1.0):
                return "Persistent torrential rain"
            default:
                return "Unknown"
        }
    }
}
