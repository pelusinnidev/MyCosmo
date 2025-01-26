import Foundation

/// Service responsible for fetching NASA's Astronomy Picture of the Day (APOD)
/// Uses NASA's APOD API to retrieve daily astronomical images and their descriptions
/// - Note: Requires a NASA API key stored in UserDefaults
actor APODService {
    /// NASA API key retrieved from UserDefaults
    private var apiKey: String {
        UserDefaults.standard.string(forKey: "nasaApiKey") ?? ""
    }
    
    /// Base URL for NASA's APOD API
    private let baseURL = "https://api.nasa.gov/planetary/apod"
    
    /// Fetches the Astronomy Picture of the Day from NASA's API
    /// - Returns: An APODResponse containing the image data and metadata
    /// - Throws: APIError.missingAPIKey if no API key is found
    ///          URLError if the request fails
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
    
    /// Checks the remaining API requests available for the current API key
    /// - Returns: The number of remaining requests or nil if unable to determine
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

/// Date formatter extension for APOD API date format
private extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

/// Custom errors for API-related issues
enum APIError: Error {
    /// Indicates that no API key was found in UserDefaults
    case missingAPIKey
} 
