import SwiftUI

struct SolarSystemView: View {
    @State private var apodData: APODResponse?
    @State private var isLoading = true
    @State private var error: Error?
    @State private var showingDetail = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if let apodData = apodData {
                    AsyncImage(url: URL(string: apodData.url)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .onTapGesture {
                                    showingDetail = true
                                }
                        case .failure:
                            Image(systemName: "photo")
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(height: 300)
                    
                    Text(apodData.title)
                        .font(.headline)
                    Text(apodData.date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else if isLoading {
                    ProgressView()
                } else if error != nil {
                    Text("Error loading APOD")
                }
            }
            .navigationTitle("Solar System")
            .sheet(isPresented: $showingDetail) {
                if let apodData = apodData {
                    APODDetailView(apodData: apodData)
                }
            }
            .task {
                do {
                    apodData = try await NASAService.shared.fetchAPOD()
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
    SolarSystemView()
}
