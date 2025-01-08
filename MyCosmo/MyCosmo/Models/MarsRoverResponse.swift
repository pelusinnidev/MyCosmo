import Foundation
import SwiftUI

struct MarsRoverPhoto: Codable, Identifiable {
    let id: Int
    let sol: Int
    let camera: RoverCamera
    let imgSrc: String
    let earthDate: String
    let rover: Rover
    
    enum CodingKeys: String, CodingKey {
        case id, sol, camera
        case imgSrc = "img_src"
        case earthDate = "earth_date"
        case rover
    }
}

struct RoverCamera: Codable {
    let id: Int
    let name: String
    let fullName: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case fullName = "full_name"
    }
}

struct Rover: Codable {
    let id: Int
    let name: String
    let landingDate: String
    let launchDate: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, status
        case landingDate = "landing_date"
        case launchDate = "launch_date"
    }
}

struct MarsRoverResponse: Codable {
    let photos: [MarsRoverPhoto]
}

enum PlanetFilter: String, CaseIterable {
    case earth = "Earth"
    case mars = "Mars"
    
    var icon: String {
        switch self {
        case .earth:
            return "globe.americas.fill"
        case .mars:
            return "globe.asia.australia.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .earth:
            return .blue
        case .mars:
            return .red
        }
    }
} 
