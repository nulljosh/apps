import SwiftUI

private struct Badge {
    let text: String
    let color: Color
    let tilt: Double
}

struct CoverHeaderView: View {
    @Environment(Store.self) private var store

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: 7) {
                Text(eyebrow)
                    .font(.system(size: 9, design: .monospaced))
                    .foregroundStyle(.tertiary)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)

                titleText
                    .font(.system(size: 21, weight: .bold))
                    .fixedSize(horizontal: false, vertical: true)

                Text(sub)
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(badges.enumerated()), id: \.offset) { _, b in
                        Text(b.text)
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundStyle(b.color)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(b.color.opacity(0.1), in: RoundedRectangle(cornerRadius: 4))
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke(b.color.opacity(0.35), lineWidth: 1))
                            .rotationEffect(.degrees(b.tilt))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .trailing, spacing: 10) {
                StampView(caseID: store.activeCase, size: 90)
                    .rotationEffect(.degrees(-12))
                VStack(alignment: .trailing, spacing: 5) {
                    ForEach(metaRows, id: \.0) { k, v in
                        HStack(alignment: .top, spacing: 5) {
                            Text(k)
                                .font(.system(size: 8, weight: .semibold, design: .monospaced))
                                .foregroundStyle(.tertiary)
                            Text(v)
                                .font(.system(size: 8, design: .monospaced))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }
            }
            .frame(width: 100)
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var titleText: Text {
        switch store.activeCase {
        case .rcmp:
            return Text("Trommel ") + Text("v.").italic().foregroundStyle(Color.secondary) + Text(" AG Canada")
        case .family:
            return Text("Trommel ") + Text("v.").italic().foregroundStyle(Color.secondary) + Text(" Trommel")
        case .muni:
            return Text("Baitz ") + Text("v.").italic().foregroundStyle(Color.secondary) + Text(" City of Surrey")
        }
    }

    private var eyebrow: String {
        switch store.activeCase {
        case .rcmp:   return "In the matter of · Charter ss. 7 · 8 · 9 · 10(b) · 12"
        case .family: return "In the matter of · BC Privacy Act s.3 · IIMS · Negligence · Battery"
        case .muni:   return "In the matter of · Occupiers Liability · Municipal Negligence · BC Community Charter s.285"
        }
    }

    private var sub: String {
        switch store.activeCase {
        case .rcmp:
            return "Charter violations from a warrantless wellness-call entry. Langley, BC — Aug 1, 2023. Two RCMP officers, one dwelling, no underlying crime."
        case .family:
            return "Family tort arising from appropriation of personality, intentional infliction of mental suffering, parental negligence, and wrongful eviction."
        case .muni:
            return "Municipal negligence from a sunken sidewalk panel. Surrey, BC — May 2026. Bilateral knee lacerations. 2-month notice required or claim is barred."
        }
    }

    private var badges: [Badge] {
        switch store.activeCase {
        case .rcmp:
            return [
                Badge(text: "Pre-litigation",      color: .briefDanger, tilt: -0.6),
                Badge(text: "Counsel selection",   color: .briefAccent, tilt:  0.4),
                Badge(text: "Vol. I · CASE-0001",  color: .secondary,   tilt:  0.0)
            ]
        case .family:
            return [
                Badge(text: "Pre-litigation",      color: .briefDanger, tilt: -0.6),
                Badge(text: "Find tort counsel",   color: .briefAccent, tilt:  0.4),
                Badge(text: "Vol. I · CASE-0002",  color: .secondary,   tilt:  0.0)
            ]
        case .muni:
            return [
                Badge(text: "Notice required",         color: .briefDanger, tilt: -0.6),
                Badge(text: "Urgent — 2-month window", color: .briefDanger, tilt:  0.4),
                Badge(text: "Vol. I · CASE-0003",      color: .secondary,   tilt:  0.0)
            ]
        }
    }

    private var metaRows: [(String, String)] {
        switch store.activeCase {
        case .rcmp:
            return [
                ("Plaintiff",  "J. Trommel"),
                ("Defendant",  "AG Canada"),
                ("Forum",      "BC Supreme Court"),
                ("Incident",   "Aug 1, 2023"),
                ("Status",     "Counsel selection")
            ]
        case .family:
            return [
                ("Plaintiff",  "J. Trommel"),
                ("Defendants", "B. + C. Trommel"),
                ("Discovery",  "May 2026"),
                ("Deadline",   "May 1, 2028"),
                ("Status",     "Counsel selection")
            ]
        case .muni:
            return [
                ("Plaintiff",  "Sylvia Baitz"),
                ("Defendant",  "City of Surrey"),
                ("Injury",     "Bilateral knees"),
                ("Status",     "Notice pending")
            ]
        }
    }
}
