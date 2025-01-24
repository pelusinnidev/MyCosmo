import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 13/255, green: 15/255, blue: 44/255),
                    Color(red: 26/255, green: 30/255, blue: 88/255)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Content
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
