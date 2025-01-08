import SwiftUI

struct PlanetPickerView: View {
    @Binding var selectedPlanet: PlanetFilter
    
    var body: some View {
        Picker("Select Planet", selection: $selectedPlanet) {
            ForEach(PlanetFilter.allCases, id: \.self) { planet in
                Text(planet.rawValue)
                    .tag(planet)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
} 