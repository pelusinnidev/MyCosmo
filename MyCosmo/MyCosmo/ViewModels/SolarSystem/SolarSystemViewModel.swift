import Foundation

/// ViewModel responsible for managing solar system data and user interactions
/// Handles the fetching and presentation of planet information
@MainActor
class SolarSystemViewModel: ObservableObject {
    /// Array of all planets in the solar system
    @Published var planets: [PlanetData] = []
    /// Currently selected planet for detailed view
    @Published var selectedPlanet: PlanetData?
    /// Loading state indicator
    @Published var isLoading = false
    /// Error state for handling API failures
    @Published var error: Error?
    
    /// Service for fetching solar system data
    private let service: SolarSystemService
    
    /// Initializes the ViewModel with a solar system service
    /// - Parameter service: Service for fetching planet data (defaults to a new instance)
    init(service: SolarSystemService = SolarSystemService()) {
        self.service = service
    }
    
    /// Fetches all planets in the solar system
    /// Updates the planets array and handles any errors that occur
    func fetchPlanets() async {
        isLoading = true
        do {
            planets = try await service.fetchAllBodies()
        } catch {
            self.error = error
            print("Error fetching planets: \(error)")
        }
        isLoading = false
    }
    
    /// Fetches detailed information for a specific planet
    /// - Parameter id: The unique identifier of the planet to fetch
    /// Updates the selectedPlanet property and handles any errors
    func fetchPlanetDetails(id: String) async {
        isLoading = true
        do {
            selectedPlanet = try await service.fetchPlanetDetails(id: id)
        } catch {
            self.error = error
            print("Error fetching planet details: \(error)")
        }
        isLoading = false
    }
} 