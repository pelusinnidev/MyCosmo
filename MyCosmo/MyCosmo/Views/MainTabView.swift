import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "globe.europe.africa.fill")
                }

            SolarSystemView()
                .tabItem {
                    Label("Solar System", systemImage: "sun.and.horizon.fill")
                }

            ObservationsView()
                .tabItem {
                    Label("Observations", systemImage: "binoculars.fill")
                }

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
