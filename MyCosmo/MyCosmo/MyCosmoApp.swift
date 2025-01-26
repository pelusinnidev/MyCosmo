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
    @AppStorage("appearanceMode") private var appearanceMode = 0 // 0: system, 1: light, 2: dark
    
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
                    .preferredColorScheme(colorScheme)
            } else {
                MainTabView()
                    .preferredColorScheme(colorScheme)
            }
        }   
        .modelContainer(container)
    }
    
    private var colorScheme: ColorScheme? {
        switch appearanceMode {
        case 1: return .light
        case 2: return .dark
        default: return nil
        }
    }
}
