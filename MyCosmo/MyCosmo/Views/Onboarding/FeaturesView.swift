import SwiftUI

struct FeaturesView: View {
    let nextPage: () -> Void
    @State private var selectedFeature = 0
    
    private let features = [
        FeatureItem(
            title: "Space News",
            description: "Stay updated with the latest astronomical discoveries and space exploration news",
            icon: "newspaper.fill",
            color: Color(red: 0.2, green: 0.6, blue: 1.0)
        ),
        FeatureItem(
            title: "Solar System",
            description: "Explore detailed information about planets, moons, and other celestial bodies",
            icon: "globe.americas.fill",
            color: Color(red: 0.6, green: 0.2, blue: 1.0)
        ),
        FeatureItem(
            title: "Observations",
            description: "Document and track your astronomical observations with photos and notes",
            icon: "binoculars.fill",
            color: Color(red: 0.2, green: 0.8, blue: 0.8)
        )
    ]
    
    var body: some View {
        VStack(spacing: 32) {
            Text("Discover Features")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.top, 60)
            
            TabView(selection: $selectedFeature) {
                ForEach(0..<features.count, id: \.self) { index in
                    FeatureCard(feature: features[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page)
            .frame(height: 400)
            
            Spacer()
            
            Button(action: nextPage) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .white.opacity(0.2), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 60)
        }
    }
}

struct FeatureItem {
    let title: String
    let description: String
    let icon: String
    let color: Color
}

struct FeatureCard: View {
    let feature: FeatureItem
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: feature.icon)
                .font(.system(size: 60))
                .foregroundStyle(feature.color)
                .symbolEffect(.bounce, options: .repeating)
                .padding(.top, 40)
            
            VStack(spacing: 16) {
                Text(feature.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(feature.description)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.black.opacity(0.3))
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 24))
        )
        .padding(.horizontal, 20)
        .rotation3DEffect(
            .degrees(isAnimating ? 0 : -10),
            axis: (x: 1, y: 0, z: 0)
        )
        .offset(y: isAnimating ? 0 : 50)
        .opacity(isAnimating ? 1 : 0)
        .onAppear {
            withAnimation(.spring(duration: 0.8)) {
                isAnimating = true
            }
        }
    }
} 