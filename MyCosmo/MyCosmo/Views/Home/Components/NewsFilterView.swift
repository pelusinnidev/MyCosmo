import SwiftUI

struct NewsFilterView: View {
    @Binding var selectedFilter: NewsFilter
    
    var body: some View {
        HStack {
            Spacer()
            HStack(spacing: 8) {
                ForEach(NewsFilter.allCases, id: \.self) { filter in
                    FilterPill(
                        filter: filter,
                        isSelected: filter == selectedFilter
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3)) {
                            selectedFilter = filter
                        }
                    }
                }
            }
            Spacer()
        }
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
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .foregroundColor(isSelected ? .white : filter.color)
        .background(
            Capsule()
                .fill(isSelected ? filter.color : filter.color.opacity(0.15))
        )
    }
} 