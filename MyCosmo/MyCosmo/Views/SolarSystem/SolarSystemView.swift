import SwiftUI
import SwiftData

struct SolarSystemView: View {
    @StateObject private var viewModel = SolarSystemViewModel()
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingInfo = false
    
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
            .toolbar {
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
                                
                                // Title and Subtitle
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
                        
                        Section("Features") {
                            InfoSheetRow(symbol: "globe.europe.africa.fill", title: "Planet Cards", description: "Interactive cards with planet images and basic data")
                            InfoSheetRow(symbol: "text.book.closed.fill", title: "Fun Facts", description: "Interesting facts about each planet")
                            InfoSheetRow(symbol: "ruler.fill", title: "Physical Data", description: "Detailed physical characteristics and measurements")
                        }
                        
                        Section("Technologies") {
                            InfoSheetRow(symbol: "swift", title: "Swift Features", description: "SwiftUI, MVVM, Grid layouts, Custom animations")
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
                            .overlay {
                                LinearGradient(
                                    colors: [
                                        .clear,
                                        .clear,
                                        colorScheme == .dark ? .black.opacity(0.8) : .white.opacity(0.8)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            }
                    }
                    .frame(height: 250)
                    
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
                        
                        // Fun Fact Card with improved animation
                        VStack(spacing: 12) {
                            HStack {
                                Text("Did you know?")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Spacer()
                                Button {
                                    withAnimation(.easeInOut) {
                                        currentFact = planet.randomFunFact
                                    }
                                } label: {
                                    Image(systemName: "arrow.clockwise.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(colorScheme == .dark ? .blue : .indigo)
                                        .symbolEffect(.bounce, value: currentFact)
                                }
                            }
                            
                            Text(currentFact)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .id(currentFact) // Para mejor animación
                                .transition(.opacity.combined(with: .slide))
                        }
                        .padding()
                        .background(colorScheme == .dark ? Color(.systemGray6) : .white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(radius: colorScheme == .dark ? 1 : 2)
                        .padding(.horizontal)
                        
                        // Quick Facts
                        VStack(spacing: 16) {
                            Text("Quick Facts")
                                .font(.title3)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(spacing: 12) {
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
            .ignoresSafeArea(.all, edges: .top)
        }
        .presentationDragIndicator(.visible)
        .interactiveDismissDisabled(false)
    }
}

struct QuickFactView: View {
    let icon: String
    let value: String
    let label: String
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(colorScheme == .dark ? .blue : .indigo)
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(colorScheme == .dark ? Color(.systemGray6) : .white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: colorScheme == .dark ? 1 : 2)
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
                .foregroundStyle(colorScheme == .dark ? .white : .black)
            
            content()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(colorScheme == .dark ? Color(.systemGray6) : .white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: colorScheme == .dark ? 1 : 2)
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
