import SwiftUI
import SwiftData

struct WatchlistView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WatchlistItem.createdAt, order: .reverse) private var items: [WatchlistItem]

    @Binding var selection: WatchlistItem?
    let onAdd: () -> Void

    @State private var searchText: String = ""

    var filtered: [WatchlistItem] {
        guard !searchText.isEmpty else { return items }
        return items.filter {
            $0.displayName.localizedCaseInsensitiveContains(searchText) ||
            $0.tsCode.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        List(selection: $selection) {
            Section("公司") {
                ForEach(filtered) { item in
                    WatchlistRowView(item: item)
                        .tag(item)
                        .contextMenu {
                            Button(item.isRead ? "标为未读" : "标为已读") {
                                item.isRead.toggle()
                                try? modelContext.save()
                            }
                            Button("删除", role: .destructive) {
                                if selection?.persistentModelID == item.persistentModelID {
                                    selection = nil
                                }
                                modelContext.delete(item)
                                try? modelContext.save()
                            }
                        }
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("自选")
        .searchable(text: $searchText, placement: .sidebar)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: onAdd) {
                    Label("添加", systemImage: "plus")
                }
            }
        }
    }
}
