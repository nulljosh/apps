import SwiftUI

struct CaseTabView: View {
    @Environment(Store.self) private var store
    @State private var expandedGround: String? = "force"

    private var rcmp: Bool { store.activeCase == .rcmp }
    private var facts:     [CaseFact] {
        switch store.activeCase { case .rcmp: return caseFacts; case .family: return familyCaseFacts; case .muni: return muniCaseFacts }
    }
    private var witnesses: [Witness] {
        switch store.activeCase { case .rcmp: return caseWitnesses; case .family: return familyCaseWitnesses; case .muni: return muniCaseWitnesses }
    }
    private var grounds:   [Ground] {
        switch store.activeCase { case .rcmp: return caseGrounds; case .family: return familyCaseGrounds; case .muni: return muniCaseGrounds }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                LimitationBannerView()
                ValueBeltView()

                if store.activeCase == .muni {
                    NoticeCardView()
                }

                section("Facts", roman: "§1") {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        ForEach(facts) { fact in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(fact.key)
                                    .font(.system(size: 9, weight: .bold)).tracking(1)
                                    .textCase(.uppercase).foregroundStyle(.secondary)
                                Text(fact.value)
                                    .font(.system(size: 13, weight: .semibold))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .gridCellColumns(fact.fullWidth ? 3 : 1)
                        }
                    }
                    .padding(18)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                }

                if !witnesses.isEmpty {
                    section("Witnesses", roman: "§2") {
                        ForEach(witnesses) { WitnessCardView(witness: $0) }
                    }
                }

                section("Legal grounds", roman: "§3", hint: "click to expand") {
                    VStack(spacing: 6) {
                        ForEach(grounds) { GroundRowView(ground: $0, expandedId: $expandedGround) }
                    }
                }

                if rcmp {
                    section("Pain journal", roman: "§4") { JournalView() }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .navigationTitle(store.activeCase.title)
    }

    @ViewBuilder
    private func section<C: View>(_ label: String, roman: String? = nil, hint: String? = nil, @ViewBuilder content: () -> C) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                if let roman { Text(roman).font(.system(size: 11, weight: .medium, design: .monospaced)).foregroundStyle(Color.briefDanger) }
                Text(label).font(.system(size: 10, weight: .bold)).tracking(1.4).textCase(.uppercase).foregroundStyle(.secondary)
                if let hint { Spacer(); Text(hint).font(.system(size: 10, design: .monospaced)).foregroundStyle(.tertiary) }
            }
            .padding(.horizontal, 4)
            content()
        }
    }
}
