import Foundation
import SwiftUI

enum OnboardingPage: Identifiable, CaseIterable {
    case welcome
    case features
    case thanks
    
    var id: Self { self }
}

struct OnboardingItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let systemImage: String
    let tint: Color
    
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
        ),
        OnboardingItem(
            title: "Customize Your Experience",
            description: "Personalize your cosmic journey with customizable settings and preferences.",
            systemImage: "gearshape.fill",
            tint: .gray
        )
    ]
    
    static let credits = """
    Special thanks to:
    • NASA APIs
    • JPL Solar System Dynamics
    • Space Weather Database
    • EONET
    """
} 