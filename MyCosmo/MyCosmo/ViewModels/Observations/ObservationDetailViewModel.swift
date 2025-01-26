import SwiftUI
import SwiftData

/// ViewModel responsible for managing the details of a single astronomical observation
/// Handles the display and deletion of observation details
@MainActor
class ObservationDetailViewModel: ObservableObject {
    /// The observation being displayed
    let observation: UserObservation
    /// Controls the visibility of the delete confirmation alert
    @Published var showDeleteAlert = false
    /// Indicates whether the detail view should be dismissed
    @Published var shouldDismiss = false
    /// SwiftData context for persistence operations
    private let modelContext: ModelContext
    
    /// Initializes the ViewModel with an observation
    /// - Parameter observation: The observation to display and manage
    init(observation: UserObservation) {
        self.observation = observation
        self.modelContext = observation.modelContext!
    }
    
    /// Formats the observation date for display
    var formattedDate: String {
        observation.date.formatted(date: .abbreviated, time: .omitted)
    }
    
    /// Deletes the current observation and triggers view dismissal
    func deleteObservation() {
        modelContext.delete(observation)
        shouldDismiss = true
    }
} 