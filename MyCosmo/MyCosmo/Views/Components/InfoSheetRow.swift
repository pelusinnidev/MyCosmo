import SwiftUI

struct InfoSheetRow: View {
    let symbol: String
    let title: String
    let description: String
    @Environment(\.colorScheme) private var colorScheme
    
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
                .foregroundStyle(colorScheme == .dark ? .blue : .indigo)
                .font(.title3)
        }
        .padding(.vertical, 4)
    }
} 