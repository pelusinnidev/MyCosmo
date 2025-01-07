import SwiftUI

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