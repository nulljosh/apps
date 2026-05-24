import SwiftUI

struct AccountView: View {
    @EnvironmentObject var session: BeepSession
    @State private var showSignOutConfirm = false
    @State private var showAutoLoad = false

    var body: some View {
        NavigationStack {
            List {
                Section("Card") {
                    if let num = session.cardInfo?.cardNumber, !num.isEmpty {
                        LabeledContent("Card Number") {
                            Text(num)
                                .font(.system(.body, design: .monospaced))
                                .foregroundStyle(.secondary)
                        }
                    }
                    LabeledContent("Balance", value: session.cardInfo?.balance ?? "--")
                    if let info = session.cardInfo {
                        Button { showAutoLoad = true } label: {
                            LabeledContent("AutoLoad") {
                                Text(info.autoLoadEnabled ? "Enabled" : "Disabled")
                                    .foregroundStyle(info.autoLoadEnabled ? .green : .secondary)
                            }
                        }
                        .foregroundStyle(.primary)
                    }
                }

                Section {
                    Button {
                        if let url = URL(string: "https://www.compasscard.ca/MyAccount") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Label("Open in Safari", systemImage: "safari")
                    }
                }

                Section {
                    Button(role: .destructive) {
                        showSignOutConfirm = true
                    } label: {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("Account")
        }
        .sheet(isPresented: $showAutoLoad, onDismiss: {
            Task { await session.loadDashboard() }
        }) {
            AutoLoadSheetView()
        }
        .confirmationDialog("Sign out of your Compass account?", isPresented: $showSignOutConfirm, titleVisibility: .visible) {
            Button("Sign Out", role: .destructive) {
                Task { await session.signOut() }
            }
        }
    }
}
