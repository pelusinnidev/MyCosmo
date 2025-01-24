import SwiftUI

struct QuickFactsSection: View {
    let planet: PlanetData
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
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

struct FunFactCard: View {
    @Binding var currentFact: String
    let planet: PlanetData
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
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
                .id(currentFact)
                .transition(.opacity.combined(with: .slide))
        }
        .padding()
        .background(colorScheme == .dark ? Color(.systemGray6) : .white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: colorScheme == .dark ? 1 : 2)
        .padding(.horizontal)
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