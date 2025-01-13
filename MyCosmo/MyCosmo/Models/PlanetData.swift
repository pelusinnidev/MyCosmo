import Foundation

struct PlanetData: Codable, Identifiable {
    let id: String
    let name: String
    let englishName: String
    let isPlanet: Bool
    let moons: [Moon]?
    let gravity: Double
    let meanRadius: Double
    let mass: Mass
    let vol: Volume
    let density: Double
    let discoveredBy: String?
    let discoveryDate: String?
    let alternativeName: String?
    let axialTilt: Double
    let avgTemp: Double
    let mainAnomaly: Double
    let argPeriapsis: Double
    let longAscNode: Double
    let bodyType: String
    let rel: String
    let funFacts: [String]
    
    struct Moon: Codable, Identifiable {
        var id: String { rel }
        let rel: String
    }
    
    struct Mass: Codable {
        let massValue: Double
        let massExponent: Int
    }
    
    struct Volume: Codable {
        let volValue: Double
        let volExponent: Int
    }
    
    var formattedRadius: String {
        "\(Int(meanRadius)) km"
    }
    
    var formattedTemperature: String {
        "\(Int(avgTemp))°K (\(Int(avgTemp - 273.15))°C)"
    }
    
    var formattedGravity: String {
        String(format: "%.2f m/s²", gravity)
    }
    
    var formattedMass: String {
        "\(massValue)×10^\(massExponent) kg"
    }
    
    private var massValue: String {
        String(format: "%.2f", mass.massValue)
    }
    
    private var massExponent: Int {
        mass.massExponent
    }
    
    var randomFunFact: String {
        funFacts.randomElement() ?? "No fun facts available"
    }
}

struct PlanetResponse: Codable {
    let bodies: [PlanetData]
} 