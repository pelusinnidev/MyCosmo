import SwiftUI

struct SettingsView: View {
    @AppStorage("appearanceMode") private var appearanceMode = 0 // 0: system, 1: light, 2: dark
    @AppStorage("selectedLanguage") private var selectedLanguage = "English"
    @AppStorage("nasaApiKey") private var nasaApiKey = ""
    @State private var remainingRequests: Int?
    @State private var showingNASASettings = false
    @State private var isEditingAPIKey = false
    
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
                
                Section {
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Space News API")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 4) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                Text("Active")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                        
                        Divider()
                        
                        Button {
                            showingNASASettings = true
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("NASA APOD API")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    if !nasaApiKey.isEmpty {
                                        if let remaining = remainingRequests {
                                            Text("\(remaining) requests remaining")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                }
                                
                                Spacer()
                                
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
                        .foregroundStyle(.primary)
                        .padding(.vertical, 4)
                    }
                } header: {
                    Text("API Keys")
                } footer: {
                    Text("API keys are required for certain features of the app")
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
                               description: "\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown") (\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""))")
                        .foregroundStyle(Color.primary)
                }
            }
            .navigationTitle("Settings")
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
    
    private func checkRemainingRequests() async {
        let service = APODService()
        remainingRequests = await service.getRemainingAPIRequests()
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
