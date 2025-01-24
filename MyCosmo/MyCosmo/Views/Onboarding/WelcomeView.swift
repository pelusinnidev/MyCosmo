import SwiftUI

struct WelcomeView: View {
    let nextPage: () -> Void
    @State private var isAnimated = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // App Icon
            Image("AppIconResource")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .opacity(isAnimated ? 1 : 0)
            
            // Title and Subtitle
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
            
            // Button
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
