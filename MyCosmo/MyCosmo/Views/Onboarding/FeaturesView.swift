import SwiftUI

struct FeaturesView: View {
    let nextPage: () -> Void
    @State private var isAnimated = false
    
    private let features = [
        Feature(title: "Space News", icon: "newspaper.fill", color: .blue),
        Feature(title: "Solar System", icon: "globe.americas.fill", color: .purple),
        Feature(title: "Observations", icon: "binoculars.fill", color: .teal)
    ]
    
    var body: some View {
        VStack(spacing: 40) {
            Text("Key Features")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.top, 60)
                .opacity(isAnimated ? 1 : 0)
            
            VStack(spacing: 24) {
                ForEach(features) { feature in
                    FeatureRow(feature: feature)
                        .opacity(isAnimated ? 1 : 0)
                        .offset(x: isAnimated ? 0 : -50)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            Button(action: nextPage) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.white)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 48)
            .opacity(isAnimated ? 1 : 0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isAnimated = true
            }
        }
    }
}

struct Feature: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
}

struct FeatureRow: View {
    let feature: Feature
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: feature.icon)
                .font(.system(size: 30))
                .foregroundStyle(feature.color)
                .frame(width: 60, height: 60)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
            
            Text(feature.title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(16)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
} 
