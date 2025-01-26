import SwiftUI

/// Second screen of the onboarding experience
/// Presents the app's main features with interactive, animated cards
struct FeaturesView: View {
    /// Closure to trigger navigation to the next page
    let nextPage: () -> Void
    /// Controls the animation state of view elements
    @State private var isAnimated = false
    /// Tracks the currently expanded feature card
    @State private var selectedFeatureId: UUID?
    
    /// Array of features to display
    private let features = [
        Feature(title: "Space News", 
               icon: "newspaper.fill", 
               color: .blue,
               description: "Stay updated with the latest astronomy news and NASA's Astronomy Picture of the Day"),
        Feature(title: "Solar System", 
               icon: "globe.americas.fill", 
               color: .purple,
               description: "Explore detailed information about planets, moons, and other objects in our Solar System"),
        Feature(title: "Observations", 
               icon: "binoculars.fill", 
               color: .teal,
               description: "Record and track your astronomical observations and discoveries")
    ]
    
    var body: some View {
        VStack(spacing: 40) {
            // Title with fade-in animation
            Text("Features")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.top, 60)
                .opacity(isAnimated ? 1 : 0)
            
            // Feature cards with slide-in animation
            VStack(spacing: 24) {
                ForEach(features) { feature in
                    FeatureRow(feature: feature, selectedFeatureId: $selectedFeatureId)
                        .opacity(isAnimated ? 1 : 0)
                        .offset(x: isAnimated ? 0 : -50)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Continue button with fade-in animation
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

/// Model representing a feature to be displayed in the onboarding
struct Feature: Identifiable {
    /// Unique identifier for the feature
    let id = UUID()
    /// Title of the feature
    let title: String
    /// SF Symbol name for the feature's icon
    let icon: String
    /// Theme color for the feature
    let color: Color
    /// Detailed description of the feature
    let description: String
}

/// Custom row view for displaying a feature with expandable description
struct FeatureRow: View {
    /// The feature to display
    let feature: Feature
    /// Binding to track the selected feature's ID
    @Binding var selectedFeatureId: UUID?
    
    /// Computed property to determine if this row is expanded
    private var isExpanded: Bool {
        selectedFeatureId == feature.id
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Feature header with icon and title
            Button(action: {
                withAnimation(.spring()) {
                    selectedFeatureId = isExpanded ? nil : feature.id
                }
            }) {
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
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white.opacity(0.6))
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
            }
            
            // Expandable description
            if isExpanded {
                Text(feature.description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.leading, 80)
                    .padding(.trailing, 20)
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
} 
