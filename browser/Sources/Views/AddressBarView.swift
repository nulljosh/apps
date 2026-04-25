import AppKit
import SwiftUI

struct AddressBarView: View {
    @Bindable var appState: AppState
    @Binding var focusAddressBar: Bool
    @State private var addressText = ""
    @FocusState private var isAddressBarFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Button {
                    appState.goBack()
                } label: {
                    Image(systemName: "chevron.left")
                }
                .disabled(!(appState.selectedTab?.canGoBack ?? false))
                .help("Back")

                Button {
                    appState.goForward()
                } label: {
                    Image(systemName: "chevron.right")
                }
                .disabled(!(appState.selectedTab?.canGoForward ?? false))
                .help("Forward")

                Button {
                    if appState.selectedTab?.isLoading == true {
                        appState.stopLoading()
                    } else {
                        appState.reload()
                    }
                } label: {
                    Image(systemName: appState.selectedTab?.isLoading == true ? "xmark" : "arrow.clockwise")
                }
                .help(appState.selectedTab?.isLoading == true ? "Stop" : "Reload")

                // Address bar
                VStack(spacing: 0) {
                    HStack(spacing: 8) {
                        // Lock icon / HTTPS indicator
                        if let url = appState.selectedTab?.url {
                            if url.isHTTPS {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 11))
                                    .foregroundStyle(.green)
                                    .help("Secure connection (HTTPS)")
                            } else if url.isHTTP {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 11))
                                    .foregroundStyle(.orange)
                                    .help("Not secure (HTTP)")
                            } else {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(.secondary)
                            }
                        } else {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.secondary)
                        }

                        TextField("Search or enter website name", text: $addressText)
                            .textFieldStyle(.plain)
                            .focused($isAddressBarFocused)
                            .onSubmit {
                                appState.showAutocomplete = false
                                appState.navigateCurrent(input: addressText)
                            }
                            .onChange(of: addressText) { _, newValue in
                                if isAddressBarFocused {
                                    appState.updateAutocomplete(query: newValue)
                                }
                            }
                            .onAppear {
                                syncAddressBar()
                            }
                            .onChange(of: appState.selectedTabID) { _, _ in
                                syncAddressBar()
                            }
                            .onChange(of: appState.selectedTab?.url) { _, _ in
                                syncAddressBar()
                            }
                            .onChange(of: focusAddressBar) { _, newValue in
                                guard newValue else { return }
                                activateAddressBarFocus()
                                focusAddressBar = false
                            }

                        // Tracker count badge
                        if let tab = appState.selectedTab,
                           appState.preferences.contentBlockerEnabled {
                            let count = PrivacyManager.shared.trackerCount(for: tab.id)
                            if count > 0 {
                                HStack(spacing: 2) {
                                    Image(systemName: "shield.fill")
                                        .font(.system(size: 10))
                                    Text("\(count)")
                                        .font(.system(size: 10, weight: .medium))
                                }
                                .foregroundStyle(.blue)
                                .help("\(count) trackers blocked")
                            }
                        }

                        Button {
                            appState.toggleBookmark()
                        } label: {
                            Image(systemName: appState.isCurrentPageBookmarked ? "star.fill" : "star")
                                .foregroundStyle(appState.isCurrentPageBookmarked ? .yellow : .secondary)
                        }
                        .buttonStyle(.plain)
                        .help(appState.isCurrentPageBookmarked ? "Remove Bookmark" : "Add Bookmark")

                        if appState.selectedTab?.isLoading == true {
                            ProgressView()
                                .controlSize(.small)
                                .scaleEffect(0.75)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.background)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.25), lineWidth: 1)
                    )

                    // Autocomplete dropdown
                    if appState.showAutocomplete && !appState.autocompleteResults.isEmpty {
                        VStack(spacing: 0) {
                            ForEach(appState.autocompleteResults) { entry in
                                Button {
                                    addressText = entry.url.absoluteString
                                    appState.showAutocomplete = false
                                    appState.openInSelectedTab(entry.url)
                                } label: {
                                    HStack(spacing: 8) {
                                        Image(systemName: "magnifyingglass")
                                            .font(.system(size: 10))
                                            .foregroundStyle(.tertiary)
                                        VStack(alignment: .leading, spacing: 1) {
                                            Text(entry.title)
                                                .font(.system(size: 12))
                                                .lineLimit(1)
                                            Text(entry.url.absoluteString)
                                                .font(.system(size: 10))
                                                .foregroundStyle(.secondary)
                                                .lineLimit(1)
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)

                                if entry.id != appState.autocompleteResults.last?.id {
                                    Divider()
                                }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.background)
                                .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
                        )
                        .padding(.top, 2)
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, 8)
            .padding(.bottom, appState.selectedTab?.isLoading == true ? 6 : 8)

            if appState.selectedTab?.isLoading == true {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.blue.opacity(0.18))

                        Capsule()
                            .fill(Color.blue)
                            .frame(width: max(0, geometry.size.width * CGFloat(appState.loadingProgress)))
                    }
                }
                .frame(height: 2)
                .padding(.horizontal, 10)
                .padding(.bottom, 8)
                .animation(.linear, value: appState.loadingProgress)
            }
        }
        .background(.quaternary.opacity(0.15))
    }

    private func activateAddressBarFocus() {
        isAddressBarFocused = true
        DispatchQueue.main.async {
            NSApp.sendAction(#selector(NSText.selectAll(_:)), to: nil, from: nil)
        }
    }

    private func syncAddressBar() {
        guard let url = appState.selectedTab?.url else { return }
        addressText = url.displayString
        appState.showAutocomplete = false
    }
}
