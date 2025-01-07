import SwiftUI

struct EventsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("EventsView")
            }
            .navigationTitle("Events")
        }
    }
}

#Preview {
    EventsView()
}
