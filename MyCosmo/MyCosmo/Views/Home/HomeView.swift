import SwiftUI

struct HomeView: View {
    @State private var apodData: APODResponse?
    @State private var isLoading = true
    @State private var error: Error?
    @State private var showingDetail = false
    @State private var newsArticles: [NewsArticle] = []
    @State private var isLoadingNews = true
    @State private var newsError: Error?
    @State private var selectedFilter: NewsFilter = .all
    @State private var isLoadingMore = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Picture of the Day Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Picture of the Day")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding(.horizontal)
                                                
                        if isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(.systemBackground))
                                        .shadow(color: Color(.systemGray4), radius: 5)
                                )
                                .padding(.horizontal)
                        } else if let apodData = apodData {
                            Button(action: { showingDetail = true }) {
                                PictureCardView(
                                    imageURL: apodData.url,
                                    title: apodData.title,
                                    date: apodData.date,
                                    source: "NASA"
                                )
                            }
                            .buttonStyle(.plain)
                        } else {
                            ContentUnavailableView(
                                "Picture Unavailable",
                                systemImage: "photo.badge.exclamationmark",
                                description: Text("Could not load the Picture of the Day")
                            )
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: Color(.systemGray4), radius: 5)
                            )
                            .padding(.horizontal)
                        }
                    }
                    
                    // Space News Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Space News")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        NewsFilterView(selectedFilter: $selectedFilter)
                        
                        if isLoadingNews {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else if let _ = newsError {
                            ContentUnavailableView(
                                "News Unavailable",
                                systemImage: "newspaper.fill",
                                description: Text("Could not load the latest space news")
                            )
                            .padding()
                        } else if newsArticles.isEmpty {
                            ContentUnavailableView(
                                "No News Available",
                                systemImage: "newspaper",
                                description: Text("There are no space news at the moment")
                            )
                            .padding()
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(newsArticles) { article in
                                    NewsArticleView(article: article)
                                }
                                
                                if !isLoadingMore {
                                    Button(action: loadMore) {
                                        HStack {
                                            Image(systemName: "arrow.down.circle.fill")
                                            Text("Load More Articles")
                                        }
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                        .padding()
                                    }
                                } else {
                                    ProgressView()
                                        .padding()
                                }
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Home")
            .sheet(isPresented: $showingDetail) {
                if let apodData = apodData {
                    APODDetailView(apodData: apodData)
                }
            }
            .task {
                do {
                    apodData = try await APODService.shared.fetchAPOD()
                    isLoading = false
                } catch {
                    self.error = error
                    isLoading = false
                }
            }
            .task {
                await loadNews()
            }
            .onChange(of: selectedFilter) { oldValue, newValue in
                Task {
                    await loadNews()
                }
            }
            .refreshable {
                await refresh()
            }
        }
    }
    
    private func loadNews() async {
        isLoadingNews = true
        newsError = nil
        do {
            newsArticles = try await NewsService.shared.fetchAstronomyNews(filter: selectedFilter)
            isLoadingNews = false
        } catch {
            newsError = error
            isLoadingNews = false
        }
    }
    
    private func loadMore() {
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
    
    private func refresh() async {
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

struct PictureCardView: View {
    let imageURL: String
    let title: String
    let date: String
    let source: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Image container
            AsyncImage(url: URL(string: imageURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .clipped()
                case .failure:
                    ContentUnavailableView(
                        "Image Unavailable",
                        systemImage: "photo.badge.exclamationmark",
                        description: Text("The image could not be loaded")
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                @unknown default:
                    EmptyView()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Text content
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title3)
                    .bold()
                    .lineLimit(2)
                Text(date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Source: \(source)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color(.systemGray4), radius: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.systemGray5), lineWidth: 0.5)
                )
        )
        .padding(.horizontal)
    }
}

#Preview {
    HomeView()
}
