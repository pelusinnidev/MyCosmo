import SwiftUI

struct WelcomeView: View {
    let nextPage: () -> Void
    @State private var titleOpacity = 0.0
    @State private var subtitleOpacity = 0.0
    @State private var buttonOpacity = 0.0
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // App Icon
            Image(systemName: "sparkles.square.filled.on.square")
                .font(.system(size: 80))
                .foregroundStyle(.white)
                .symbolEffect(.bounce, options: .repeating)
            
            // Title
            VStack(spacing: 16) {
                Text("MyCosmo")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(titleOpacity)
                
                Text("Your Personal Gateway\nto the Universe")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .opacity(subtitleOpacity)
            }
            
            Spacer()
            
            // Start Button
            Button(action: nextPage) {
                Text("Begin Your Journey")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .white.opacity(0.2), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 40)
            .opacity(buttonOpacity)
        }
        .padding(.vertical, 60)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                titleOpacity = 1
            }
            withAnimation(.easeOut(duration: 0.8).delay(0.4)) {
                subtitleOpacity = 1
            }
            withAnimation(.easeOut(duration: 0.8).delay(0.6)) {
                buttonOpacity = 1
            }
        }
    }
}

// Feature Icon Component
struct FeatureIcon: View {
    let name: String
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 60, height: 60)
            
            Image(systemName: name)
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(color)
        }
    }
} 
