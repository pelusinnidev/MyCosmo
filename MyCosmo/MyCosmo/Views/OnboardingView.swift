import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage: OnboardingPage = .welcome
    @State private var selectedFeatureIndex = 0
    
    private let spacing: CGFloat = 24
    private let horizontalPadding: CGFloat = 24
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Gradient background
                LinearGradient(
                    colors: [.black, Color(hex: "1A1A1A")],
                    startPoint: .top,
                    endPoint: .bottom
                ).ignoresSafeArea()
                
                switch currentPage {
                case .welcome: welcomeView
                case .features: featuresView
                case .thanks: thanksView
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private var welcomeView: some View {
        VStack(spacing: spacing) {
            Spacer()
            
            // Hero animation
            ZStack {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(.purple.opacity(0.3))
                        .frame(width: 200 + CGFloat(index * 40))
                        .blur(radius: CGFloat(index * 5))
                        .animation(.easeInOut(duration: 2).repeatForever(), value: UUID())
                }
                
                Image(systemName: "sparkles.square.filled.on.square")
                    .font(.system(size: 80, weight: .light))
                    .foregroundStyle(.linearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .symbolEffect(.bounce, options: .repeating.speed(0.5))
            }
            .frame(height: 250)
            
            VStack(spacing: 12) {
                Text("MyCosmo")
                    .font(.system(size: 44, weight: .bold))
                    .foregroundStyle(.linearGradient(colors: [.white, .white.opacity(0.7)], startPoint: .top, endPoint: .bottom))
                
                Text("Be your Universe")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    currentPage = .features
                }
            }) {
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
    
    private var featuresView: some View {
        TabView(selection: $selectedFeatureIndex) {
            ForEach(Array(OnboardingItem.features.enumerated()), id: \.element.id) { index, item in
                VStack(spacing: spacing) {
                    Spacer()
                    
                    // Feature card
                    VStack(spacing: spacing) {
                        ZStack {
                            Circle()
                                .fill(item.tint.opacity(0.2))
                                .frame(width: 120, height: 120)
                                .blur(radius: 20)
                            
                            Image(systemName: item.systemImage)
                                .font(.system(size: 60, weight: .light))
                                .foregroundStyle(
                                    .linearGradient(
                                        colors: [item.tint, item.tint.opacity(0.7)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .symbolEffect(.bounce, options: .repeating.speed(0.5))
                        }
                        .frame(height: 160)
                        
                        VStack(spacing: 16) {
                            Text(item.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                            
                            Text(item.description)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.horizontal, 32)
                    }
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    if index == OnboardingItem.features.count - 1 {
                        Button(action: {
                            withAnimation {
                                currentPage = .thanks
                            }
                        }) {
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
    
    private var thanksView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "star.square.on.square.fill")
                .font(.system(size: 80))
                .foregroundStyle(.purple.gradient)
                .symbolEffect(.bounce, options: .repeating.speed(0.5))
            
            Text("Welcome to MyCosmo!")
                .font(.title)
                .bold()
            
            Text("We hope you enjoy your cosmic journey")
                .font(.title3)
                .foregroundStyle(.secondary)
            
            Text(OnboardingItem.credits)
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    hasCompletedOnboarding = true
                }
            }) {
                Text("Start Exploring")
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

// Custom PageControl para mejor control visual
struct PageControl: View {
    let numberOfPages: Int
    let currentPage: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<numberOfPages, id: \.self) { page in
                Circle()
                    .fill(page == currentPage ? .white : .white.opacity(0.3))
                    .frame(width: 8, height: 8)
                    .animation(.spring, value: currentPage)
            }
        }
    }
}

// Extensión para colores hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 
