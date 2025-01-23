import Foundation

actor APODService {
    private var apiKey: String {
        UserDefaults.standard.string(forKey: "nasaApiKey") ?? ""
    }
    private let baseURL = "https://api.nasa.gov/planetary/apod"
    
    func fetchAPOD() async throws -> APODResponse {
        guard !apiKey.isEmpty else {
            throw APIError.missingAPIKey
        }
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
        return try decoder.decode(APODResponse.self, from: data)
    }
    
    func getRemainingAPIRequests() async -> Int? {
        guard !apiKey.isEmpty else { return nil }
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        guard let url = components.url else { return nil }
        
        do {
            let (_, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse,
               let remaining = httpResponse.value(forHTTPHeaderField: "X-RateLimit-Remaining") {
                return Int(remaining)
            }
        } catch {
            return nil
        }
        return nil
    }
}

private extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

enum APIError: Error {
    case missingAPIKey
} 
