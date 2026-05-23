import SwiftUI

struct TabBarView: View {
    @Bindable var appState: AppState

    var body: some View {
        HStack(spacing: 8) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    // Pinned tabs (compact)
                    ForEach(appState.pinnedTabs) { tab in
                        pinnedTabButton(for: tab)
                    }

                    if !appState.pinnedTabs.isEmpty && !appState.unpinnedTabs.isEmpty {
                        Divider()
                            .frame(height: 20)
                    }

                    // Regular tabs
                    ForEach(appState.unpinnedTabs) { tab in
                        tabButton(for: tab)
                            .onDrag {
                                NSItemProvider(object: tab.id.uuidString as NSString)
                            }
                            .onDrop(of: [.text], delegate: TabDropDelegate(
                                tabID: tab.id,
                                appState: appState
                            ))
                    }
                }
            }

            Button {
                appState.addTab()
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 12, weight: .semibold))
                    .frame(width: 28, height: 24)
            }
            .buttonStyle(.borderless)
            .help("New Tab")
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(.quaternary.opacity(0.35))
    }

    // MARK: - Pinned Tab (compact)

    private func pinnedTabButton(for tab: Tab) -> some View {
        let isActive = appState.selectedTabID == tab.id

        return ZStack {
            if let favicon = tab.favicon {
                Image(nsImage: favicon)
                    .resizable()
                    .frame(width: 16, height: 16)
            } else {
                Image(systemName: "globe")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }

            if tab.isPlayingAudio {
                Image(systemName: tab.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                    .font(.system(size: 8))
                    .foregroundStyle(.blue)
                    .offset(x: 10, y: -10)
            }
        }
        .frame(width: 32, height: 28)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(isActive ? Color.accentColor.opacity(0.2) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(isActive ? Color.accentColor.opacity(0.4) : Color.gray.opacity(0.2), lineWidth: 1)
        )
        .contentShape(RoundedRectangle(cornerRadius: 6))
        .onTapGesture {
            appState.selectTab(id: tab.id)
        }
        .contextMenu {
            Button("Unpin Tab") { appState.unpinTab(id: tab.id) }
            if tab.isPlayingAudio {
                Button(tab.isMuted ? "Unmute Tab" : "Mute Tab") { appState.toggleMuteTab(id: tab.id) }
            }
            Divider()
            Button("Close Tab") { appState.closeTab(id: tab.id) }
        }
        .help(tab.title)
    }

    // MARK: - Regular Tab

    private func tabButton(for tab: Tab) -> some View {
        let isActive = appState.selectedTabID == tab.id

        return HStack(spacing: 6) {
            if let favicon = tab.favicon {
                Image(nsImage: favicon)
                    .resizable()
                    .frame(width: 14, height: 14)
            } else {
                Image(systemName: tab.isLoading ? "arrow.triangle.2.circlepath" : "globe")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }

            Text(tab.title.isEmpty ? tab.url.host ?? "New Tab" : tab.title)
                .font(.system(size: 12))
                .lineLimit(1)

            Spacer(minLength: 0)

            if tab.isPlayingAudio {
                Button {
                    appState.toggleMuteTab(id: tab.id)
                } label: {
                    Image(systemName: tab.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .help(tab.isMuted ? "Unmute" : "Mute")
            }

            if tab.isSuspended {
                Image(systemName: "moon.zzz")
                    .font(.system(size: 10))
                    .foregroundStyle(.tertiary)
            }

            Button {
                appState.closeTab(id: tab.id)
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .bold))
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
            .help("Close Tab")
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .frame(maxWidth: 220)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isActive ? Color.accentColor.opacity(0.2) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isActive ? Color.accentColor.opacity(0.4) : Color.gray.opacity(0.2), lineWidth: 1)
        )
        .contentShape(RoundedRectangle(cornerRadius: 8))
        .onTapGesture {
            appState.selectTab(id: tab.id)
        }
        .contextMenu {
            Button("Pin Tab") { appState.pinTab(id: tab.id) }
            Button("Duplicate Tab") { appState.addTab(url: tab.url) }
            if tab.isPlayingAudio {
                Button(tab.isMuted ? "Unmute Tab" : "Mute Tab") { appState.toggleMuteTab(id: tab.id) }
            }
            Divider()
            Button("Close Tab") { appState.closeTab(id: tab.id) }
            Button("Close Other Tabs") {
                let otherIDs = appState.tabs.filter { $0.id != tab.id }.map(\.id)
                for id in otherIDs { appState.closeTab(id: id) }
            }
        }
    }
}

// MARK: - Drag & Drop

struct TabDropDelegate: DropDelegate {
    let tabID: UUID
    let appState: AppState

    func performDrop(info: DropInfo) -> Bool {
        guard let item = info.itemProviders(for: [.text]).first else { return false }
        item.loadObject(ofClass: NSString.self) { string, _ in
            guard let uuidString = string as? String,
                  let sourceID = UUID(uuidString: uuidString) else { return }

            DispatchQueue.main.async {
                guard let sourceIndex = appState.tabs.firstIndex(where: { $0.id == sourceID }),
                      let destIndex = appState.tabs.firstIndex(where: { $0.id == tabID }) else { return }
                appState.moveTab(from: sourceIndex, to: destIndex)
            }
        }
        return true
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }

    func validateDrop(info: DropInfo) -> Bool {
        info.hasItemsConforming(to: [.text])
    }
}
