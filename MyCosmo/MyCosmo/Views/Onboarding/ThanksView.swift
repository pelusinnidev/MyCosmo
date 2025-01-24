import SwiftUI

struct ThanksView: View {
    let completeOnboarding: () -> Void
    @State private var isAnimated = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Star Icon
            Image(systemName: "star.fill")
                .font(.system(size: 80))
                .foregroundStyle(.white)
                .opacity(isAnimated ? 1 : 0)
                .scaleEffect(isAnimated ? 1 : 0.5)
            
            // Thank You Message
            VStack(spacing: 16) {
                Text("Thank You!")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Get ready to explore the wonders of our universe")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .opacity(isAnimated ? 1 : 0)
            .offset(y: isAnimated ? 0 : 20)
            
            Spacer()
            
            // API Credits
            VStack(spacing: 8) {
                Text("Powered by")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.6))
                
                HStack(spacing: 16) {
                    Text("NASA APOD API")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                    
                    Text("NewsAPI")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding(.bottom, 32)
            .opacity(isAnimated ? 1 : 0)
            
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
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 24)
            .opacity(isAnimated ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(duration: 0.8)) {
                isAnimated = true
            }
        }
    }
} 
