//
//  MyCosmoApp.swift
//  MyCosmo
//

import SwiftUI
import SwiftData

@main
struct MyCosmoApp: App {
    let container: ModelContainer
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    init() {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: false)
            container = try ModelContainer(for: UserObservation.self, configurations: config)
        } catch {
            fatalError("Could not configure container")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if !hasCompletedOnboarding {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            } else {
                MainTabView()
            }
        }
        .modelContainer(container)
    }
}
