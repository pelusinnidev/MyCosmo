import Foundation

actor SpaceNewsService {
    private let baseURL = "https://api.spaceflightnewsapi.net/v4"
    
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

struct SpaceNewsResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [SpaceNewsArticle]
}