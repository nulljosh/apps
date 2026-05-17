import SwiftUI

struct MoneyTabView: View {
    @Environment(Store.self) private var store
    @State private var barsVisible = false

    var scenarios:   [Scenario]    { store.activeCase == .rcmp ? caseScenarios  : familyCaseScenarios }
    var activeDamageHeads: [DamageHead] { store.activeCase == .rcmp ? damageHeads : familyDamageHeads }

    private var rcmp: Bool { store.activeCase == .rcmp }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {

                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(Array(scenarios.enumerated()), id: \.element.id) { idx, s in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(alignment: .firstTextBaseline) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(s.name).font(.system(size: 13, weight: .semibold))
                                        Text(s.description).font(.system(size: 12)).foregroundStyle(.secondary).lineSpacing(2)
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text(s.amount).font(.system(size: 14, weight: .bold)).foregroundStyle(s.accentColor)
                                        Text("\(Int(s.probability * 100))%").font(.system(size: 11, design: .monospaced)).foregroundStyle(.secondary)
                                    }
                                }
                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 2).fill(Color.secondary.opacity(0.15)).frame(height: 4)
                                        RoundedRectangle(cornerRadius: 2).fill(s.accentColor)
                                            .frame(width: barsVisible ? geo.size.width * s.probability : 0, height: 4)
                                            .animation(.easeOut(duration: 0.9).delay(Double(idx) * 0.12), value: barsVisible)
                                    }
                                }.frame(height: 4)
                            }
                            .padding(.vertical, 14)
                            if idx < scenarios.count - 1 { Divider() }
                        }
                        Text(rcmp
                             ? "8 stacked Charter/tort breaches · 21+ months documented PTSD · Unlawful dwelling entry (Feeney) · Forced antipsychotics (Fleming v. Ontario) · No underlying crime · Degen v. Min. Public Safety 2023 BCSC: $317k (floor) · $1M+ realistic median · $2–3M trial ceiling"
                             : "Appropriation of personality (ongoing tort — cleanest limitation) · IIMS pattern across 20+ years · Parents own $1M+ Langley home (judgment enforceable against title) · Private defendants — no AG silence premium — parents prefer privacy")
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .lineSpacing(3)
                            .padding(.top, 14)
                    }
                    .padding(18)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .onAppear { barsVisible = true }

                    SectionCard("Per-head damages stack") {
                        VStack(spacing: 0) {
                            HStack { Text("Head").frame(maxWidth:.infinity,alignment:.leading); Text("Range"); Text("Note").frame(width:100,alignment:.leading) }
                                .font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary).padding(.bottom,8)
                            ForEach(activeDamageHeads) { h in
                                HStack(alignment:.top) {
                                    Text(h.head).font(.system(size:11)).frame(maxWidth:.infinity,alignment:.leading).lineSpacing(2)
                                    Text(h.range).font(.system(size:11,weight:.semibold)).foregroundStyle(.briefWarn).frame(width:90,alignment:.trailing)
                                    Text(h.note).font(.system(size:10,design:.monospaced)).foregroundStyle(.secondary).frame(width:110,alignment:.leading)
                                }
                                .padding(.vertical,6)
                                Divider()
                            }
                            if rcmp {
                                HStack {
                                    Text("Conservative").font(.system(size:12,weight:.bold))
                                    Spacer()
                                    Text("$1.14M").font(.system(size:12,weight:.bold)).foregroundStyle(.briefWarn)
                                }.padding(.top,8)
                                HStack {
                                    Text("Strong").font(.system(size:12,weight:.bold))
                                    Spacer()
                                    Text("$2.25M").font(.system(size:12,weight:.bold)).foregroundStyle(.briefGreen)
                                }
                            } else {
                                HStack {
                                    Text("Conservative").font(.system(size:12,weight:.bold))
                                    Spacer()
                                    Text("$400k").font(.system(size:12,weight:.bold)).foregroundStyle(.briefWarn)
                                }.padding(.top,8)
                                HStack {
                                    Text("Strong").font(.system(size:12,weight:.bold))
                                    Spacer()
                                    Text("$1.15M").font(.system(size:12,weight:.bold)).foregroundStyle(.briefGreen)
                                }
                            }
                        }
                    }

                    if rcmp {
                        SectionCard("Comparable cases · Canada") {
                            VStack(spacing: 0) {
                                ForEach(caseComparables) { c in
                                    HStack(alignment: .top, spacing: 10) {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(c.label).font(.system(size: 11)).foregroundStyle(c.highlight ? Color.primary : Color.secondary)
                                            if let note = c.note {
                                                Text(note).font(.system(size: 9, design: .monospaced)).foregroundStyle(.secondary).lineSpacing(2)
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        Text(c.award).font(.system(size: 11, weight: .bold, design: .monospaced))
                                            .foregroundStyle(c.highlight ? Color.briefWarn : Color.secondary).multilineTextAlignment(.trailing)
                                    }
                                    .padding(.vertical, 8)
                                    Divider()
                                }
                            }
                        }

                        SectionCard("Ward framework") {
                            Text("Vancouver (City) v. Ward, 2010 SCC 27: Charter damages under s.24(1) serve three functions — compensation, vindication, and deterrence.\n\nThis fact pattern triggers all three maximally: no underlying crime, dwelling entry, forced medication, prolonged detention, documented PTSD.\n\nWhen all three Ward functions are engaged at maximum, courts assess damages globally rather than per-head (indivisible injury). Global assessment routinely exceeds the arithmetic sum of stacked heads.")
                                .font(.system(size:12)).foregroundStyle(.secondary).lineSpacing(4)
                        }

                        SectionCard("Silence premium") {
                            Text("The AG settles confidentially to suppress precedent, avoid press, kill discovery, and resolve before trial. Each press-capable lawyer contact, each documented evidence piece, each Charter ground formally pleaded increases the AG's internal cost of keeping this quiet.\n\nBaseline: Mona Wang v. AG Canada (2021) — BC RCMP wellness check, settled confidentially.\nThis case: Mona Wang + no underlying crime + dwelling entry + forced antipsychotic medication.")
                                .font(.system(size:12)).foregroundStyle(.secondary).lineSpacing(4)
                        }
                    } else {
                        SectionCard("Asset enforcement") {
                            Text("Unlike CASE-0001 (government defendant — deep pockets), this case is against private individuals. Enforcing a judgment matters.\n\nKnown assets: Primary residence ($1M+ Langley home). Family business (trucks, equipment, revenue). Defendants are ~60, retired.\n\nA judgment can be registered against the home title under the BC Law and Equity Act. BC has no homestead exemption — a registered judgment can force a sale if defendants do not pay.\n\nKey question for counsel: Is the home in both parents' names? Is the business incorporated?")
                                .font(.system(size:12)).foregroundStyle(.secondary).lineSpacing(4)
                        }

                        SectionCard("Limitation strategy") {
                            Text("This case involves incidents across 20+ years. Limitation is the primary defence defendants will use.\n\nChildhood acts (age 10, 15, infancy): BC Limitation Act s.16 suspends during minority. Clock started at 19 (~2019). Basic 2-year expired ~2021. Viable only via s.8(1)(d) discoverability.\n\nLikeness/appropriation: Ongoing tort if still in commercial use. 2-year from last use or discovery. Strongest head.\n\nEviction + parking lot: 2-year from incident. If within 2024–2026, basic limitation still open.\n\nStrategy: lead with likeness (cleanest). Use childhood incidents for damages context.")
                                .font(.system(size:12)).foregroundStyle(.secondary).lineSpacing(4)
                        }
                    }

                    SectionCard("Damages claimed") {
                        VStack(spacing: 0) {
                            let rows: [(String, String)] = rcmp
                                ? [("General (non-pecuniary)","Pain, suffering, loss of dignity, PTSD"),
                                   ("Charter damages s.24(1)","Compensatory deterrence per breach"),
                                   ("Punitive","Egregious, bad-faith state action"),
                                   ("Future earning capacity","Age 26, 35+ working years. Vocational economist required."),
                                   ("Special","Treatment, medications, lost income, wrist"),
                                   ("Aggravated","Deliberate nature of violations")]
                                : [("General (non-pecuniary)","Pain, suffering, PTSD"),
                                   ("Appropriation of personality","Commercial value of likeness used without consent"),
                                   ("IIMS","Intentional infliction of mental suffering — pattern of conduct"),
                                   ("Battery","Non-consensual bodily modification"),
                                   ("Lost earning capacity","Age 26, 35+ working years. PTSD from home environment."),
                                   ("Special","Treatment, therapy, homelessness costs"),
                                   ("Punitive","Parking lot confrontation + ongoing likeness use after eviction")]
                            ForEach(rows, id: \.0) { k, v in
                                HStack(alignment:.top,spacing:12) {
                                    Text(k).font(.system(size:13,weight:.semibold)).frame(maxWidth:.infinity,alignment:.leading)
                                    Text(v).font(.system(size:12)).foregroundStyle(.secondary).lineSpacing(2)
                                }.padding(.vertical,11)
                                Divider()
                            }
                            HStack {
                                Text("Net range").font(.system(size:11,weight:.bold)).foregroundStyle(.secondary)
                                Spacer()
                                Text(rcmp ? "$800k–$2M (median $1M+)" : "$300k–$1.15M").font(.system(size:18,weight:.bold,design:.rounded)).foregroundStyle(.briefGreen)
                            }.padding(.top,14)
                        }
                    }
                }
                .padding(.horizontal,16).padding(.bottom,32)
            }
            .navigationTitle("Money")
        }
    }
}
