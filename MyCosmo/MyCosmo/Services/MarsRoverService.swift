import Foundation

class MarsRoverService {
    static let shared = MarsRoverService()
    private let apiKey = "RXXCVNTM6S015sjlavyOOi6YjJhK8aIS4s4FEn8n" // Pol's NASA API Key
    private let baseURL = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos"
    
    func fetchLatestPhotos() async throws -> [MarsRoverPhoto] {
        // Try last 7 days until we find photos
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Start from today and go back up to 7 days
        for daysAgo in 0...7 {
            guard let date = calendar.date(byAdding: .day, value: -daysAgo, to: Date()) else { continue }
            let dateString = dateFormatter.string(from: date)
            
            var components = URLComponents(string: baseURL)!
            components.queryItems = [
                URLQueryItem(name: "earth_date", value: dateString),
                URLQueryItem(name: "camera", value: "MAST"), // Main camera
                URLQueryItem(name: "api_key", value: apiKey)
            ]
            
            print("Trying date: \(dateString)")
            
            do {
                let request = URLRequest(url: components.url!)
                let (data, response) = try await URLSession.shared.data(for: request)
                
                // Print response for debugging
                if let httpResponse = response as? HTTPURLResponse {
                    print("Response status code: \(httpResponse.statusCode)")
                }
                
                let marsResponse = try JSONDecoder().decode(MarsRoverResponse.self, from: data)
                if !marsResponse.photos.isEmpty {
                    print("Found \(marsResponse.photos.count) photos")
                    return marsResponse.photos
                }
            } catch {
                print("Error fetching Mars photos: \(error)")
                continue
            }
        }
        
        return []
    }
} 