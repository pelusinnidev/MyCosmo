import Foundation
import SwiftUI

/// Represents the different pages available in the onboarding flow
/// Each case corresponds to a specific onboarding screen
enum OnboardingPage: Identifiable, CaseIterable {
    /// Welcome screen introducing the app
    case welcome
    /// Features overview screen
    case features
    /// Final thank you screen
    case thanks
    
    var id: Self { self }
}

/// Represents an individual onboarding item with its associated content and styling
/// Used to display feature highlights during the app's onboarding process
struct OnboardingItem: Identifiable {
    /// Unique identifier for the onboarding item
    let id = UUID()
    /// Title of the feature or section
    let title: String
    /// Detailed description of the feature
    let description: String
    /// SF Symbol name for the feature's icon
    let systemImage: String
    /// Theme color for the feature
    let tint: Color
    
    /// Predefined features shown during onboarding
    /// Each feature highlights a key aspect of the app
    static let features: [OnboardingItem] = [
        OnboardingItem(
            title: "Explore Your Home",
            description: "Stay updated with NASA's Picture of the Day and discover the wonders of our planet Earth.",
            systemImage: "globe.europe.africa.fill",
            tint: .blue
        ),
        OnboardingItem(
            title: "Journey Through Space",
            description: "Embark on an interactive tour of our Solar System, with detailed information about each celestial body.",
            systemImage: "sun.and.horizon.fill",
            tint: .orange
        ),
        OnboardingItem(
            title: "Record Your Discoveries",
            description: "Document your astronomical observations, from meteor showers to planetary alignments.",
            systemImage: "binoculars.fill",
            tint: .purple
        )
    ]
    
    /// Credits and acknowledgments for data sources
    static let credits = """
    Special thanks to:
    • NASA APIs
    • JPL Solar System Dynamics
    • Space Weather Database
    • EONET
    """
} 