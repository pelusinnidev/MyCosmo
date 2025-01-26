import Foundation

/// Service responsible for fetching space-related news articles
/// Uses the Spaceflight News API to retrieve articles, blogs, and reports
actor SpaceNewsService {
    /// Base URL for the Spaceflight News API
    private let baseURL = "https://api.spaceflightnewsapi.net/v4"
    
    /// Fetches space news articles based on the specified type and limit
    /// - Parameters:
    ///   - type: The category of news to fetch (articles, blogs, reports, etc.)
    ///   - limit: Maximum number of articles to retrieve (default: 20)
    /// - Returns: An array of SpaceNewsArticle objects
    /// - Throws: URLError if the request fails or response is invalid
    func fetchNews(type: NewsType, limit: Int = 20) async throws -> [SpaceNewsArticle] {
        var components = URLComponents(string: "\(baseURL)/\(type.endpoint)")!
        components.queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)")
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
        let result = try decoder.decode(SpaceNewsResponse.self, from: data)
        return result.results
    }
}

/// Container for the paginated response from the Spaceflight News API
struct SpaceNewsResponse: Codable {
    /// Total number of available articles
    let count: Int
    /// URL for the next page of results
    let next: String?
    /// URL for the previous page of results
    let previous: String?
    /// Array of news articles in the current page
    let results: [SpaceNewsArticle]
}