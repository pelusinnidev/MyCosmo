import SwiftUI

/// Main container view for the app's onboarding experience
/// Manages the flow between different onboarding pages using a custom background
/// and smooth transitions
struct OnboardingView: View {
    /// Binding to track whether onboarding has been completed
    @Binding var hasCompletedOnboarding: Bool
    /// Current page index in the onboarding flow
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            // Background gradient for the entire onboarding experience
            LinearGradient(
                colors: [
                    Color(red: 13/255, green: 15/255, blue: 44/255),
                    Color(red: 26/255, green: 30/255, blue: 88/255)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Page content with transitions
            Group {
                switch currentPage {
                case 0:
                    WelcomeView(nextPage: { currentPage = 1 })
                case 1:
                    FeaturesView(nextPage: { currentPage = 2 })
                case 2:
                    ThanksView(completeOnboarding: {
                        withAnimation {
                            hasCompletedOnboarding = true
                        }
                    })
                default:
                    EmptyView()
                }
            }
            .transition(.opacity)
        }
        .preferredColorScheme(.dark)
    }
} 
