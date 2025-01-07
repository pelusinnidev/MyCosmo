import SwiftUI

struct ObservationDetailView: View {
    let observation: UserObservation
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(observation.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack {
                        Image(systemName: "globe")
                        Text(observation.displayPlanet)
                    }
                    .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)
                
                // Category and Importance
                HStack(spacing: 12) {
                    Label(observation.category.rawValue, systemImage: "tag")
                        .padding(8)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                    
                    Label(observation.importance.rawValue, systemImage: "exclamationmark.circle")
                        .padding(8)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(8)
                }
                
                // Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.headline)
                    Text(observation.observationDescription)
                        .font(.body)
                }
                .padding(.vertical)
                
                // Date
                VStack(alignment: .leading, spacing: 4) {
                    Text("Observed on")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(observation.date.formatted(date: .long, time: .short))
                        .font(.subheadline)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
} 