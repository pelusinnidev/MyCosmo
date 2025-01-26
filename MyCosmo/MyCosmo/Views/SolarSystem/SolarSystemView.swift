import SwiftUI
import SwiftData

/// Main view for exploring the solar system
/// Displays a list of planets with basic information and navigation to detailed views
struct SolarSystemView: View {
    @StateObject private var viewModel = SolarSystemViewModel()
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingInfo = false
    
    var body: some View {
        NavigationStack {
            List {
                // Loading state
                if viewModel.isLoading && viewModel.planets.isEmpty {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                } else {
                    // Planet list
                    ForEach(viewModel.planets) { planet in
                        NavigationLink(destination: PlanetDetailView(planet: planet)) {
                            HStack(spacing: 16) {
                                // Planet image
                                Image(planet.englishName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                
                                // Planet info
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(planet.englishName)
                                        .font(.headline)
                                    Text("\(Int(planet.avgTemp - 273.15))°C")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Solar System")
            .toolbar {
                // Info button
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingInfo = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
            .sheet(isPresented: $showingInfo) {
                NavigationStack {
                    List {
                        // Header section
                        Section {
                            VStack(spacing: 16) {
                                // Icon Circle
                                ZStack {
                                    Circle()
                                        .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                                        .frame(width: 100, height: 100)
                                        .shadow(color: .black.opacity(0.1), radius: 10)
                                    
                                    Image(systemName: "globe.europe.africa.fill")
                                        .font(.system(size: 40))
                                        .foregroundStyle(colorScheme == .dark ? .blue : .indigo)
                                }
                                .padding(.top, 16)
                                
                                // Title and description
                                VStack(spacing: 8) {
                                    Text("Solar System")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Text("Explore our solar system's planets with detailed information, fun facts, and beautiful imagery.")
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
                        
                        // Features section
                        Section("Features") {
                            InfoSheetRow(symbol: "globe.europe.africa.fill", title: "Planet Cards", description: "Interactive cards with planet images and basic data")
                            InfoSheetRow(symbol: "text.book.closed.fill", title: "Fun Facts", description: "Interesting facts about each planet")
                            InfoSheetRow(symbol: "ruler.fill", title: "Physical Data", description: "Detailed physical characteristics and measurements")
                        }
                        
                        // Technologies section
                        Section("Technologies") {
                            InfoSheetRow(symbol: "swift", title: "Swift Features", description: "SwiftUI, MVVM, List layouts, Custom animations")
                            InfoSheetRow(symbol: "square.stack.3d.up.fill", title: "Data Source", description: "Local dataset with comprehensive planetary data")
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
            .task {
                if viewModel.planets.isEmpty {
                    await viewModel.fetchPlanets()
                }
            }
            .alert("Error", isPresented: .constant(viewModel.error != nil)) {
                Button("OK") {
                    viewModel.error = nil
                }
            } message: {
                if let error = viewModel.error {
                    Text(error.localizedDescription)
                }
            }
        }
    }
}

/// Card view for displaying a planet in a grid layout
struct PlanetCard: View {
    let planet: PlanetData
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: SolarSystemViewModel
    
    var body: some View {
        Button {
            viewModel.selectedPlanet = planet
        } label: {
            VStack(spacing: 0) {
                // Planet image
                Image(planet.englishName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 170, height: 140)
                    .clipShape(
                        .rect(
                            topLeadingRadius: 12,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 12
                        )
                    )
                
                // Planet info
                VStack(spacing: 4) {
                    Text(planet.englishName)
                        .font(.headline)
                    Text("\(Int(planet.avgTemp - 273.15))°C")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
                .frame(width: 170)
                .background(colorScheme == .dark ? Color(.systemGray6) : .white)
                .clipShape(
                    .rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 12,
                        bottomTrailingRadius: 12,
                        topTrailingRadius: 0
                    )
                )
            }
            .shadow(radius: 3)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SolarSystemView()
}
