import SwiftUI

struct ObservationDetailView: View {
    @StateObject private var viewModel: ObservationDetailViewModel
    
    init(observation: UserObservation) {
        _viewModel = StateObject(wrappedValue: ObservationDetailViewModel(observation: observation))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                viewModel.observation.displayImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 5)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(viewModel.observation.title)
                        .font(.title)
                        .bold()
                    
                    HStack {
                        Label(viewModel.observation.displayPlanet, systemImage: "globe")
                        Spacer()
                        Label(viewModel.observation.category.rawValue, systemImage: "tag")
                    }
                    .foregroundStyle(.secondary)
                    
                    Divider()
                    
                    Text(viewModel.observation.observationDescription)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack {
                        Label(viewModel.formattedDate,
                              systemImage: "calendar")
                        Spacer()
                        Label(viewModel.observation.importance.rawValue,
                              systemImage: "exclamationmark.circle")
                    }
                    .foregroundStyle(.secondary)
                    .padding(.top)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ObservationDetailView(observation: UserObservation(
            title: "Sample Observation",
            planet: "Mars",
            observationDescription: "A test observation",
            category: .planet,
            importance: .high,
            date: Date()
        ))
    }
} 
