import Foundation
import SwiftData

@Model
final class UserObservation {
    var title: String
    var observationDescription: String
    var selectedPlanet: Planet
    var customPlanet: String?
    var category: ObservationCategory
    var importance: ImportanceLevel
    var date: Date
    
    var displayPlanet: String {
        if selectedPlanet == .other {
            return customPlanet ?? "Unknown"
        }
        return selectedPlanet.rawValue
    }
    
    init(title: String, description: String, selectedPlanet: Planet, customPlanet: String? = nil, category: ObservationCategory, importance: ImportanceLevel, date: Date = Date()) {
        self.title = title
        self.observationDescription = description
        self.selectedPlanet = selectedPlanet
        self.customPlanet = customPlanet
        self.category = category
        self.importance = importance
        self.date = date
    }
}

enum ObservationCategory: String, Codable, CaseIterable {
    case atmospheric = "Atmospheric"
    case geological = "Geological"
    case astronomical = "Astronomical"
    case other = "Other"
}

enum ImportanceLevel: String, Codable, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case critical = "Critical"
} 
