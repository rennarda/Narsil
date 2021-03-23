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
    
    public mutating func generate(windDM: Double = 0.0,
                                  precipitationDM: Double = 0.0,
                                  tempDM: Double = 0.0,
                                  cloudDM: Double = 0.0
    ) {
        windValue = update(value: windValue, dm: windDM)
        tempValue = update(value: tempValue, dm: tempDM)
        precipitationValue = update(value: precipitationValue, dm:precipitationDM)
        cloudValue = update(value: cloudValue, dm: cloudDM)
        print(tempDescription, windDescription, cloudDescription, precipitationDescription)
    }
    
    private func update(value: Double, dm: Double = 0.0) -> Double {
        let randomValue = Double.random(in: 0.0...1.0) + dm
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
            case 0.8...1.0:
                return "Very Stormy"
            default:
                return "Unknown"
        }
    }

    public var windIconName: String {
        switch windValue {
            case 0.0..<0.5:
                return "aqi.low"
            case 0.5..<0.7:
                return "wind"
            case 0.7..<0.8:
                return "tornado"
            case 0.8...1.0:
                return "hurricane"
            default:
                return "Unknown"
        }
    }
    
    public var tempDescription: String {
        switch tempValue {
            case 0.0..<0.2:
                return "Very Cold"
            case 0.2..<0.3:
                return "Cold"
            case 0.3..<0.4:
                return "Cool"
            case 0.4..<0.6:
                return "Average temperature"
            case 0.6..<0.7:
                return "Warm"
            case 0.7..<0.8:
                return "Very warm"
            case 0.8...1.0:
                return "Hot"
            default:
                return "Unknown"
        }
    }
    
    public var tempIconName: String {
        switch tempValue {
            case 0.0..<0.4:
                return "thermometer.snowflake"
            case 0.4..<0.6:
                return "thermometer"
            case 0.6...1.0:
                return "thermometer.sun"
            default:
                return "Unknown"
        }
    }

    public var cloudDescription: String {
        switch cloudValue {
            case 0.0..<0.2:
                return "Exceptionally Clear"
            case 0.2..<0.3:
                return "Clear"
            case 0.3..<0.4:
                return "Scattered Clouds"
            case 0.4..<0.6:
                return "Broken Clouds"
            case 0.6..<0.7:
                return "Cloudy"
            case 0.7..<0.8:
                return "Very Cloudy"
            case 0.8...1.0:
                return "Overcast"
            default:
                return "Unknown"
        }
    }

    public var cloudIconName: String {
        switch cloudValue {
            case 0.0..<0.2:
                return "sun.max"
            case 0.2..<0.3:
                return "sun.dust"
            case 0.3..<0.4:
                return "sun.haze"
            case 0.4..<0.6:
                return "cloud"
            case 0.6..<0.7:
                return "smoke"
            case 0.7..<0.8:
                return "cloud.fill"
            case 0.8...1.0:
                return "smoke.fill"
            default:
                return "Unknown"
        }
    }

    public var precipitationDescription: String {
        switch (cloudValue, precipitationValue) {
            case (0.0..<0.3, 0.5...):
                return "Foggy"
            case (0.0..<0.3, _), (_, 0.0..<0.5):
                return "No precipitation"
            case (0.3..<0.6,0.5..<0.6):
                return "Light scattered showers"
            case (0.3..<0.6,0.6..<0.7):
                return "Scattered showers"
            case (0.3..<0.6,0.7..<0.8):
                return "Scattered heavy showers"
            case (0.3..<0.6,0.8...1.0):
                return "Scattered downpours"
            case (0.6...1.0, 0.5..<0.6):
                return "Drizzle"
            case (0.6...1.0, 0.6..<0.7):
                return "Light persistent precipitation"
            case (0.6...1.0, 0.7..<0.8):
                return "Persistent precipitation"
            case (0.6...1.0, 0.8..<0.9):
                return "Persistent heavy precipitation"
            case (0.6...1.0, 0.9...1.0):
                return "Persistent torrential precipitation"
            default:
                return "Unknown"
        }
    }

    public var precipitationIconName: String {
        switch (cloudValue, precipitationValue) {
            case (0.0..<0.3, 0.5...):
                return "cloud.fog"
            case (0.0..<0.3, _), (_, 0.0..<0.5):
                return "cloud.sun"
            case (0.3..<0.6,0.5..<0.6):
                return "cloud.sun.fill"
            case (0.3..<0.6,0.6..<0.7):
                return "cloud.sun.rain"
            case (0.3..<0.6,0.7..<0.8):
                return "cloud.sun.rain.fill"
            case (0.3..<0.6,0.8...1.0):
                return "cloud.sun.bolt.fill"
            case (0.6...1.0, 0.5..<0.6):
                return "cloud.drizzle"
            case (0.6...1.0, 0.6..<0.7):
                return "cloud.drizzle.fill"
            case (0.6...1.0, 0.7..<0.8):
                return "cloud.rain.fill"
            case (0.6...1.0, 0.8..<0.9):
                return "cloud.heavyrain.fill"
            case (0.6...1.0, 0.9...1.0):
                return "cloud.bolt.rain.fill"
            default:
                return "Unknown"
        }
    }


}
