import Foundation

class NewsService {
    static let shared = NewsService()
    private let apiKey = "4796dbce5a8f4e68860da9e4e7901bfe" // pol's API key
    private let baseURL = "https://newsapi.org/v2/everything"
    private var currentPage = 1
    
    func fetchAstronomyNews(filter: NewsFilter = .all, page: Int = 1) async throws -> [NewsArticle] {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "q", value: filter.getSearchQuery()),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "sortBy", value: "publishedAt"),
            URLQueryItem(name: "pageSize", value: "10"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        
        let request = URLRequest(url: components.url!)
        let (data, _) = try await URLSession.shared.data(for: request)
        let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
        return newsResponse.articles
    }
    
    func loadMoreNews(filter: NewsFilter, currentArticles: [NewsArticle]) async throws -> [NewsArticle] {
        currentPage += 1
        let newArticles = try await fetchAstronomyNews(filter: filter, page: currentPage)
        return currentArticles + newArticles
    }
} 
