import Foundation

actor SolarSystemService {
    private let baseURL = "https://ssd.jpl.nasa.gov/api/horizons.api"
    private let planets = [
        "199": "Mercury",  // Mercury
        "299": "Venus",    // Venus
        "399": "Earth",    // Earth
        "499": "Mars",     // Mars
        "599": "Jupiter",  // Jupiter
        "699": "Saturn",   // Saturn
        "799": "Uranus",   // Uranus
        "899": "Neptune"   // Neptune
    ]
    
    func fetchAllBodies() async throws -> [PlanetData] {
        var allPlanets: [PlanetData] = []
        
        for (id, _) in planets {
            if let planet = try? await fetchPlanetDetails(id: id) {
                allPlanets.append(planet)
            }
        }
        
        guard !allPlanets.isEmpty else {
            throw URLError(.cannotParseResponse)
        }
        
        return allPlanets
    }
    
    func fetchPlanetDetails(id: String) async throws -> PlanetData {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "COMMAND", value: "'\(id)'"),
            URLQueryItem(name: "OBJ_DATA", value: "YES")
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let (_, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        // Crear un PlanetData con la información de Horizons
        return PlanetData(
            id: id,
            name: planets[id] ?? "Unknown",
            englishName: planets[id] ?? "Unknown",
            isPlanet: true,
            moons: nil,
            gravity: 0,
            meanRadius: 0,
            mass: .init(massValue: 0, massExponent: 0),
            vol: .init(volValue: 0, volExponent: 0),
            density: 0,
            discoveredBy: nil,
            discoveryDate: nil,
            alternativeName: nil,
            axialTilt: 0,
            avgTemp: 0,
            mainAnomaly: 0,
            argPeriapsis: 0,
            longAscNode: 0,
            bodyType: "Planet",
            rel: ""
        )
    }
} 