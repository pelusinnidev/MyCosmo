import SwiftUI

/// First screen of the onboarding experience
/// Displays the app icon, name, and welcome message with animated entrance
struct WelcomeView: View {
    /// Closure to trigger navigation to the next page
    let nextPage: () -> Void
    /// Controls the animation state of view elements
    @State private var isAnimated = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // App icon with fade-in animation
            Image("AppIconResource")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .opacity(isAnimated ? 1 : 0)
            
            // App title and tagline with slide-up animation
            VStack(spacing: 16) {
                Text("MyCosmo")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Be your universe")
                    .font(.title2)
                    .italic()
                    .foregroundColor(.white.opacity(0.8))
            }
            .opacity(isAnimated ? 1 : 0)
            .offset(y: isAnimated ? 0 : 20)
            
            Spacer()
            
            // Continue button with fade-in animation
            Button(action: nextPage) {
                Text("Begin Your Journey")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.white)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 48)
            .opacity(isAnimated ? 1 : 0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                isAnimated = true
            }
        }
    }
} 
