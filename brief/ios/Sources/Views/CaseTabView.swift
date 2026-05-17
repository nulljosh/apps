import SwiftUI

struct CaseTabView: View {
    @Environment(Store.self) private var store
    @State private var expandedGround: String? = nil

    var facts:     [CaseFact]  { store.activeCase == .rcmp ? caseFacts      : familyCaseFacts }
    var witnesses: [Witness]   { store.activeCase == .rcmp ? caseWitnesses  : familyCaseWitnesses }
    var grounds:   [Ground]    { store.activeCase == .rcmp ? caseGrounds    : familyCaseGrounds }

    var settlementLabel: String { store.activeCase == .rcmp ? "$1,000,000"          : "$300k–$600k" }
    var settlementRange: String { store.activeCase == .rcmp ? "$800k–$1.5M full leverage · $2–3M trial ceiling" : "$300k–600k most likely · $1.5–2M trial ceiling" }
    var navTitle:        String { store.activeCase == .rcmp ? "Trommel v. AG Canada" : "Trommel v. Trommel" }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    LimitationBannerView()

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Likely settlement")
                            .font(.system(size: 10, weight: .bold))
                            .tracking(1.2)
                            .textCase(.uppercase)
                            .foregroundStyle(.secondary)
                        Text(settlementLabel)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                        Text(settlementRange)
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))

                    section("Facts") {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                            ForEach(facts) { fact in
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

                    if !witnesses.isEmpty {
                        section("Witnesses") {
                            ForEach(witnesses) { witness in
                                WitnessCardView(witness: witness)
                            }
                        }
                    }

                    section("Legal grounds", hint: "tap to expand") {
                        VStack(spacing: 6) {
                            ForEach(grounds) { ground in
                                GroundRowView(ground: ground, expandedId: $expandedGround)
                            }
                        }
                    }

                    section("Pain journal") {
                        JournalView()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
            .navigationTitle(navTitle)
            .navigationBarTitleDisplayMode(.large)
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
}
