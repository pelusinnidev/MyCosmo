import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()
    @State private var showingAPOD = false
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
