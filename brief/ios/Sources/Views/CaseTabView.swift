import SwiftUI

struct CaseTabView: View {
    @Environment(Store.self) private var store
    @State private var expandedGround: String? = "force"

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    LimitationBannerView()

                    // Settlement stat
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Likely settlement")
                            .font(.system(size: 10, weight: .bold))
                            .tracking(1.2)
                            .textCase(.uppercase)
                            .foregroundStyle(.secondary)
                        Text("$1,000,000")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        Text("$800k–$1.5M with full leverage · $2–3M trial ceiling")
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))

                    // Facts
                    section("Facts") {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                            ForEach(caseFacts) { fact in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(fact.key)
                                        .font(.system(size: 9, weight: .bold))
                                        .tracking(1)
                                        .textCase(.uppercase)
                                        .foregroundStyle(.secondary)
                                    Text(fact.value)
                                        .font(.system(size: 13, weight: .semibold))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .gridCellColumns(fact.fullWidth ? 2 : 1)
                            }
                        }
                        .padding(18)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                    }

                    // Witnesses
                    section("Witnesses") {
                        ForEach(caseWitnesses) { witness in
                            WitnessCardView(witness: witness)
                        }
                    }

                    // Grounds
                    section("Legal grounds", hint: "tap to expand") {
                        VStack(spacing: 6) {
                            ForEach(caseGrounds) { ground in
                                GroundRowView(ground: ground, expandedId: $expandedGround)
                            }
                        }
                    }

                    // Journal
                    section("Pain journal") {
                        JournalView()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
            .navigationTitle("Trommel v. AG Canada")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    themeToggle
                }
            }
        }
    }

    @ViewBuilder
    private func section<Content: View>(_ label: String, hint: String? = nil, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text(label)
                    .font(.system(size: 10, weight: .bold))
                    .tracking(1.4)
                    .textCase(.uppercase)
                    .foregroundStyle(.secondary)
                if let hint {
                    Spacer()
                    Text(hint)
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(.horizontal, 4)
            content()
        }
    }

    @ViewBuilder
    private var themeToggle: some View {
        Button {
            store.theme = store.theme == "dark" ? "light" : store.theme == "light" ? "auto" : "dark"
        } label: {
            Image(systemName: store.theme == "dark" ? "sun.max" : store.theme == "light" ? "circle.lefthalf.filled" : "moon")
        }
    }
}
