import SwiftUI

struct SettingsView: View {
    @AppStorage("appearanceMode") private var appearanceMode = 0 // 0: system, 1: light, 2: dark
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    
    private let appearanceModes = ["System", "Light", "Dark"]
    private let languages = ["English", "Español", "Català"]
    
    var body: some View {
        NavigationStack {
            List {
                Section("Appearance") {
                    HStack {
                        Label {
                            Picker("Theme", selection: $appearanceMode) {
                                ForEach(0..<appearanceModes.count, id: \.self) { index in
                                    Text(appearanceModes[index])
                                }
                            }
                        } icon: {
                            Image(systemName: appearanceMode == 0 ? "circle.lefthalf.filled" : 
                                              appearanceMode == 1 ? "sun.max.fill" : "moon.stars.fill")
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                }
                
                Section("About") {
                    NavigationLink {
                        AboutView()
                    } label: {
                        InfoSheetRow(symbol: "info.circle.fill",
                                   title: "About",
                                   description: "Information about the project")
                            .foregroundStyle(Color.primary)
                    }
                    
                    NavigationLink {
                        AcknowledgmentsView()
                    } label: {
                        InfoSheetRow(symbol: "heart.fill",
                                   title: "Acknowledgments",
                                   description: "APIs and resources used")
                            .foregroundStyle(Color.primary)
                    }
                }
                
                Section("App Information") {
                    InfoSheetRow(symbol: "number.circle.fill",
                               title: "Version",
                               description: "1.0.0")
                        .foregroundStyle(Color.primary)
                }
            }
            .navigationTitle("Settings")
        }
        .preferredColorScheme(colorScheme)
    }
    
    private var colorScheme: ColorScheme? {
        switch appearanceMode {
        case 1: return .light
        case 2: return .dark
        default: return nil
        }
    }
}

#Preview {
    SettingsView()
}
