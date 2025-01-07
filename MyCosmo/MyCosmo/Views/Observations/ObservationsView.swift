import SwiftUI
import SwiftData
import PhotosUI

struct ObservationsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var observations: [UserObservation]
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(observations) { observation in
                    NavigationLink(destination: ObservationDetailView(observation: observation)) {
                        HStack(spacing: 12) {
                            observation.displayImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(observation.title)
                                    .font(.headline)
                                Text("Planet: \(observation.displayPlanet)")
                                    .font(.subheadline)
                                Text(observation.observationDescription)
                                    .font(.body)
                                    .lineLimit(2)
                                HStack {
                                    Text(observation.category.rawValue)
                                        .font(.caption)
                                        .padding(4)
                                        .background(Color.blue.opacity(0.2))
                                        .cornerRadius(4)
                                    Text(observation.importance.rawValue)
                                        .font(.caption)
                                        .padding(4)
                                        .background(Color.orange.opacity(0.2))
                                        .cornerRadius(4)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .onDelete(perform: deleteObservations)
            }
            .navigationTitle("Observations")
            .toolbar {
                Button(action: { showingAddSheet = true }) {
                    Label("Add Observation", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddObservationView()
            }
        }
    }
    
    private func deleteObservations(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(observations[index])
        }
    }
}

#Preview {
    ObservationsView()
}
