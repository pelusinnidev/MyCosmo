import SwiftUI

/// A reusable row component for displaying information with an icon
/// Used in InfoSheet to present features and technologies in a consistent format
/// Features:
/// - Leading SF Symbol icon
/// - Title and description in a vertical stack
/// - Consistent styling and spacing
struct InfoSheetRow: View {
    /// SF Symbol name for the row's icon
    let symbol: String
    /// Title text for the row
    let title: String
    /// Detailed description text
    let description: String
    
    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        } icon: {
            Image(systemName: symbol)
                .foregroundStyle(Color.accentColor)
                .font(.title3)
        }
        .padding(.vertical, 4)
    }
} 