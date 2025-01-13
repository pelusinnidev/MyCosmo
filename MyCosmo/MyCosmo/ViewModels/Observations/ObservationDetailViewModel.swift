import SwiftUI
import SwiftData

@MainActor
class ObservationDetailViewModel: ObservableObject {
    let observation: UserObservation
    @Published var showDeleteAlert = false
    @Published var shouldDismiss = false
    private let modelContext: ModelContext
    
    init(observation: UserObservation) {
        self.observation = observation
        self.modelContext = observation.modelContext!
    }
    
    var formattedDate: String {
        observation.date.formatted(date: .abbreviated, time: .omitted)
    }
    
    func deleteObservation() {
        modelContext.delete(observation)
        shouldDismiss = true
    }
} 