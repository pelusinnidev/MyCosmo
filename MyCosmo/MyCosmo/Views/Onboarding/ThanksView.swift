import SwiftUI

struct ThanksView: View {
    let action: () -> Void
    private let horizontalPadding: CGFloat = 24
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Success animation
            ZStack {
                Circle()
                    .fill(.green.opacity(0.1))
                    .frame(width: 160, height: 160)
                    .blur(radius: 20)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.green.gradient)
                    .symbolEffect(.bounce)
            }
            
            VStack(spacing: 16) {
                Text("Welcome to MyCosmo!")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.primary)
                
                Text("We hope you enjoy your cosmic journey")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            
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
                        .foregroundStyle(.purple.gradient)
                        .symbolEffect(.pulse)
                }
            }
            .padding(.top, 32)
            
            VStack(spacing: 24) {
                Text("Ready to explore?")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                Text(OnboardingItem.credits)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 32)
            
            Spacer()
            
            Button(action: action) {
                HStack {
                    Text("Start Exploring")
                        .font(.headline)
                    Image(systemName: "arrow.right")
                }
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
