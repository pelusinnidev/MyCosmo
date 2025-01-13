import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("News", systemImage: "newspaper.fill")
                }

            SolarSystemView()
                .tabItem {
                    Label("Solar System", systemImage: "globe.europe.africa.fill")
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
