import SwiftUI

struct InfoSheetContent {
    let icon: String
    let title: String
    let subtitle: String
    let features: [(symbol: String, title: String, description: String)]
    let technologies: [(symbol: String, title: String, description: String)]
}

struct InfoSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    let content: InfoSheetContent
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 16) {
                        // Icon Circle
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
                        
                        // Title and Subtitle
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
                
                Section("Features") {
                    ForEach(content.features, id: \.title) { feature in
                        InfoSheetRow(
                            symbol: feature.symbol,
                            title: feature.title,
                            description: feature.description
                        )
                    }
                }
                
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