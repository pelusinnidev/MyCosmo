import SwiftUI

struct ThanksView: View {
    let action: () -> Void
    private let horizontalPadding: CGFloat = 24
    private let spacing: CGFloat = 24
    
    var body: some View {
        VStack(spacing: spacing) {
            // Section indicator
            Text("Final Step")
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .padding(.top, 20)
            
            Spacer()
                .frame(height: 20)
            
            // Success animation
            ZStack {
                Circle()
                    .fill(.green.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [.green.opacity(0.5), .green.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.green, .green.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .symbolEffect(.bounce)
            }
            .padding(.bottom, 20)
            
            VStack(spacing: 12) {
                Text("You're All Set!")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.green, .green.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                Text("Ready to explore the cosmos")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            
            // APIs Section
            VStack(spacing: 24) {
                Text("Powered by")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.top, 32)
                
                VStack(spacing: 16) {
                    APICard(
                        title: "NASA APOD",
                        description: "Astronomy Picture of the Day",
                        icon: "photo.fill"
                    )
                    
                    APICard(
                        title: "Space News API",
                        description: "Latest space articles and updates",
                        icon: "newspaper.fill"
                    )
                }
            }
            .padding(.horizontal, horizontalPadding)
            
            Spacer()
            
            // Team Credits
            VStack(spacing: 16) {
                Text("Created by")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                HStack(spacing: 20) {
                    Text("Pol Hernàndez")
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                    
                    Text("•")
                        .foregroundStyle(.secondary)
                    
                    Text("Adrià Sanchez")
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                }
                
                Text("La Salle Gràcia - DAM2")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 32)
            
            Button(action: action) {
                Text("Begin Exploration")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            colors: [.green, .green.opacity(0.8)],
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

// API Card component
private struct APICard: View {
    let title: String
    let description: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundStyle(.green.gradient)
                        .symbolEffect(.pulse)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
} 
