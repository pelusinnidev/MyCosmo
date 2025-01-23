import Foundation
import SwiftUI

@MainActor
class NewsViewModel: ObservableObject {
    @Published var apodData: APODResponse?
    @Published var apodError: Error?
    @Published var newsArticles: [SpaceNewsArticle] = []
    @Published var selectedNewsType: NewsType = .all
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
            apodError = nil
            apodData = try await nasaService.fetchAPOD()
        } catch {
            apodError = error
            apodData = nil
            print("Error fetching APOD: \(error)")
        }
        isLoading = false
    }
    
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
