import SwiftUI

struct AccountView: View {
    @EnvironmentObject var session: CompassSession
    @State private var showSignOutConfirm = false

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
                        LabeledContent("AutoLoad", value: info.autoLoadEnabled ? "Enabled" : "Disabled")
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
        .confirmationDialog("Sign out of your Compass account?", isPresented: $showSignOutConfirm, titleVisibility: .visible) {
            Button("Sign Out", role: .destructive) {
                Task { await session.signOut() }
            }
        }
    }
}
