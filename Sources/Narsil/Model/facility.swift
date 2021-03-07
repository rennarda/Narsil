//
//  File.swift
//  
//
//  Created by Andrew Rennard on 07/03/2021.
//

import Foundation

public enum Facility: String, CaseIterable {
    case mill, smith, forester, tradingPost, temple, militia, stable, guild, inn
    
    var probability: Double {
        switch self {
            case .mill:
                return 0.8
            case .smith:
                return 0.8
            case .forester:
                return 0.45
            case .tradingPost:
                return 0.95
            case .temple:
                return 0.75
            case .militia:
                return 0.5
            case .stable:
                return 0.6
            case .guild:
                return 0.45
            case .inn:
                return 0.95
        }
    }
}
