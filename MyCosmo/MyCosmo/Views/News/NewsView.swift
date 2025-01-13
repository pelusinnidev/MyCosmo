import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()
    @State private var showingAPOD = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("News")
            }
            .navigationTitle("News")
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
        }
    }
}
