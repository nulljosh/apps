import SwiftUI

struct SidebarView: View {
    @Binding var selection: SidebarItem

    var body: some View {
        List(SidebarItem.allCases, selection: $selection) { item in
            Label(item.rawValue, systemImage: item.icon)
                .font(QuestTheme.statsFont)
                .foregroundStyle(selection == item ? QuestTheme.gold : QuestTheme.parchmentDark)
        }
        .listStyle(.sidebar)
        .background(QuestTheme.leather)
        .scrollContentBackground(.hidden)
    }
}
