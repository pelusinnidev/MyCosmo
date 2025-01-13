import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    
    var body: some View {
        NavigationStack {
            List {
                Section("Appearance") {
                    Toggle(isOn: $isDarkMode) {
                        InfoSheetRow(symbol: "moon.stars.fill",
                                   title: "Dark Mode",
                                   description: "Switch between light and dark appearance")
                    }
                    
                    NavigationLink {
                        Text("Language Settings")
                            .navigationTitle("Language")
                    } label: {
                        InfoSheetRow(symbol: "globe",
                                   title: "Language",
                                   description: "Change app language")
                    }
                }
                
                Section {
                    NavigationLink {
                        AboutView()
                    } label: {
                        InfoSheetRow(symbol: "info.circle.fill",
                                   title: "About",
                                   description: "Information about the project")
                    }
                    
                    NavigationLink {
                        AcknowledgmentsView()
                    } label: {
                        InfoSheetRow(symbol: "heart.fill",
                                   title: "Acknowledgments",
                                   description: "APIs and resources used")
                    }
                }
                
                Section {
                    InfoSheetRow(symbol: "number.circle.fill",
                               title: "Version",
                               description: "1.0.0")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
