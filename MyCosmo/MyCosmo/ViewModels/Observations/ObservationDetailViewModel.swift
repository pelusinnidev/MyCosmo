import SwiftUI

@MainActor
class ObservationDetailViewModel: ObservableObject {
    let observation: UserObservation
    
    init(observation: UserObservation) {
        self.observation = observation
    }
    
    var formattedDate: String {
        observation.date.formatted(date: .abbreviated, time: .omitted)
    }
} 