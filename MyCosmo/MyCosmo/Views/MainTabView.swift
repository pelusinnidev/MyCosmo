import SwiftUI

/// Main navigation container for the application
/// Provides tab-based navigation between the main sections of the app:
/// - News: Space news and NASA's APOD
/// - Solar System: Planetary information and details
/// - Observations: User's astronomical observations
/// - Settings: App configuration
struct MainTabView: View {
    var body: some View {
        TabView {
            // News tab - Shows space news and NASA's APOD
            NewsView()
                .tabItem {
                    Label("News", systemImage: "newspaper.fill")
                }

            // Solar System tab - Shows planetary information
            SolarSystemView()
                .tabItem {
                    Label("Solar System", systemImage: "globe.europe.africa.fill")
                }

            // Observations tab - Shows user's astronomical observations
            ObservationsView()
                .tabItem {
                    Label("Observations", systemImage: "binoculars.fill")
                }

            // Settings tab - App configuration and preferences
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    MainTabView()
}
