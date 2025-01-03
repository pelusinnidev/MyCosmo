import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            SolarSystemView()
                .tabItem {
                    Label("Solar System", systemImage: "globe")
                }

            EventsView()
                .tabItem {
                    Label("Events", systemImage: "calendar")
                }

            ObservationsView()
                .tabItem {
                    Label("Observations", systemImage: "magnifyingglass")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    MainTabView()
}
