import SwiftUI

struct SolarSystemView: View {
    @StateObject private var viewModel = SolarSystemViewModel()
    @Environment(\.colorScheme) private var colorScheme
    
    private let columns = [
        GridItem(.adaptive(minimum: 170), spacing: 8)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.isLoading && viewModel.planets.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 40)
                } else {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(viewModel.planets) { planet in
                            PlanetCard(planet: planet, viewModel: viewModel)
                        }
                    }
                    .padding(8)
                }
            }
            .navigationTitle("Solar System")
            .task {
                if viewModel.planets.isEmpty {
                    await viewModel.fetchPlanets()
                }
            }
            .sheet(item: $viewModel.selectedPlanet) { planet in
                PlanetDetailView(planet: planet)
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

struct PlanetCard: View {
    let planet: PlanetData
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: SolarSystemViewModel
    
    var body: some View {
        Button {
            viewModel.selectedPlanet = planet
        } label: {
            VStack(spacing: 0) {
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
                
                Text(planet.englishName)
                    .font(.headline)
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

struct PlanetDetailView: View {
    let planet: PlanetData
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var currentFact: String
    
    init(planet: PlanetData) {
        self.planet = planet
        self._currentFact = State(initialValue: planet.randomFunFact)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Header Image
                    GeometryReader { geo in
                        Image(planet.englishName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()
                    }
                    .frame(height: 250)
                    .overlay {
                        LinearGradient(
                            colors: [
                                .clear,
                                .clear,
                                colorScheme == .dark ? .black : .white
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                    
                    // Content
                    VStack(spacing: 24) {
                        // Planet Name and Type
                        VStack(spacing: 4) {
                            Text(planet.englishName)
                                .font(.title)
                                .fontWeight(.bold)
                            Text(planet.bodyType.capitalized)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top)
                        
                        // Fun Fact Card
                        VStack(spacing: 12) {
                            HStack {
                                Text("Did you know?")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Spacer()
                                Button {
                                    withAnimation {
                                        currentFact = planet.randomFunFact
                                    }
                                } label: {
                                    Image(systemName: "arrow.clockwise")
                                        .font(.title3)
                                        .foregroundStyle(.blue)
                                }
                            }
                            
                            Text(currentFact)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .transition(.opacity)
                        }
                        .padding()
                        .background(colorScheme == .dark ? Color(.systemGray6) : .white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(radius: 2)
                        .padding(.horizontal)
                        
                        // Quick Facts
                        HStack(spacing: 20) {
                            if let moons = planet.moons {
                                QuickFactView(
                                    icon: "moon.stars.fill",
                                    value: "\(moons.count)",
                                    label: "Moons"
                                )
                            }
                            
                            QuickFactView(
                                icon: "thermometer",
                                value: "\(Int(planet.avgTemp - 273.15))°C",
                                label: "Avg Temp"
                            )
                            
                            QuickFactView(
                                icon: "ruler.fill",
                                value: "\(Int(planet.meanRadius))",
                                label: "Radius (km)"
                            )
                        }
                        .padding(.horizontal)
                        
                        // Detailed Info Sections
                        Group {
                            // Physical Characteristics
                            InfoCard(title: "Physical Characteristics") {
                                InfoRow(title: "Mean Radius", value: planet.formattedRadius)
                                InfoRow(title: "Gravity", value: planet.formattedGravity)
                                InfoRow(title: "Mass", value: planet.formattedMass)
                                InfoRow(title: "Average Temperature", value: planet.formattedTemperature)
                                InfoRow(title: "Density", value: "\(Int(planet.density)) kg/m³")
                            }
                            
                            // Orbital Characteristics
                            InfoCard(title: "Orbital Characteristics") {
                                InfoRow(title: "Axial Tilt", value: "\(Int(planet.axialTilt))°")
                                InfoRow(title: "Main Anomaly", value: "\(Int(planet.mainAnomaly))°")
                                InfoRow(title: "Argument of Periapsis", value: "\(Int(planet.argPeriapsis))°")
                            }
                            
                            // Discovery Information
                            if let discoveredBy = planet.discoveredBy,
                               let discoveryDate = planet.discoveryDate {
                                InfoCard(title: "Discovery") {
                                    InfoRow(title: "Discovered By", value: discoveredBy)
                                    InfoRow(title: "Discovery Date", value: discoveryDate)
                                }
                            }
                        }
                    }
                    .padding(.bottom)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                            .font(.title3)
                    }
                }
            }
            .ignoresSafeArea(.all, edges: .top)
        }
    }
}

struct QuickFactView: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct InfoCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
            
            content()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(colorScheme == .dark ? Color(.systemGray6) : .white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    SolarSystemView()
}
