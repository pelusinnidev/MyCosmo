import SwiftUI

/// Content structure for the information sheet
/// Contains all the data needed to display feature and technology information
struct InfoSheetContent {
    /// SF Symbol name for the main icon
    let icon: String
    /// Main title of the information sheet
    let title: String
    /// Subtitle or brief description
    let subtitle: String
    /// Array of feature items with their symbols, titles, and descriptions
    let features: [(symbol: String, title: String, description: String)]
    /// Array of technology items with their symbols, titles, and descriptions
    let technologies: [(symbol: String, title: String, description: String)]
}

/// A reusable sheet view that displays information about app features and technologies
/// Presents content in a structured format with:
/// - Header with icon and title
/// - Features section with icons and descriptions
/// - Technologies section with implementation details
struct InfoSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    /// Content to be displayed in the sheet
    let content: InfoSheetContent
    
    var body: some View {
        NavigationStack {
            List {
                // Header Section with Icon and Title
                Section {
                    VStack(spacing: 16) {
                        // Icon Circle with shadow
                        ZStack {
                            Circle()
                                .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                                .frame(width: 100, height: 100)
                                .shadow(color: .black.opacity(0.1), radius: 10)
                            
                            Image(systemName: content.icon)
                                .font(.system(size: 40))
                                .foregroundStyle(colorScheme == .dark ? .blue : .indigo)
                        }
                        .padding(.top, 16)
                        
                        // Title and Subtitle Section
                        VStack(spacing: 8) {
                            Text(content.title)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(content.subtitle)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.bottom, 16)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }
                
                // Features Section
                Section("Features") {
                    ForEach(content.features, id: \.title) { feature in
                        InfoSheetRow(
                            symbol: feature.symbol,
                            title: feature.title,
                            description: feature.description
                        )
                    }
                }
                
                // Technologies Section
                Section("Technologies") {
                    ForEach(content.technologies, id: \.title) { tech in
                        InfoSheetRow(
                            symbol: tech.symbol,
                            title: tech.title,
                            description: tech.description
                        )
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
} 