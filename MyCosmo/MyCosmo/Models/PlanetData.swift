import Foundation

/// Represents detailed information about a celestial body in the solar system
/// Contains physical characteristics, orbital parameters, and additional metadata
struct PlanetData: Codable, Identifiable {
    /// Unique identifier for the celestial body
    let id: String
    /// Native name of the celestial body
    let name: String
    /// English name of the celestial body
    let englishName: String
    /// Indicates if the body is classified as a planet
    let isPlanet: Bool
    /// Array of moons orbiting this celestial body (if any)
    let moons: [Moon]?
    /// Surface gravity in m/s²
    let gravity: Double
    /// Mean radius in kilometers
    let meanRadius: Double
    /// Mass information including value and exponential notation
    let mass: Mass
    /// Volume information including value and exponential notation
    let vol: Volume
    /// Density in g/cm³
    let density: Double
    /// Name of discoverer (if applicable)
    let discoveredBy: String?
    /// Date of discovery (if applicable)
    let discoveryDate: String?
    /// Alternative names for the celestial body
    let alternativeName: String?
    /// Axial tilt in degrees
    let axialTilt: Double
    /// Average temperature in Kelvin
    let avgTemp: Double
    /// Mean anomaly (orbital parameter)
    let mainAnomaly: Double
    /// Argument of periapsis (orbital parameter)
    let argPeriapsis: Double
    /// Longitude of ascending node (orbital parameter)
    let longAscNode: Double
    /// Classification of the celestial body
    let bodyType: String
    /// Related body reference
    let rel: String
    /// Array of interesting facts about the celestial body
    let funFacts: [String]
    
    /// Represents a moon orbiting a celestial body
    struct Moon: Codable, Identifiable {
        var id: String { rel }
        let rel: String
    }
    
    /// Represents mass using scientific notation
    struct Mass: Codable {
        let massValue: Double
        let massExponent: Int
    }
    
    /// Represents volume using scientific notation
    struct Volume: Codable {
        let volValue: Double
        let volExponent: Int
    }
    
    /// Formats the radius for display
    var formattedRadius: String {
        "\(Int(meanRadius)) km"
    }
    
    /// Formats the temperature in both Kelvin and Celsius
    var formattedTemperature: String {
        "\(Int(avgTemp))°K (\(Int(avgTemp - 273.15))°C)"
    }
    
    /// Formats the gravity for display
    var formattedGravity: String {
        String(format: "%.2f m/s²", gravity)
    }
    
    /// Formats the mass in scientific notation
    var formattedMass: String {
        "\(massValue)×10^\(massExponent) kg"
    }
    
    private var massValue: String {
        String(format: "%.2f", mass.massValue)
    }
    
    private var massExponent: Int {
        mass.massExponent
    }
    
    /// Returns a random fun fact about the celestial body
    var randomFunFact: String {
        funFacts.randomElement() ?? "No fun facts available"
    }
}

/// Container for planet data API response
struct PlanetResponse: Codable {
    let bodies: [PlanetData]
} 