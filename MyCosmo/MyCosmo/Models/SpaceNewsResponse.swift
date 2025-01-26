import Foundation
import SwiftUI

/// Represents a single article from the Space News API
/// Contains information about space-related news articles, blogs, and reports
struct SpaceNewsArticle: Codable, Identifiable {
    /// Unique identifier for the article
    let id: Int
    /// Article headline
    let title: String
    /// URL to the full article
    let url: String
    /// URL of the article's featured image
    let imageUrl: String
    /// Source website of the article
    let newsSite: String
    /// Brief overview of the article content
    let summary: String
    /// Original publication date
    let publishedAt: String
    /// Last update date
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, url, summary
        case imageUrl = "image_url"
        case newsSite = "news_site"
        case publishedAt = "published_at"
        case updatedAt = "updated_at"
    }
}

/// Represents different categories of space-related content
/// Used for filtering and organizing news content in the app
enum NewsType: String, CaseIterable {
    /// Shows all types of content
    case all = "All"
    /// News articles only
    case articles = "Articles"
    /// Blog posts only
    case blogs = "Blogs"
    /// Official reports only
    case reports = "Reports"
    /// Space launch information
    case launches = "Launches"
    
    /// SF Symbol icon associated with each news type
    var icon: String {
        switch self {
        case .all: return "square.grid.2x2.fill"
        case .articles: return "newspaper.fill"
        case .blogs: return "text.book.closed.fill"
        case .reports: return "doc.text.fill"
        case .launches: return "paperplane"
        }
    }
    
    /// Theme color for each news type
    var color: Color {
        switch self {
        case .all: return .indigo
        case .articles: return .blue
        case .blogs: return .purple
        case .reports: return .green
        case .launches: return .orange
        }
    }
    
    /// API endpoint for each news type
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
