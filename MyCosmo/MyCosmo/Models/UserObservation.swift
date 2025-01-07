import Foundation
import SwiftData
import SwiftUI

@Model
final class UserObservation {
    var title: String
    var observationDescription: String
    var selectedPlanet: Planet
    var customPlanet: String?
    var category: ObservationCategory
    var importance: ImportanceLevel
    var date: Date
    var customImage: Data?  // Para guardar la imagen personalizada
    
    var displayPlanet: String {
        if selectedPlanet == .other {
            return customPlanet ?? "Unknown"
        }
        return selectedPlanet.rawValue
    }
    
    var displayImage: Image {
        if let imageData = customImage,
           let uiImage = UIImage(data: imageData) {
            return Image(uiImage: uiImage)
        }
        return selectedPlanet.defaultImage
    }
    
    init(title: String, description: String, selectedPlanet: Planet, customPlanet: String? = nil, category: ObservationCategory, importance: ImportanceLevel, date: Date = Date(), customImage: Data? = nil) {
        self.title = title
        self.observationDescription = description
        self.selectedPlanet = selectedPlanet
        self.customPlanet = customPlanet
        self.category = category
        self.importance = importance
        self.date = date
        self.customImage = customImage
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

enum Planet: String, Codable, CaseIterable {
    case mercury = "Mercury"
    case venus = "Venus"
    case earth = "Earth"
    case mars = "Mars"
    case jupiter = "Jupiter"
    case saturn = "Saturn"
    case uranus = "Uranus"
    case neptune = "Neptune"
    case other = "Other"
    
    var defaultImage: Image {
        Image(rawValue)
    }
} 