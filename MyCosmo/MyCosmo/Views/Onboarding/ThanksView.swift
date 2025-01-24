import SwiftUI

struct ThanksView: View {
    let completeOnboarding: () -> Void
    @State private var isAnimating = false
    @State private var showThankYou = false
    @State private var showCredits = false
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Animated Icon
            ZStack {
                ForEach(0..<3) { index in
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 2)
                        .frame(width: 120 + CGFloat(index * 40),
                               height: 120 + CGFloat(index * 40))
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0 : 1)
                        .animation(
                            .easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: false)
                            .delay(Double(index) * 0.2),
                            value: isAnimating
                        )
                }
                
                Image(systemName: "star.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.white)
                    .symbolEffect(.bounce, options: .repeating)
            }
            .padding(.bottom, 40)
            
            // Thank You Message
            VStack(spacing: 16) {
                Text("Thank You!")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(showThankYou ? 1 : 0)
                    .offset(y: showThankYou ? 0 : 20)
                
                Text("Get ready to explore the wonders\nof our universe")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .opacity(showThankYou ? 1 : 0)
                    .offset(y: showThankYou ? 0 : 20)
            }
            
            Spacer()
            
            // Credits
            VStack(spacing: 12) {
                Text("Powered by")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.6))
                
                HStack(spacing: 20) {
                    CreditsItem(text: "NASA", icon: "globe.americas.fill")
                    CreditsItem(text: "SpaceNews", icon: "newspaper.fill")
                    CreditsItem(text: "ESA", icon: "sparkles")
                }
            }
            .opacity(showCredits ? 1 : 0)
            .offset(y: showCredits ? 0 : 20)
            
            Spacer()
            
            // Start Button
            Button(action: completeOnboarding) {
                Text("Start Exploring")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .white.opacity(0.2), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 60)
        }
        .onAppear {
            withAnimation(.spring(duration: 0.8)) {
                isAnimating = true
            }
            withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                showThankYou = true
            }
            withAnimation(.easeOut(duration: 0.6).delay(0.6)) {
                showCredits = true
            }
        }
    }
}

struct CreditsItem: View {
    let text: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.white)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(width: 80)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
} 
