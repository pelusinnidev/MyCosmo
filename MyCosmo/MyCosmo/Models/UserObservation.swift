import SwiftUI
import SwiftData

@Model
final class UserObservation {
    @Attribute(.unique) var id: UUID
    @Attribute var title: String
    @Attribute var date: Date
    @Attribute var observationBody: String
    @Attribute var oberservationPlanet: String
    
    init(title: String = "", date: Date = .now, observationBody: String = "", oberservationPlanet: String = "") {
        self.id = UUID()
        self.title = title
        self.date = date
        self.observationBody = observationBody
        self.oberservationPlanet = oberservationPlanet
    }
}
