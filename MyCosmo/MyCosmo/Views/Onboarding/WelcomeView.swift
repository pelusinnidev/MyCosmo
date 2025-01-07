import SwiftUI

struct WelcomeView: View {
    let action: () -> Void
    private let horizontalPadding: CGFloat = 24
    private let spacing: CGFloat = 24
    
    var body: some View {
        VStack(spacing: spacing) {
            Spacer()
            
            // App Icon
            Image("AppIconResource")
                .resizable()
                .frame(width: 180, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 45))
                .shadow(color: .purple.opacity(0.3), radius: 20, x: 0, y: 10)
            
            VStack(spacing: 12) {
                Text("MyCosmo")
                    .font(.system(size: 44, weight: .bold))
                    .foregroundStyle(.linearGradient(colors: [.white, .white.opacity(0.7)], startPoint: .top, endPoint: .bottom))
                
                Text("Be your Universe")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 32)
            
            // Tab icons
            HStack(spacing: 20) {
                ForEach([
                    "globe.europe.africa.fill",
                    "sun.and.horizon.fill",
                    "binoculars.fill",
                    "gearshape.fill"
                ], id: \.self) { iconName in
                    Image(systemName: iconName)
                        .font(.title2)
                        .foregroundStyle(.white.opacity(0.7))
                        .symbolEffect(.pulse)
                }
            }
            .padding(.top, 24)
            
            Spacer()
            
            Button(action: action) {
                Text("Discover Features")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(.purple.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.bottom, 20)
        }
    }
} 
