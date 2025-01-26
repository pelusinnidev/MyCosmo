import SwiftData
import SwiftUI

/// A model representing user-recorded astronomical observations
/// Stores details about celestial observations including images and metadata
@Model
final class UserObservation {
    /// Title of the observation
    var title: String
    /// Detailed description of what was observed
    var observationDescription: String
    /// The primary celestial body being observed
    var selectedPlanet: Planet
    /// Custom planet name when selectedPlanet is .other
    var customPlanet: String?
    /// Category of the observation (atmospheric, geological, etc.)
    var category: ObservationCategory
    /// User-assigned importance level of the observation
    var importance: ImportanceLevel
    /// Date and time of the observation
    var date: Date
    /// Primary image data of the observation
    var customImage: Data?  // Para guardar la imagen principal
    /// Additional images related to the observation
    var additionalImages: [Data]? // Para guardar imágenes adicionales
    
    /// Computed property that returns the display name of the observed planet
    var displayPlanet: String {
        if selectedPlanet == .other {
            return customPlanet ?? "Unknown"
        }
        return selectedPlanet.rawValue
    }
    
    /// Returns the observation image or a default planet image if none exists
    var displayImage: Image {
        if let imageData = customImage,
           let uiImage = UIImage(data: imageData) {
            return Image(uiImage: uiImage)
        }
        return selectedPlanet.defaultImage
    }
    
    /// Creates a new observation with the specified parameters
    init(title: String, 
         description: String, 
         selectedPlanet: Planet, 
         customPlanet: String? = nil, 
         category: ObservationCategory, 
         importance: ImportanceLevel, 
         date: Date = Date(), 
         customImage: Data? = nil,
         additionalImages: [Data]? = nil) {
        self.title = title
        self.observationDescription = description
        self.selectedPlanet = selectedPlanet
        self.customPlanet = customPlanet
        self.category = category
        self.importance = importance
        self.date = date
        self.customImage = customImage
        self.additionalImages = additionalImages
    }
}

/// Categories for classifying astronomical observations
enum ObservationCategory: String, Codable, CaseIterable {
    /// Observations related to atmospheric phenomena
    case atmospheric = "Atmospheric"
    /// Observations of geological features
    case geological = "Geological"
    /// General astronomical observations
    case astronomical = "Astronomical"
    /// Miscellaneous observations
    case other = "Other"
}

/// Importance levels for prioritizing observations
enum ImportanceLevel: String, Codable, CaseIterable {
    /// Routine observations
    case low = "Low"
    /// Notable observations
    case medium = "Medium"
    /// Significant observations
    case high = "High"
    /// Exceptional or urgent observations
    case critical = "Critical"
}

/// Represents celestial bodies that can be observed
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
    
    /// Returns the default image associated with each planet
    var defaultImage: Image {
        Image(rawValue)
    }
} 
