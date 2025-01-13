import SwiftUI

struct APODDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let apodData: APODResponse
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    AsyncImage(url: URL(string: apodData.url)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .failure:
                            Image(systemName: "photo")
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    Text(apodData.title)
                        .font(.title)
                        .bold()
                    
                    Text(apodData.date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(apodData.explanation)
                        .font(.body)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
