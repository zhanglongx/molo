import SwiftUI

struct WatchlistRowView: View {
    let item: WatchlistItem

    var body: some View {
        HStack(spacing: 10) {
            if !item.isRead {
                Circle()
                    .frame(width: 8, height: 8)
                    .accessibilityLabel("未读")
            } else {
                Circle()
                    .fill(.clear)
                    .frame(width: 8, height: 8)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(item.displayName)
                    .font(.body.weight(.medium))
                Text(item.tsCode)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
