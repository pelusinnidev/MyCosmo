import Foundation

struct NewsArticle: Codable, Identifiable {
    let id = UUID()
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let source: NewsSource
    
    enum CodingKeys: String, CodingKey {
        case title, description, url, urlToImage, publishedAt, source
    }
}

struct NewsSource: Codable {
    let name: String
}

struct NewsResponse: Codable {
    let articles: [NewsArticle]
} 