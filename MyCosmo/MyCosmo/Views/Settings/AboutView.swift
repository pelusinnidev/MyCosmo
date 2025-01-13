import SwiftUI

struct AboutView: View {
    var body: some View {
        List {
            Section {
                InfoSheetRow(symbol: "app.fill",
                           title: "MyCosmo",
                           description: "Your personal astronomy companion")
            }
            
            Section("Project") {
                InfoSheetRow(symbol: "person.fill",
                           title: "Creator",
                           description: "Pol Huertas Barros")
                
                InfoSheetRow(symbol: "building.columns.fill",
                           title: "School",
                           description: "Universitat Politècnica de Catalunya (UPC)")
                
                InfoSheetRow(symbol: "doc.text.fill",
                           title: "Course",
                           description: "Final Degree Project - 2024")
            }
            
            Section("Technologies") {
                InfoSheetRow(symbol: "swift",
                           title: "Swift & SwiftUI",
                           description: "Native iOS development")
                
                InfoSheetRow(symbol: "arrow.triangle.2.circlepath",
                           title: "Async/Await",
                           description: "Modern concurrency")
                
                InfoSheetRow(symbol: "externaldrive.fill.badge.person",
                           title: "Core Data",
                           description: "Local data persistence")
                
                InfoSheetRow(symbol: "chart.bar.fill",
                           title: "Charts",
                           description: "Data visualization")
            }
        }
        .navigationTitle("About")
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
} 