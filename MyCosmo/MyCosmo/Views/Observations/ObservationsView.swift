import SwiftUI
import SwiftData

struct ObservationsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var observations: [UserObservation]
    @State private var showingAddSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(observations) { observation in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(observation.title)
                            .font(.headline)
                        Text("Planet: \(observation.planet)")
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

struct AddObservationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var planet = ""
    @State private var category = ObservationCategory.other
    @State private var importance = ImportanceLevel.medium
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Title", text: $title)
                    TextField("Planet", text: $planet)
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                Section("Category") {
                    Picker("Category", selection: $category) {
                        ForEach(ObservationCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                }
                
                Section("Importance") {
                    Picker("Importance", selection: $importance) {
                        ForEach(ImportanceLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                }
            }
            .navigationTitle("New Observation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let observation = UserObservation(
                            title: title,
                            description: description,
                            planet: planet,
                            category: category,
                            importance: importance
                        )
                        modelContext.insert(observation)
                        dismiss()
                    }
                    .disabled(title.isEmpty || planet.isEmpty)
                }
            }
        }
    }
}

#Preview {
    ObservationsView()
}
