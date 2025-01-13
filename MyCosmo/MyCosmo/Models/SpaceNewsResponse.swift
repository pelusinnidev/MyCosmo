import Foundation
import SwiftUI

struct SpaceNewsArticle: Codable, Identifiable {
    let id: Int
    let title: String
    let url: String
    let imageUrl: String
    let newsSite: String
    let summary: String
    let publishedAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, url, summary
        case imageUrl = "image_url"
        case newsSite = "news_site"
        case publishedAt = "published_at"
        case updatedAt = "updated_at"
    }
}

enum NewsType: String, CaseIterable {
    case all = "All"
    case articles = "Articles"
    case blogs = "Blogs"
    case reports = "Reports"
    case launches = "Launches"
    
    var icon: String {
        switch self {
        case .all: return "square.grid.2x2.fill"
        case .articles: return "newspaper.fill"
        case .blogs: return "text.book.closed.fill"
        case .reports: return "doc.text.fill"
        case .launches: return "paperplane"
        }
    }
    
    var color: Color {
        switch self {
        case .all: return .indigo
        case .articles: return .blue
        case .blogs: return .purple
        case .reports: return .green
        case .launches: return .orange
        }
    }
    
    var endpoint: String {
        switch self {
        case .all: return "articles"
        case .articles: return "articles"
        case .blogs: return "blogs"
        case .reports: return "reports"
        case .launches: return "launches"
        }
    }
} 
