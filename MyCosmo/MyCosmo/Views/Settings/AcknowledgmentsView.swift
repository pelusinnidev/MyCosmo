import SwiftUI

/// View displaying acknowledgments for APIs, documentation, and design resources
/// Used to credit external services and tools that helped build the app
struct AcknowledgmentsView: View {
    var body: some View {
        List {
            // External APIs section
            Section("APIs") {
                InfoSheetRow(symbol: "network",
                           title: "NASA APOD",
                           description: "Astronomy Picture of the Day")
                
                InfoSheetRow(symbol: "newspaper.fill",
                           title: "Space News API",
                           description: "Latest space news and articles")
            }
            
            // Documentation resources section
            Section("Documentation") {
                InfoSheetRow(symbol: "apple.logo",
                           title: "Apple Developer",
                           description: "SwiftUI and iOS documentation")
                
                InfoSheetRow(symbol: "doc.fill",
                           title: "Swift Documentation",
                           description: "Swift language resources")
            }
            
            // Design resources section
            Section("Design") {
                InfoSheetRow(symbol: "paintpalette.fill",
                           title: "SF Symbols",
                           description: "Apple's icon system")
                
                InfoSheetRow(symbol: "ruler.fill",
                           title: "Human Interface Guidelines",
                           description: "Apple's design principles")
            }
        }
        .navigationTitle("Acknowledgments")
    }
}

#Preview {
    NavigationStack {
        AcknowledgmentsView()
    }
} 