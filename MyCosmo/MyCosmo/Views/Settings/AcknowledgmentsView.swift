import SwiftUI

struct AcknowledgmentsView: View {
    var body: some View {
        List {
            Section("APIs") {
                InfoSheetRow(symbol: "network",
                           title: "NASA APOD",
                           description: "Astronomy Picture of the Day")
                
                InfoSheetRow(symbol: "newspaper.fill",
                           title: "Space News API",
                           description: "Latest space news and articles")
            }
            
            Section("Documentation") {
                InfoSheetRow(symbol: "apple.logo",
                           title: "Apple Developer",
                           description: "SwiftUI and iOS documentation")
                
                InfoSheetRow(symbol: "doc.fill",
                           title: "Swift Documentation",
                           description: "Swift language resources")
            }
            
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