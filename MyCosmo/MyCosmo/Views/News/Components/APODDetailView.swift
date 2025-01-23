import SwiftUI

struct APODDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let apodData: APODResponse?
    let error: Error?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if let error = error as? APIError, error == .missingAPIKey {
                    VStack(spacing: 24) {
                        Image(systemName: "key.slash.fill")
                            .font(.system(size: 38))
                            .foregroundStyle(.secondary)
                            .padding(.top, 32)
                        
                        VStack(spacing: 8) {
                            Text("API Key Required")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("Add your NASA API key in Settings to access the Astronomy Picture of the Day")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal)
                        
                        Link(destination: URL(string: "https://api.nasa.gov/?ref=beautifulpublicdata.com")!) {
                            Text("Get Free API Key")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .padding()
                } else if let apodData = apodData {
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
