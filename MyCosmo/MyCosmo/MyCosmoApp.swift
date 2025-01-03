//
//  MyCosmoApp.swift
//  MyCosmo
//

import SwiftUI
import SwiftData

@main
struct MyCosmoApp: App {
    let container: ModelContainer
    
    init() {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: false)
            container = try ModelContainer(for:
                                            UserObservation.self,
                                            configurations: config)
        } catch {
            fatalError("Could not configure container")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(container)
    }
}
