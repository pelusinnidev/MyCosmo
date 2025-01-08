import SwiftUI

struct NewsFilterView: View {
    @Binding var selectedFilter: NewsFilter
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 8) {
                ForEach(NewsFilter.allCases, id: \.self) { filter in
                    FilterPill(
                        filter: filter,
                        isSelected: filter == selectedFilter
                    )
                    .frame(width: (geometry.size.width - (CGFloat(NewsFilter.allCases.count - 1) * 8) - 32) / CGFloat(NewsFilter.allCases.count))
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3)) {
                            selectedFilter = filter
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
        }
        .frame(height: 36)
    }
}

private struct FilterPill: View {
    let filter: NewsFilter
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: filter.icon)
                .font(.system(size: 12))
            Text(filter.rawValue)
                .font(.footnote)
                .fontWeight(isSelected ? .semibold : .regular)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity)
        .foregroundColor(isSelected ? .white : filter.color)
        .background(
            Capsule()
                .fill(isSelected ? filter.color : filter.color.opacity(0.15))
        )
    }
} 