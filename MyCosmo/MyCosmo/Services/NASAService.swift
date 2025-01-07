import Foundation

class NASAService {
    static let shared = NASAService()
    private let apiKey = "RXXCVNTM6S015sjlavyOOi6YjJhK8aIS4s4FEn8n" // Pol's API Key
    
    func fetchAPOD() async throws -> APODResponse {
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(APODResponse.self, from: data)
    }
}
