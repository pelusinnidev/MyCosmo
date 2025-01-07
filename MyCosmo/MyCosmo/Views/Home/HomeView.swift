import SwiftUI

struct HomeView: View {
    @State private var apodData: APODResponse?
    @State private var isLoading = true
    @State private var error: Error?
    @State private var showingDetail = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if let apodData = apodData {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Picture of the Day")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .padding(.top)
                            
                            Divider()
                                .padding(.horizontal)
                            
                            HStack(spacing: 16) {
                                AsyncImage(url: URL(string: apodData.url)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 120, height: 140)
                                            .clipped()
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .onTapGesture {
                                                showingDetail = true
                                            }
                                    case .failure:
                                        Image(systemName: "photo")
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Spacer()
                                    Text(apodData.title)
                                        .font(.title3)
                                        .bold()
                                        .lineLimit(2)
                                    Text(apodData.date)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("Source: NASA")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                        }
                        .frame(width: 360)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color(.systemGray4), radius: 5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color(.systemGray5), lineWidth: 0.5)
                                )
                        )
                        .padding()
                    } else if isLoading {
                        ProgressView()
                    } else if error != nil {
                        Text("Error loading APOD")
                    }
                }
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
        }
    }
}

#Preview {
    HomeView()
}
