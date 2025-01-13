import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var apodData: APODResponse?
    @Published var isLoading = true
    @Published var error: Error?
    @Published var newsArticles: [NewsArticle] = []
    @Published var isLoadingNews = true
    @Published var newsError: Error?
    @Published var selectedFilter: NewsFilter = .all
    @Published var isLoadingMore = false
    
    func loadAPOD() async {
        isLoading = true
        do {
            apodData = try await APODService.shared.fetchAPOD()
        } catch {
            self.error = error
        }
        isLoading = false
    }
    
    func loadNews() async {
        isLoadingNews = true
        newsError = nil
        do {
            newsArticles = try await NewsService.shared.fetchAstronomyNews(filter: selectedFilter)
        } catch {
            newsError = error
        }
        isLoadingNews = false
    }
    
    func loadMore() {
        guard !isLoadingMore else { return }
        
        Task {
            isLoadingMore = true
            do {
                let moreArticles = try await NewsService.shared.loadMoreNews(
                    filter: selectedFilter,
                    currentArticles: newsArticles
                )
                newsArticles = moreArticles
            } catch {
                // Handle error silently
            }
            isLoadingMore = false
        }
    }
    
    func refresh() async {
        do {
            async let apodResult = APODService.shared.fetchAPOD()
            async let newsResult = NewsService.shared.fetchAstronomyNews(filter: selectedFilter)
            
            apodData = try await apodResult
            newsArticles = try await newsResult
        } catch {
            self.error = error
        }
    }
} 