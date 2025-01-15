import SwiftUI

struct WelcomeView: View {
    let action: () -> Void
    private let horizontalPadding: CGFloat = 24
    private let spacing: CGFloat = 24
    
    var body: some View {
        VStack(spacing: spacing) {
            // Section indicator
            Text("Welcome")
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .padding(.top, 20)
            
            Spacer()
                .frame(height: 20)
            
            // App Icon with enhanced effects
            ZStack {
                Circle()
                    .fill(.purple.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [.purple.opacity(0.5), .purple.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 120, height: 120)
                
                Image("AppIconResource")
                    .resizable()
                    .frame(width: 90, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .shadow(color: .purple.opacity(0.3), radius: 20, x: 0, y: 10)
            }
            .padding(.bottom, 20)
            
            VStack(spacing: 12) {
                Text("MyCosmo")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Be your Universe")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            
            // Feature preview
            HStack(spacing: 20) {
                ForEach([
                    "newspaper.fill",
                    "globe.europe.africa.fill",
                    "binoculars.fill",
                    "gearshape.fill"
                ], id: \.self) { iconName in
                    Image(systemName: iconName)
                        .font(.title2)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.purple, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .symbolEffect(.pulse)
                }
            }
            .padding(.top, 24)
            
            Spacer()
            
            // Description
            Text("Explore space news, track celestial observations, and discover our solar system in an interactive experience.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, horizontalPadding)
            
            Spacer()
                .frame(height: 32)
            
            Button(action: action) {
                Text("Start Journey")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.bottom, 100)
        }
    }
} 
