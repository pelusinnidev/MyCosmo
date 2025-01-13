import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showingDetail = false
    
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
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(.systemBackground))
                                        .shadow(color: Color(.systemGray4), radius: 5)
                                )
                                .padding(.horizontal)
                        } else if let apodData = viewModel.apodData {
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
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                                Text("Picture of the Day not available")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .frame(maxWidth: .infinity)
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
                        
                        NewsFilterView(selectedFilter: $viewModel.selectedFilter)
                        
                        if viewModel.isLoadingNews {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else if viewModel.newsError != nil {
                            ContentUnavailableView(
                                "News Unavailable",
                                systemImage: "newspaper.fill",
                                description: Text("Could not load the latest space news")
                            )
                            .padding()
                        } else if viewModel.newsArticles.isEmpty {
                            ContentUnavailableView(
                                "No News Available",
                                systemImage: "newspaper",
                                description: Text("There are no space news at the moment")
                            )
                            .padding()
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.newsArticles) { article in
                                    NewsArticleView(article: article)
                                }
                                
                                if !viewModel.isLoadingMore {
                                    Button(action: { viewModel.loadMore() }) {
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
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color(.systemBackground), for: .navigationBar)
            .sheet(isPresented: $showingDetail) {
                if let apodData = viewModel.apodData {
                    APODDetailView(apodData: apodData)
                }
            }
            .task {
                await viewModel.loadAPOD()
            }
            .task {
                await viewModel.loadNews()
            }
            .onChange(of: viewModel.selectedFilter) { oldValue, newValue in
                Task {
                    await viewModel.loadNews()
                }
            }
            .refreshable {
                await viewModel.refresh()
            }
            .safeAreaInset(top: 0)
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
                    HStack {
                        Image(systemName: "photo.fill")
                            .foregroundColor(.secondary)
                        Text("No preview")
                            .padding(.vertical)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
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
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color(.systemGray4), radius: 5)
        )
        .padding(.horizontal)
    }
}

#Preview {
    HomeView()
}
