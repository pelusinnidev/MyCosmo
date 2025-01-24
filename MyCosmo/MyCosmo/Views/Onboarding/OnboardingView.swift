import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    
    private let pages = ["welcome", "features", "thanks"]
    private let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 13/255, green: 15/255, blue: 44/255),
            Color(red: 26/255, green: 30/255, blue: 88/255)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                backgroundGradient
                    .ignoresSafeArea()
                
                // Stars effect
                StarsView()
                    .ignoresSafeArea()
                
                TabView(selection: $currentPage) {
                    // Welcome Page
                    WelcomeView(nextPage: { withAnimation { currentPage = 1 }})
                        .tag(0)
                    
                    // Features Page
                    FeaturesView(nextPage: { withAnimation { currentPage = 2 }})
                        .tag(1)
                    
                    // Thanks Page
                    ThanksView(completeOnboarding: {
                        withAnimation {
                            hasCompletedOnboarding = true
                        }
                    })
                    .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(), value: currentPage)
                
                // Custom Page Indicator
                VStack {
                    Spacer()
                    PageIndicator(totalPages: pages.count, currentPage: currentPage)
                        .padding(.bottom, 40)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct StarsView: View {
    let starCount = 100
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<starCount, id: \.self) { _ in
                Circle()
                    .fill(.white)
                    .frame(width: CGFloat.random(in: 1...3))
                    .position(
                        x: CGFloat.random(in: 0...geometry.size.width),
                        y: CGFloat.random(in: 0...geometry.size.height)
                    )
                    .opacity(Double.random(in: 0.2...0.8))
            }
        }
    }
}

struct PageIndicator: View {
    let totalPages: Int
    let currentPage: Int
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<totalPages, id: \.self) { page in
                Circle()
                    .fill(currentPage == page ? Color.white : Color.white.opacity(0.5))
                    .frame(width: 8, height: 8)
                    .scaleEffect(currentPage == page ? 1.2 : 1.0)
                    .animation(.spring(), value: currentPage)
            }
        }
    }
} 
