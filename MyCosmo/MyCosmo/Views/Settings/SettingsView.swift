import SwiftUI

/// Main settings view for the application
/// Provides user configuration options and app information
struct SettingsView: View {
    // App preferences
    @AppStorage("appearanceMode") private var appearanceMode = 0 // 0: system, 1: light, 2: dark
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    @AppStorage("nasaApiKey") private var nasaApiKey = ""
    
    // View state
    @State private var remainingRequests: Int?
    @State private var showingNASASettings = false
    @State private var isEditingAPIKey = false
    
    // Constants
    private let appearanceModes = ["System", "Light", "Dark"]
    private let languages = ["English", "Español", "Català"]
    
    /// Returns the color scheme based on the selected appearance mode
    private var colorScheme: ColorScheme? {
        switch appearanceMode {
        case 1: return .light
        case 2: return .dark
        default: return nil
        }
    }
    
    /// Checks the remaining API requests for the NASA APOD API
    private func checkRemainingRequests() async {
        let service = APODService()
        remainingRequests = await service.getRemainingAPIRequests()
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Appearance Section
                Section {
                    // Theme picker
                    HStack {
                        Label {
                            Text("Theme")
                        } icon: {
                            Image(systemName: appearanceMode == 0 ? "circle.lefthalf.filled" : 
                                          appearanceMode == 1 ? "sun.max.fill" : "moon.stars.fill")
                                .foregroundStyle(Color.accentColor)
                                .frame(width: 26)
                        }
                        
                        Spacer()
                        
                        Picker("", selection: $appearanceMode) {
                            ForEach(0..<appearanceModes.count, id: \.self) { index in
                                Text(appearanceModes[index])
                            }
                        }
                        .labelsHidden()
                    }
                    
                    /*
                        HStack {
                            Label {
                                Text("Language")
                            } icon: {
                                Image(systemName: "globe")
                                    .foregroundStyle(Color.accentColor)
                                    .frame(width: 26)
                            }
                            
                            Spacer()
                            
                            Picker("", selection: $selectedLanguage) {
                                ForEach(languages, id: \.self) { language in
                                    Text(language)
                                }
                            }
                            .labelsHidden()
                        }
                     */
                } header: {
                    Text("Appearance")
                }
                
                // API Settings Section
                Section {
                    // NASA APOD API settings
                    Button {
                        showingNASASettings = true
                    } label: {
                        HStack {
                            Label {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("NASA APOD API")
                                        .foregroundStyle(.primary)
                                    if !nasaApiKey.isEmpty {
                                        if let remaining = remainingRequests {
                                            Text("\(remaining) requests remaining")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                }
                            } icon: {
                                Image(systemName: "key.fill")
                                    .foregroundStyle(Color.accentColor)
                                    .frame(width: 26)
                            }
                            
                            Spacer()
                            
                            // API status indicator
                            HStack(spacing: 4) {
                                if nasaApiKey.isEmpty {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .foregroundStyle(.orange)
                                    Text("Required")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                } else {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                    Text("Active")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    
                    // Space News API status
                    Label {
                        HStack {
                            Text("Space News API")
                            Spacer()
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                Text("Active")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    } icon: {
                        Image(systemName: "newspaper.fill")
                            .foregroundStyle(Color.accentColor)
                            .frame(width: 26)
                    }
                } header: {
                    Text("API Settings")
                } footer: {
                    Text("API keys are required for certain features of the app")
                }
                
                // About Section
                Section {
                    NavigationLink {
                        AboutView()
                    } label: {
                        Label {
                            Text("About")
                        } icon: {
                            Image(systemName: "info.circle.fill")
                                .foregroundStyle(Color.accentColor)
                                .frame(width: 26)
                        }
                    }
                    
                    NavigationLink {
                        AcknowledgmentsView()
                    } label: {
                        Label {
                            Text("Acknowledgments")
                        } icon: {
                            Image(systemName: "heart.fill")
                                .foregroundStyle(Color.accentColor)
                                .frame(width: 26)
                        }
                    }
                }
                
                // App Info Section
                Section {
                    Label {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown") (\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""))")
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "number.circle.fill")
                            .foregroundStyle(Color.accentColor)
                            .frame(width: 26)
                    }
                }
            }
            .navigationTitle("Settings")
            // NASA API settings sheet
            .sheet(isPresented: $showingNASASettings) {
                NavigationStack {
                    List {
                        Section {
                            if nasaApiKey.isEmpty {
                                Text("No API key configured")
                                    .foregroundStyle(.secondary)
                            } else {
                                SecureField("NASA API Key", text: $nasaApiKey)
                            }
                        } header: {
                            Text("Current API Key")
                        }
                        
                        Section {
                            Link(destination: URL(string: "https://api.nasa.gov/?ref=beautifulpublicdata.com")!) {
                                HStack {
                                    Text("Get Free API Key")
                                    Spacer()
                                    Image(systemName: "arrow.up.right")
                                        .font(.caption)
                                }
                            }
                            
                            Button {
                                showingNASASettings = false
                                isEditingAPIKey = true
                            } label: {
                                if nasaApiKey.isEmpty {
                                    Text("Add API Key")
                                } else {
                                    Text("Change API Key")
                                }
                            }
                        }
                    }
                    .navigationTitle("NASA APOD API")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") {
                                showingNASASettings = false
                                Task {
                                    await checkRemainingRequests()
                                }
                            }
                        }
                    }
                }
                .presentationDetents([.medium])
            }
            // API key editing sheet
            .sheet(isPresented: $isEditingAPIKey) {
                NavigationStack {
                    Form {
                        Section {
                            SecureField("NASA API Key", text: $nasaApiKey)
                        } footer: {
                            Text("Enter your NASA API key to use the Astronomy Picture of the Day feature")
                        }
                    }
                    .navigationTitle("Add API Key")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isEditingAPIKey = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                isEditingAPIKey = false
                                Task {
                                    await checkRemainingRequests()
                                }
                            }
                        }
                    }
                }
                .presentationDetents([.height(250)])
            }
        }
        .task {
            await checkRemainingRequests()
        }
    }
}

#Preview {
    SettingsView()
}
