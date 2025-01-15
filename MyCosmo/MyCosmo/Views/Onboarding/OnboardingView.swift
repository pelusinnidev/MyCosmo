import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage: OnboardingPage = .welcome
    @State private var pageIndex = 0
    
    private let transition: AnyTransition = .asymmetric(
        insertion: .move(edge: .trailing).combined(with: .opacity),
        removal: .move(edge: .leading).combined(with: .opacity)
    )
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                TabView(selection: $pageIndex) {
                    // Welcome
                    WelcomeView {
                        withAnimation {
                            pageIndex = 1
                            currentPage = .features
                        }
                    }
                    .tag(0)
                    
                    // Features
                    Group {
                        // News
                        OnboardingFeatureView(
                            title: "Stay Updated",
                            subtitle: "Space News & Daily Astronomy",
                            description: "• Latest space news and discoveries\n• NASA's Astronomy Picture of the Day\n• Interactive news filtering\n• Rich media content",
                            systemImage: "newspaper.fill",
                            tint: .blue,
                            buttonTitle: "Next",
                            action: { withAnimation { pageIndex = 2 } }
                        )
                        .tag(1)
                        
                        // Solar System
                        OnboardingFeatureView(
                            title: "Explore Space",
                            subtitle: "Interactive Solar System",
                            description: "• Detailed planet information\n• Beautiful planetary imagery\n• Physical characteristics\n• Interesting facts",
                            systemImage: "globe.europe.africa.fill",
                            tint: .purple,
                            buttonTitle: "Next",
                            action: { withAnimation { pageIndex = 3 } }
                        )
                        .tag(2)
                        
                        // Observations
                        OnboardingFeatureView(
                            title: "Document",
                            subtitle: "Personal Observations",
                            description: "• Record astronomical observations\n• Add multiple photos\n• Organize by categories\n• Filter and search",
                            systemImage: "binoculars.fill",
                            tint: .indigo,
                            buttonTitle: "Next",
                            action: { withAnimation { 
                                pageIndex = 4
                                currentPage = .thanks
                            } }
                        )
                        .tag(3)
                    }
                    
                    // Get Started
                    ThanksView {
                        withAnimation {
                            hasCompletedOnboarding = true
                        }
                    }
                    .tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(), value: pageIndex)
                
                // Custom Page Control
                VStack {
                    Spacer()
                    if pageIndex < 4 {
                        PageControl(
                            numberOfPages: 4,
                            currentPage: pageIndex
                        )
                        .padding(.bottom, 40)
                    }
                }
            }
        }
    }
} 
