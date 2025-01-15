import SwiftUI

struct FeaturesView: View {
    @Binding var selectedFeatureIndex: Int
    let action: () -> Void
    
    private let spacing: CGFloat = 24
    private let horizontalPadding: CGFloat = 24
    private let features = [
        OnboardingFeature(
            title: "Space News",
            description: "• Daily NASA's Astronomy Picture of the Day\n• Latest space discoveries and missions\n• Breaking news from space agencies\n• Detailed articles about astronomy",
            systemImage: "newspaper.fill",
            tint: .indigo
        ),
        OnboardingFeature(
            title: "Solar System",
            description: "• Explore all planets in our solar system\n• Learn about moons and their characteristics\n• Discover interesting facts and statistics\n• View beautiful space imagery",
            systemImage: "globe.europe.africa.fill",
            tint: .indigo
        ),
        OnboardingFeature(
            title: "Personal Log",
            description: "• Record your astronomical observations\n• Add photos of celestial objects\n• Track observation conditions\n• Note your discoveries and findings",
            systemImage: "binoculars.fill",
            tint: .indigo
        ),
        OnboardingFeature(
            title: "Your Experience",
            description: "• Choose between light and dark mode\n• Customize your app appearance\n• Set your preferred language\n• Personalize your experience",
            systemImage: "gearshape.fill",
            tint: .indigo
        )
    ]
    
    var body: some View {
        TabView(selection: $selectedFeatureIndex) {
            ForEach(Array(features.enumerated()), id: \.element.id) { index, feature in
                VStack(spacing: spacing) {
                    // Section indicator
                    Text("\(index + 1) of \(features.count)")
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .padding(.top, 20)
                    
                    Spacer()
                        .frame(height: 40)
                    
                    // Feature card with enhanced design
                    VStack(spacing: spacing) {
                        ZStack {
                            // Background effects
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.purple.opacity(0.2), .blue.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .blur(radius: 20)
                            
                            // Decorative rings
                            ForEach(0..<2) { ring in
                                Circle()
                                    .strokeBorder(
                                        LinearGradient(
                                            colors: [.purple.opacity(0.1), .blue.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                                    .frame(width: 140 + CGFloat(ring * 30),
                                           height: 140 + CGFloat(ring * 30))
                            }
                            
                            // Icon with gradient and animation
                            Image(systemName: feature.systemImage)
                                .font(.system(size: 60, weight: .light))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.purple, .blue],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .symbolEffect(.bounce, options: .repeating)
                        }
                        .frame(height: 160)
                        .frame(maxWidth: .infinity)
                        
                        VStack(spacing: 16) {
                            Text(feature.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color(.label))
                                .frame(height: 30)
                            
                            Text(feature.description)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                                .foregroundStyle(Color(.secondaryLabel))
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)
                        }
                        .padding(.horizontal, 32)
                    }
                    
                    Spacer()
                    
                    // Continue button
                    if index == features.count - 1 {
                        Button(action: action) {
                            Text("Continue")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(height: 54)
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
                        .padding(.bottom, 40)
                    }
                }
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .overlay(alignment: .bottom) {
            PageControl(numberOfPages: features.count,
                       currentPage: selectedFeatureIndex)
                .padding(.bottom, 100)
        }
    }
}

// Feature model
private struct OnboardingFeature: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let systemImage: String
    let tint: Color
} 