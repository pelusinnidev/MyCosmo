import Foundation

/// Type alias for the Moon struct from PlanetData
typealias Moon = PlanetData.Moon

/// Service responsible for providing detailed information about celestial bodies in our solar system
/// Contains a local database of planet information including physical characteristics and fun facts
actor SolarSystemService {
    /// Local database of planet information
    /// Each PlanetData object contains comprehensive information about a planet
    private let planets: [PlanetData] = [
        PlanetData(
            id: "199",
            name: "Mercury",
            englishName: "Mercury",
            isPlanet: true,
            moons: nil,
            gravity: 3.7,
            meanRadius: 2439.7,
            mass: .init(massValue: 3.285, massExponent: 23),
            vol: .init(volValue: 6.083, volExponent: 10),
            density: 5429,
            discoveredBy: nil,
            discoveryDate: nil,
            alternativeName: nil,
            axialTilt: 0.034,
            avgTemp: 440,
            mainAnomaly: 174.796,
            argPeriapsis: 29.124,
            longAscNode: 48.331,
            bodyType: "Planet",
            rel: "",
            funFacts: [
                "Mercury's day (176 Earth days) is longer than its year (88 Earth days)!",
                "Despite being the closest to the Sun, Mercury is not the hottest planet - Venus is!",
                "Mercury's surface resembles our Moon with many impact craters.",
                "The planet has no atmosphere and experiences extreme temperature variations.",
                "Mercury can be seen from Earth without a telescope, known since ancient times."
            ]
        ),
        PlanetData(
            id: "299",
            name: "Venus",
            englishName: "Venus",
            isPlanet: true,
            moons: nil,
            gravity: 8.87,
            meanRadius: 6051.8,
            mass: .init(massValue: 4.867, massExponent: 24),
            vol: .init(volValue: 9.28, volExponent: 11),
            density: 5243,
            discoveredBy: nil,
            discoveryDate: nil,
            alternativeName: "Evening Star",
            axialTilt: 177.36,
            avgTemp: 737,
            mainAnomaly: 50.115,
            argPeriapsis: 54.884,
            longAscNode: 76.680,
            bodyType: "Planet",
            rel: "",
            funFacts: [
                "Venus rotates backwards compared to most other planets!",
                "It's the hottest planet in our solar system due to greenhouse effect.",
                "A day on Venus is longer than its year.",
                "Venus is often called Earth's twin due to similar size and mass.",
                "The pressure on Venus's surface could crush a submarine."
            ]
        ),
        PlanetData(
            id: "399",
            name: "Earth",
            englishName: "Earth",
            isPlanet: true,
            moons: [.init(rel: "Moon")],
            gravity: 9.8,
            meanRadius: 6371.0,
            mass: .init(massValue: 5.972, massExponent: 24),
            vol: .init(volValue: 1.083, volExponent: 12),
            density: 5514,
            discoveredBy: nil,
            discoveryDate: nil,
            alternativeName: nil,
            axialTilt: 23.44,
            avgTemp: 288,
            mainAnomaly: 358.617,
            argPeriapsis: 114.207,
            longAscNode: 348.739,
            bodyType: "Planet",
            rel: "",
            funFacts: [
                "Earth is the only known planet with liquid water on its surface.",
                "Our planet's atmosphere is 78% nitrogen and 21% oxygen.",
                "Earth's magnetic field protects us from harmful solar radiation.",
                "The highest point on Earth is Mount Everest at 8,848 meters.",
                "Earth is the only planet not named after a god or goddess."
            ]
        ),
        PlanetData(
            id: "499",
            name: "Mars",
            englishName: "Mars",
            isPlanet: true,
            moons: [.init(rel: "Phobos"), .init(rel: "Deimos")],
            gravity: 3.71,
            meanRadius: 3389.5,
            mass: .init(massValue: 6.39, massExponent: 23),
            vol: .init(volValue: 1.631, volExponent: 11),
            density: 3933,
            discoveredBy: nil,
            discoveryDate: nil,
            alternativeName: "Red Planet",
            axialTilt: 25.19,
            avgTemp: 210,
            mainAnomaly: 19.412,
            argPeriapsis: 286.502,
            longAscNode: 49.558,
            bodyType: "Planet",
            rel: "",
            funFacts: [
                "Mars has the largest volcano in the solar system - Olympus Mons.",
                "The red color comes from iron oxide (rust) on its surface.",
                "Mars has seasons like Earth due to similar axial tilt.",
                "Evidence suggests Mars once had flowing water on its surface.",
                "Dust storms on Mars can cover the entire planet."
            ]
        ),
        PlanetData(
            id: "599",
            name: "Jupiter",
            englishName: "Jupiter",
            isPlanet: true,
            moons: (0..<79).map { _ in Moon(rel: "") },
            gravity: 24.79,
            meanRadius: 69911,
            mass: .init(massValue: 1.898, massExponent: 27),
            vol: .init(volValue: 1.431, volExponent: 15),
            density: 1326,
            discoveredBy: nil,
            discoveryDate: nil,
            alternativeName: "Giant Planet",
            axialTilt: 3.13,
            avgTemp: 165,
            mainAnomaly: 20.020,
            argPeriapsis: 273.867,
            longAscNode: 100.464,
            bodyType: "Planet",
            rel: "",
            funFacts: [
                "Jupiter's Great Red Spot is a storm that's been raging for over 400 years.",
                "You could fit more than 1,300 Earths inside Jupiter.",
                "Jupiter's magnetic field is the strongest of all planets.",
                "The planet has a faint ring system, discovered in 1979.",
                "Jupiter's day is the shortest of all planets - just 10 hours!"
            ]
        ),
        PlanetData(
            id: "699",
            name: "Saturn",
            englishName: "Saturn",
            isPlanet: true,
            moons: (0..<82).map { _ in Moon(rel: "") },
            gravity: 10.44,
            meanRadius: 58232,
            mass: .init(massValue: 5.683, massExponent: 26),
            vol: .init(volValue: 8.272, volExponent: 14),
            density: 687,
            discoveredBy: nil,
            discoveryDate: nil,
            alternativeName: "Ringed Planet",
            axialTilt: 26.73,
            avgTemp: 134,
            mainAnomaly: 317.020,
            argPeriapsis: 339.392,
            longAscNode: 113.665,
            bodyType: "Planet",
            rel: "",
            funFacts: [
                "Saturn's rings are mostly made of ice and rock.",
                "It's the only planet that could float in water (if you had a big enough pool).",
                "Saturn's moon Titan has liquid lakes, but they're made of methane.",
                "The planet's distinctive rings are only about 10 meters thick.",
                "Wind speeds on Saturn can reach 1,800 km per hour."
            ]
        ),
        PlanetData(
            id: "799",
            name: "Uranus",
            englishName: "Uranus",
            isPlanet: true,
            moons: (0..<27).map { _ in Moon(rel: "") },
            gravity: 8.69,
            meanRadius: 25362,
            mass: .init(massValue: 8.681, massExponent: 25),
            vol: .init(volValue: 6.833, volExponent: 13),
            density: 1271,
            discoveredBy: "William Herschel",
            discoveryDate: "1781-03-13",
            alternativeName: "Ice Giant",
            axialTilt: 97.77,
            avgTemp: 76,
            mainAnomaly: 142.238,
            argPeriapsis: 96.998,
            longAscNode: 74.006,
            bodyType: "Planet",
            rel: "",
            funFacts: [
                "Uranus rotates on its side, like a rolling ball.",
                "It's the coldest planet despite not being the farthest from the Sun.",
                "The planet was originally named 'George's Star'.",
                "Its blue color comes from methane in the atmosphere.",
                "Uranus has rings, but they're almost impossible to see from Earth."
            ]
        ),
        PlanetData(
            id: "899",
            name: "Neptune",
            englishName: "Neptune",
            isPlanet: true,
            moons: (0..<14).map { _ in Moon(rel: "") },
            gravity: 11.15,
            meanRadius: 24622,
            mass: .init(massValue: 1.024, massExponent: 26),
            vol: .init(volValue: 6.254, volExponent: 13),
            density: 1638,
            discoveredBy: "Urbain Le Verrier",
            discoveryDate: "1846-09-23",
            alternativeName: "Blue Planet",
            axialTilt: 28.32,
            avgTemp: 72,
            mainAnomaly: 256.228,
            argPeriapsis: 276.336,
            longAscNode: 131.784,
            bodyType: "Planet",
            rel: "",
            funFacts: [
                "Neptune was discovered through mathematical predictions.",
                "It has the strongest winds in the solar system, up to 2,100 km/h.",
                "One Neptune year equals 165 Earth years.",
                "Its moon Triton orbits backwards compared to other large moons.",
                "Neptune's blue color is deeper than Uranus due to unknown factors."
            ]
        )
    ]
    
    /// Retrieves information about all celestial bodies in the solar system
    /// - Returns: An array of PlanetData objects containing information about all planets
    func fetchAllBodies() async throws -> [PlanetData] {
        return planets
    }
    
    /// Retrieves detailed information about a specific planet
    /// - Parameter id: The unique identifier of the planet
    /// - Returns: A PlanetData object containing the planet's information
    /// - Throws: URLError.cannotFindHost if the planet ID is not found
    func fetchPlanetDetails(id: String) async throws -> PlanetData {
        guard let planet = planets.first(where: { $0.id == id }) else {
            throw URLError(.cannotFindHost)
        }
        return planet
    }
} 