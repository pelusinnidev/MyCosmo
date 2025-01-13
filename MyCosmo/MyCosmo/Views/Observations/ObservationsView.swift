import SwiftUI
import SwiftData
import PhotosUI

struct ObservationsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme
    @Query private var observations: [UserObservation]
    @StateObject private var viewModel: ObservationsViewModel
    @State private var selectedCategory: ObservationCategory?
    @State private var selectedImportance: ImportanceLevel?
    @State private var selectedPlanet: Planet?
    @State private var showingFilters = false
    @State private var showingInfo = false
    
    init() {
        let context = try! ModelContainer(for: UserObservation.self).mainContext
        _viewModel = StateObject(wrappedValue: ObservationsViewModel(modelContext: context))
    }
    
    var filteredObservations: [UserObservation] {
        observations.filter { observation in
            let categoryMatch = selectedCategory == nil || observation.category == selectedCategory
            let importanceMatch = selectedImportance == nil || observation.importance == selectedImportance
            let planetMatch = selectedPlanet == nil || observation.selectedPlanet == selectedPlanet
            return categoryMatch && importanceMatch && planetMatch
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredObservations) { observation in
                    NavigationLink(destination: ObservationDetailView(observation: observation)) {
                        ObservationRowView(observation: observation)
                    }
                }
            }
            .navigationTitle("Observations")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingInfo = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { viewModel.showingAddSheet = true }) {
                        Label("Add Observation", systemImage: "plus.circle.fill")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        // Clear Filters
                        Button(action: clearFilters) {
                            Label("Clear Filters", systemImage: "xmark.circle.fill")
                        }
                        
                        // Categories Section
                        Section("Category") {
                            ForEach(ObservationCategory.allCases, id: \.self) { category in
                                Button(action: { toggleCategory(category) }) {
                                    Label(category.rawValue, systemImage: selectedCategory == category ? "checkmark.circle.fill" : "circle")
                                }
                            }
                        }
                        
                        // Importance Section
                        Section("Importance") {
                            ForEach(ImportanceLevel.allCases, id: \.self) { importance in
                                Button(action: { toggleImportance(importance) }) {
                                    Label(importance.rawValue, systemImage: selectedImportance == importance ? "checkmark.circle.fill" : "circle")
                                }
                            }
                        }
                        
                        // Planets Section
                        Section("Planet") {
                            ForEach(Planet.allCases, id: \.self) { planet in
                                Button(action: { togglePlanet(planet) }) {
                                    Label(planet.rawValue, systemImage: selectedPlanet == planet ? "checkmark.circle.fill" : "circle")
                                }
                            }
                        }
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                            .symbolEffect(.bounce, value: hasActiveFilters)
                    }
                }
            }
            .sheet(isPresented: $showingInfo) {
                NavigationStack {
                    List {
                        Section {
                            VStack(spacing: 16) {
                                // Icon Circle
                                ZStack {
                                    Circle()
                                        .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                                        .frame(width: 100, height: 100)
                                        .shadow(color: .black.opacity(0.1), radius: 10)
                                    
                                    Image(systemName: "binoculars.fill")
                                        .font(.system(size: 40))
                                        .foregroundStyle(colorScheme == .dark ? .blue : .indigo)
                                }
                                .padding(.top, 16)
                                
                                // Title and Subtitle
                                VStack(spacing: 8) {
                                    Text("Observations")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Text("Record and track your astronomical observations with detailed information, images, and categorization.")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                }
                                .padding(.bottom, 16)
                            }
                            .frame(maxWidth: .infinity)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                        }
                        
                        Section("Features") {
                            InfoSheetRow(symbol: "camera.fill", title: "Photo Gallery", description: "Add multiple photos to each observation")
                            InfoSheetRow(symbol: "tag.fill", title: "Categories", description: "Organize by type and importance level")
                            InfoSheetRow(symbol: "line.3.horizontal.decrease.circle", title: "Smart Filters", description: "Filter by planet, category, or importance")
                        }
                        
                        Section("Technologies") {
                            InfoSheetRow(symbol: "swift", title: "Swift Features", description: "SwiftData, PhotosUI, SwiftUI, MVVM")
                            InfoSheetRow(symbol: "square.and.arrow.up.fill", title: "Data Storage", description: "Local persistence with SwiftData")
                            InfoSheetRow(symbol: "photo.stack", title: "Image Handling", description: "PhotosUI integration and image compression")
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") {
                                showingInfo = false
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddSheet) {
                AddObservationView()
            }
        }
    }
    
    private var hasActiveFilters: Bool {
        selectedCategory != nil || selectedImportance != nil || selectedPlanet != nil
    }
    
    private func clearFilters() {
        selectedCategory = nil
        selectedImportance = nil
        selectedPlanet = nil
    }
    
    private func toggleCategory(_ category: ObservationCategory) {
        if selectedCategory == category {
            selectedCategory = nil
        } else {
            selectedCategory = category
        }
    }
    
    private func toggleImportance(_ importance: ImportanceLevel) {
        if selectedImportance == importance {
            selectedImportance = nil
        } else {
            selectedImportance = importance
        }
    }
    
    private func togglePlanet(_ planet: Planet) {
        if selectedPlanet == planet {
            selectedPlanet = nil
        } else {
            selectedPlanet = planet
        }
    }
}

struct ObservationRowView: View {
    let observation: UserObservation
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            // Thumbnail Image
            observation.displayImage
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 0.5)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                // Title and Planet
                HStack {
                    Text(observation.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(observation.displayPlanet)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Description
                if !observation.observationDescription.isEmpty {
                    Text(observation.observationDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                // Tags
                HStack(spacing: 4) {
                    // Category Tag
                    Text(observation.category.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(colorScheme == .dark ? 0.2 : 0.1))
                        .foregroundColor(.blue)
                        .clipShape(Capsule())
                    
                    // Importance Tag
                    Text(observation.importance.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.orange.opacity(colorScheme == .dark ? 0.2 : 0.1))
                        .foregroundColor(.orange)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ObservationsView()
}

