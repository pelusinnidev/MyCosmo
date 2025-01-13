import SwiftUI

struct ObservationDetailView: View {
    @StateObject private var viewModel: ObservationDetailViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State private var selectedImageIndex = 0
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(observation: UserObservation) {
        _viewModel = StateObject(wrappedValue: ObservationDetailViewModel(observation: observation))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Images Section with Paging
                TabView(selection: $selectedImageIndex) {
                    // Main Image
                    ImageCard(image: viewModel.observation.displayImage)
                        .tag(0)
                    
                    // Additional Images
                    if let additionalImages = viewModel.observation.additionalImages {
                        ForEach(Array(additionalImages.enumerated()), id: \.element) { index, imageData in
                            if let uiImage = UIImage(data: imageData) {
                                ImageCard(image: Image(uiImage: uiImage))
                                    .tag(index + 1)
                            }
                        }
                    }
                }
                .frame(height: 300)
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                VStack(alignment: .leading, spacing: 24) {
                    // Title Section
                    Text(viewModel.observation.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 16)
                    
                    // Tags Grid
                    LazyVGrid(columns: columns, spacing: 12) {
                        SpaceTag(icon: "globe", text: viewModel.observation.displayPlanet, color: .purple)
                            .frame(maxWidth: .infinity)
                        SpaceTag(icon: "tag", text: viewModel.observation.category.rawValue, color: .blue)
                            .frame(maxWidth: .infinity)
                        SpaceTag(icon: "star.fill", text: viewModel.observation.importance.rawValue, color: .orange)
                            .frame(maxWidth: .infinity)
                        SpaceTag(icon: "calendar", text: viewModel.formattedDate, color: .green)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 16)
                    
                    // Description Section
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Description", systemImage: "text.alignleft")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        Text(viewModel.observation.observationDescription)
                            .font(.body)
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(colorScheme == .dark ? .systemGray6 : .systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color(.systemFill), radius: 1)
                    .padding(.horizontal, 16)
                }
                .padding(.top, 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    viewModel.showDeleteAlert = true
                } label: {
                    Label("Delete", systemImage: "trash")
                        .foregroundStyle(.red)
                }
            }
        }
        .alert("Delete Observation", isPresented: $viewModel.showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                viewModel.deleteObservation()
            }
        } message: {
            Text("Are you sure you want to delete this observation? This action cannot be undone.")
        }
        .onChange(of: viewModel.shouldDismiss) { _, newValue in
            if newValue {
                dismiss()
            }
        }
    }
}

struct ImageCard: View {
    let image: Image
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        image
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .clipped()
            .overlay(alignment: .bottom) {
                LinearGradient(
                    colors: [
                        .clear,
                        Color.black.opacity(colorScheme == .dark ? 0.7 : 0.4)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 100)
            }
            .contentShape(Rectangle())
            .background(Color(.systemBackground))
    }
}

struct SpaceTag: View {
    let icon: String
    let text: String
    let color: Color
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Label {
            Text(text)
                .lineLimit(1)
        } icon: {
            Image(systemName: icon)
        }
        .font(.subheadline)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(colorScheme == .dark ? 0.2 : 0.1))
        .foregroundColor(color)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack {
        ObservationDetailView(observation: UserObservation(
            title: "Sample Observation",
            description: "A test observation of Mars with a longer description that spans multiple lines to show how the text wraps and flows within the container.",
            selectedPlanet: .mars,
            category: .astronomical,
            importance: .high
        ))
    }
} 
