import SwiftUI

struct FeaturesView: View {
    @Binding var selectedFeatureIndex: Int
    let action: () -> Void
    
    private let spacing: CGFloat = 24
    private let horizontalPadding: CGFloat = 24
    
    var body: some View {
        TabView(selection: $selectedFeatureIndex) {
            ForEach(Array(OnboardingItem.features.enumerated()), id: \.element.id) { index, item in
                VStack(spacing: spacing) {
                    // Section indicator
                    Text("Feature \(index + 1) of \(OnboardingItem.features.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    // Feature card with enhanced design
                    VStack(spacing: spacing) {
                        ZStack {
                            // Background effects
                            Circle()
                                .fill(item.tint.opacity(0.2))
                                .frame(width: 120, height: 120)
                                .blur(radius: 20)
                            
                            // Decorative rings
                            ForEach(0..<2) { ring in
                                Circle()
                                    .strokeBorder(item.tint.opacity(0.1), lineWidth: 1)
                                    .frame(width: 140 + CGFloat(ring * 30),
                                           height: 140 + CGFloat(ring * 30))
                            }
                            
                            Image(systemName: item.systemImage)
                                .font(.system(size: 60, weight: .light))
                                .foregroundStyle(.linearGradient(
                                    colors: [item.tint, item.tint.opacity(0.7)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ))
                                .symbolEffect(.bounce, options: .repeating.speed(0.5))
                        }
                        .frame(height: 160)
                        
                        VStack(spacing: 16) {
                            Text(item.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color(.label))
                            
                            Text(item.description)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color(.secondaryLabel))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.horizontal, 32)
                    }
                    
                    Spacer()
                    
                    if index == OnboardingItem.features.count - 1 {
                        Button(action: action) {
                            Text("Continue")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(item.tint.gradient)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .padding(.horizontal, horizontalPadding)
                        .padding(.bottom, 20)
                    }
                }
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .overlay(alignment: .bottom) {
            PageControl(numberOfPages: OnboardingItem.features.count,
                       currentPage: selectedFeatureIndex)
                .padding(.bottom, 100)
        }
    }
} 