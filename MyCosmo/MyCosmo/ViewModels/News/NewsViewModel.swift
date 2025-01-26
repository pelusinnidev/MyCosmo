import Foundation
import SwiftUI

/// ViewModel responsible for managing space-related news and NASA's APOD
/// Handles fetching and presenting both daily astronomy pictures and space news articles
@MainActor
class NewsViewModel: ObservableObject {
    /// NASA's Astronomy Picture of the Day data
    @Published var apodData: APODResponse?
    /// Error state for APOD-related failures
    @Published var apodError: Error?
    /// Collection of space news articles
    @Published var newsArticles: [SpaceNewsArticle] = []
    /// Currently selected news category
    @Published var selectedNewsType: NewsType = .all
    /// Loading state indicator
    @Published var isLoading = false
    /// Error state for news-related failures
    @Published var error: Error?
    
    /// Service for fetching NASA's APOD
    private let nasaService: APODService
    /// Service for fetching space news
    private let spaceNewsService: SpaceNewsService
    
    /// Initializes the ViewModel with NASA and space news services
    /// - Parameters:
    ///   - nasaService: Service for fetching APOD data
    ///   - spaceNewsService: Service for fetching space news
    init(nasaService: APODService = APODService(), spaceNewsService: SpaceNewsService = SpaceNewsService()) {
        self.nasaService = nasaService
        self.spaceNewsService = spaceNewsService
    }
    
    /// Fetches NASA's Astronomy Picture of the Day
    /// Updates the apodData property and handles any errors
    func fetchAPOD() async {
        isLoading = true
        do {
            apodError = nil
            apodData = try await nasaService.fetchAPOD()
        } catch {
            apodError = error
            apodData = nil
            print("Error fetching APOD: \(error)")
        }
        isLoading = false
    }
    
    /// Fetches space news articles based on the selected category
    /// Updates the newsArticles array and handles any errors
    func fetchNews() async {
        isLoading = true
        do {
            error = nil
            newsArticles = try await spaceNewsService.fetchNews(type: selectedNewsType)
        } catch {
            self.error = error
            print("Error fetching news: \(error)")
        }
        isLoading = false
    }
    
    /// Changes the news category and refreshes the news feed
    /// - Parameter type: The news category to switch to
    /// If the same category is selected twice, reverts to showing all news
    func changeNewsType(_ type: NewsType) {
        if type == selectedNewsType {
            selectedNewsType = .all
        } else {
            selectedNewsType = type
        }
        Task {
            await fetchNews()
        }
    }
}
