import SwiftUI

struct AboutView: View {
    var body: some View {
        List {
            Section {
                HStack {
                    Image("AppIconResource")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("MyCosmo")
                            .font(.headline)
                        Text("Be your universe.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.leading, 8)
                }
                .padding(.vertical, 4)
            }
            
            Section("Project") {
                InfoSheetRow(symbol: "person.2.fill",
                           title: "Creators",
                           description: "Pol Hernàndez & Adrià Sanchez")
                
                InfoSheetRow(symbol: "building.columns.fill",
                           title: "School",
                           description: "La Salle Gràcia")
                
                InfoSheetRow(symbol: "doc.text.fill",
                           title: "Course",
                           description: "DAM2 - M08")
            }
            
            Section("Technologies") {
                InfoSheetRow(symbol: "swift",
                           title: "Swift & SwiftUI",
                           description: "Native iOS development")
                
                InfoSheetRow(symbol: "arrow.triangle.2.circlepath",
                           title: "Async/Await",
                           description: "Modern concurrency")
                
                InfoSheetRow(symbol: "archivebox.fill",
                           title: "Swift Data",
                           description: "Local data persistence")
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
