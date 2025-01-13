import SwiftUI
import SwiftData

@MainActor
class ObservationsViewModel: ObservableObject {
    @Published var showingAddSheet = false
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func deleteObservation(_ observation: UserObservation) {
        modelContext.delete(observation)
    }
    
    func deleteObservations(at offsets: IndexSet, from observations: [UserObservation]) {
        for index in offsets {
            modelContext.delete(observations[index])
        }
    }
} 