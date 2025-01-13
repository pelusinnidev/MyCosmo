import SwiftUI
import SwiftData

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()
    @State private var showingAPOD = false
    @State private var showingInfo = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Filter Pills
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(NewsType.allCases, id: \.self) { type in
                                FilterPillButton(
                                    type: type,
                                    isSelected: viewModel.selectedNewsType == type,
                                    action: { viewModel.changeNewsType(type) }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                    
                    // News Cards
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.newsArticles) { article in
                            NewsCard(article: article)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Space News")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingInfo = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await viewModel.fetchAPOD()
                            showingAPOD = true
                        }
                    } label: {
                        Image(systemName: "camera.badge.clock")
                    }
                }
            }
            .sheet(isPresented: $showingInfo) {
                NavigationStack {
                    List {
                        Section {
                            VStack(spacing: 16) {
                                // Icon Circle
                                ZStack {
                                    Circle()
                                        .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                                        .frame(width: 100, height: 100)
                                        .shadow(color: .black.opacity(0.1), radius: 10)
                                    
                                    Image(systemName: "newspaper.fill")
                                        .font(.system(size: 40))
                                        .foregroundStyle(colorScheme == .dark ? .blue : .indigo)
                                }
                                .padding(.top, 16)
                                
                                // Title and Subtitle
                                VStack(spacing: 8) {
                                    Text("Space News")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Text("Stay up to date with the latest space news, launches, and discoveries from around the world.")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                }
                                .padding(.bottom, 16)
                            }
                            .frame(maxWidth: .infinity)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                        }
                        
                        Section("Features") {
                            InfoSheetRow(symbol: "newspaper.fill", title: "Space News", description: "Latest articles from SpaceFlightNews API")
                            InfoSheetRow(symbol: "camera.badge.clock", title: "NASA APOD", description: "NASA's Astronomy Picture of the Day")
                            InfoSheetRow(symbol: "line.3.horizontal.decrease.circle", title: "News Filters", description: "Filter by articles, blogs, or reports")
                        }
                        
                        Section("Technologies") {
                            InfoSheetRow(symbol: "swift", title: "Swift Features", description: "Async/await, SwiftUI, MVVM architecture")
                            InfoSheetRow(symbol: "network", title: "APIs", description: "SpaceFlightNews API, NASA APOD API")
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") {
                                showingInfo = false
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAPOD) {
                if let apodData = viewModel.apodData {
                    APODDetailView(apodData: apodData)
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .task {
                await viewModel.fetchNews()
            }
        }
    }
}

struct FilterPillButton: View {
    let type: NewsType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: type.icon)
                Text(type.rawValue)
            }
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(isSelected ? .white : type.color)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? type.color : type.color.opacity(0.15))
            )
        }
    }
}

struct NewsCard: View {
    let article: SpaceNewsArticle
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Link(destination: URL(string: article.url)!) {
            VStack(alignment: .leading, spacing: 12) {
                // Image
                AsyncImage(url: URL(string: article.imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .aspectRatio(16/9, contentMode: .fit)
                            .overlay {
                                ProgressView()
                            }
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(16/9, contentMode: .fit)
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .aspectRatio(16/9, contentMode: .fit)
                            .overlay {
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            }
                    @unknown default:
                        EmptyView()
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(article.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    
                    Text(article.summary)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    
                    HStack(alignment: .center, spacing: 8) {
                        Text(article.newsSite)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text(formatDate(article.publishedAt))
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = formatter.date(from: dateString) else { return dateString }
        
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
