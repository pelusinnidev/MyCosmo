import Foundation

@MainActor
class SolarSystemViewModel: ObservableObject {
    @Published var planets: [PlanetData] = []
    @Published var selectedPlanet: PlanetData?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let service: SolarSystemService
    
    init(service: SolarSystemService = SolarSystemService()) {
        self.service = service
    }
    
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