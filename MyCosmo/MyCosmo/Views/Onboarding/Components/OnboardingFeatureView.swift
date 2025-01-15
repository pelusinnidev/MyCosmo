import SwiftUI

struct OnboardingFeatureView: View {
    let title: String
    let subtitle: String
    let description: String
    let systemImage: String
    let tint: Color
    let buttonTitle: String
    let action: () -> Void
    
    private let horizontalPadding: CGFloat = 24
    private let spacing: CGFloat = 24
    
    var body: some View {
        VStack(spacing: spacing) {
            // Section indicator
            Text("\(title)")
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .padding(.top, 20)
            
            Spacer()
                .frame(height: 20)
            
            // Feature card with enhanced design
            VStack(spacing: spacing) {
                ZStack {
                    // Background effects
                    Circle()
                        .fill(tint.opacity(0.1))
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [tint.opacity(0.5), tint.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: systemImage)
                        .font(.system(size: 60))
                        .foregroundStyle(tint)
                        .symbolEffect(.bounce)
                }
                .padding(.bottom, 20)
                
                VStack(spacing: 12) {
                    Text(subtitle)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text(description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Action button
            Button(action: action) {
                Text(buttonTitle)
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            colors: [tint, tint.opacity(0.8)],
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