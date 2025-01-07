import SwiftUI

struct ObservationDetailView: View {
    let observation: UserObservation
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                observation.displayImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 5)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(observation.title)
                        .font(.title)
                        .bold()
                    
                    HStack {
                        Label(observation.displayPlanet, systemImage: "globe")
                        Spacer()
                        Label(observation.category.rawValue, systemImage: "tag")
                    }
                    .foregroundStyle(.secondary)
                    
                    Divider()
                    
                    Text(observation.observationDescription)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack {
                        Label(observation.date.formatted(date: .abbreviated, time: .shortened),
                              systemImage: "calendar")
                        Spacer()
                        Label(observation.importance.rawValue,
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
