import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage: OnboardingPage = .welcome
    @State private var selectedFeatureIndex = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                switch currentPage {
                case .welcome:
                    WelcomeView {
                        withAnimation {
                            currentPage = .features
                        }
                    }
                case .features:
                    FeaturesView(
                        selectedFeatureIndex: $selectedFeatureIndex
                    ) {
                        withAnimation {
                            currentPage = .thanks
                        }
                    }
                case .thanks:
                    ThanksView {
                        withAnimation {
                            hasCompletedOnboarding = true
                        }
                    }
                }
            }
        }
    }
} 
