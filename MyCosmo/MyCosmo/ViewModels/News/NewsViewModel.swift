import Foundation
import SwiftUI

@MainActor
class NewsViewModel: ObservableObject {
    @Published var apodData: APODResponse?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let nasaService: APODService
    
    init(nasaService: APODService = APODService()) {
        self.nasaService = nasaService
    }
    
    func fetchAPOD() async {
        isLoading = true
        do {
            apodData = try await nasaService.fetchAPOD()
        } catch {
            self.error = error
            print("Error fetching APOD: \(error)")
        }
        isLoading = false
    }
}
