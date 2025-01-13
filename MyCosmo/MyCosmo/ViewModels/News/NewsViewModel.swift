import Foundation
import SwiftUI

@MainActor
class NewsViewModel: ObservableObject {
    @Published var apodData: APODResponse?
    @Published var newsArticles: [SpaceNewsArticle] = []
    @Published var selectedNewsType: NewsType = .articles
    @Published var isLoading = false
    @Published var error: Error?
    
    private let nasaService: APODService
    private let spaceNewsService: SpaceNewsService
    
    init(nasaService: APODService = APODService(), spaceNewsService: SpaceNewsService = SpaceNewsService()) {
        self.nasaService = nasaService
        self.spaceNewsService = spaceNewsService
    }
    
    func fetchAPOD() async {
        isLoading = true
        do {
            apodData = try await nasaService.fetchAPOD()
        } catch {
            self.error = error
            print("Error fetching APOD: \(error)")
        }
        isLoading = false
    }
    
    func fetchNews() async {
        isLoading = true
        do {
            newsArticles = try await spaceNewsService.fetchNews(type: selectedNewsType)
        } catch {
            self.error = error
            print("Error fetching news: \(error)")
        }
        isLoading = false
    }
    
    func changeNewsType(_ type: NewsType) {
        selectedNewsType = type
        Task {
            await fetchNews()
        }
    }
}
