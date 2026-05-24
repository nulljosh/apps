import SwiftUI

struct CaseTabView: View {
    @Environment(Store.self) private var store
    @State private var expandedGround: String? = nil

    private var facts:     [CaseFact] {
        switch store.activeCase { case .rcmp: return caseFacts; case .family: return familyCaseFacts; case .muni: return muniCaseFacts }
    }
    private var witnesses: [Witness] {
        switch store.activeCase { case .rcmp: return caseWitnesses; case .family: return familyCaseWitnesses; case .muni: return muniCaseWitnesses }
    }
    private var grounds:   [Ground] {
        switch store.activeCase { case .rcmp: return caseGrounds; case .family: return familyCaseGrounds; case .muni: return muniCaseGrounds }
    }
    private var navTitle: String { store.activeCase.title }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Limitation / notice banner
                    LimitationBannerView()

                    // Value belt
                    ValueBeltView()

                    // Muni notice card
                    if store.activeCase == .muni {
                        NoticeCardView()
                    }

                    section("Facts", roman: "§1", hint: "cover sheet") {
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
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .gridCellColumns(fact.fullWidth ? 2 : 1)
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

                    section("Legal grounds", roman: "§3", hint: "tap to expand") {
                        VStack(spacing: 6) {
                            ForEach(grounds) { GroundRowView(ground: $0, expandedId: $expandedGround) }
                        }
                    }

                    if store.activeCase == .rcmp {
                        section("Pain journal", roman: "§4", hint: "supports continuity") {
                            JournalView()
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
            .navigationTitle(navTitle)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    casePicker
                }
            }
        }
    }

    private var casePicker: some View {
        Menu {
            ForEach(CaseID.allCases) { c in
                Button { store.activeCase = c } label: {
                    if store.activeCase == c { Label(c.title, systemImage: "checkmark") }
                    else { Text(c.title) }
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(store.activeCase.rawValue)
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                Image(systemName: "chevron.up.chevron.down").font(.system(size: 10))
            }
            .foregroundStyle(.secondary)
        }
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
