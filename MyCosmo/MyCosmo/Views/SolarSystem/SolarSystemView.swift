import SwiftUI

struct SolarSystemView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Solar System")
            }
            .navigationTitle("Solar System")
        }
    }
}

#Preview {
    SolarSystemView()
}
