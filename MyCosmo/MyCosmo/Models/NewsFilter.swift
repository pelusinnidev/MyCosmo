import SwiftUI

enum NewsFilter: String, CaseIterable {
    case all = "All"
    case planets = "Planets"
    case zodiac = "Zodiac"
    case events = "Events"
    
    var icon: String {
        switch self {
        case .all:
            return "newspaper.fill"
        case .planets:
            return "globe.americas.fill"
        case .zodiac:
            return "sparkles.rectangle.stack"
        case .events:
            return "calendar.badge.clock"
        }
    }
    
    var color: Color {
        switch self {
        case .all:
            return .blue
        case .planets:
            return .purple
        case .zodiac:
            return .orange
        case .events:
            return .green
        }
    }
    
    func getSearchQuery() -> String {
        switch self {
        case .all:
            return "astrology OR horoscope OR zodiac"
        case .planets:
            return "planets astrology OR mercury venus mars jupiter saturn astrology"
        case .zodiac:
            return "zodiac signs OR constellation astrology OR horoscope signs"
        case .events:
            return "astrological events OR celestial events OR planetary alignment"
        }
    }
} 