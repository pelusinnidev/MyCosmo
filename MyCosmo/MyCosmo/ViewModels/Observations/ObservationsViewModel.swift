import SwiftUI
import SwiftData

/// ViewModel responsible for managing user's astronomical observations
/// Handles the list of observations and their deletion
@MainActor
class ObservationsViewModel: ObservableObject {
    /// Controls the visibility of the add observation sheet
    @Published var showingAddSheet = false
    /// SwiftData context for persistence operations
    let modelContext: ModelContext
    
    /// Initializes the ViewModel with a SwiftData context
    /// - Parameter modelContext: The context for managing persistent data
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    /// Deletes a single observation
    /// - Parameter observation: The observation to delete
    func deleteObservation(_ observation: UserObservation) {
        modelContext.delete(observation)
    }
    
    /// Deletes multiple observations at specified indices
    /// - Parameters:
    ///   - offsets: The indices of observations to delete
    ///   - observations: The array of observations to delete from
    func deleteObservations(at offsets: IndexSet, from observations: [UserObservation]) {
        for index in offsets {
            modelContext.delete(observations[index])
        }
    }
} 