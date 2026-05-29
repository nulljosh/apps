import SwiftUI

struct LimitationBannerView: View {
    @Environment(Store.self) private var store

    private var deadline: Date {
        switch store.activeCase {
        case .rcmp:   return Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 1))!
        case .family: return Calendar.current.date(from: DateComponents(year: 2028, month: 5, day: 1))!
        case .muni:
            let incident = Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 24))!
            return Calendar.current.date(byAdding: .day, value: 60, to: incident)!
        }
    }
    private var incidentDate: Date {
        switch store.activeCase {
        case .rcmp:   return Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 1))!
        case .family: return Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 11))!
        case .muni:   return Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 24))!
        }
    }
    private var daysLeft: Int {
        Calendar.current.dateComponents([.day], from: .now, to: deadline).day ?? -1
    }
    private var isExpired: Bool { daysLeft < 0 }
    private var progress: Double {
        let p = Date.now.timeIntervalSince(incidentDate) / deadline.timeIntervalSince(incidentDate)
        return min(1, max(0, p))
    }

    private var bannerLabel: String {
        switch store.activeCase {
        case .rcmp:   return isExpired ? "Limitation — Discoverability + s.19 Active" : "Limitation Deadline"
        case .family: return "Limitation Deadline"
        case .muni:   return "Notice Deadline — Community Charter s.285"
        }
    }
    private var bannerSub: String {
        switch store.activeCase {
        case .rcmp:   return "Basic limit: Aug 1, 2025 · Ultimate: Aug 1, 2038"
        case .family: return "Basic limit: May 1, 2028 · Pin discoverability now"
        case .muni:   return "2-month window from incident · send notice TODAY"
        }
    }
    private var daysLabel: String {
        switch store.activeCase {
        case .rcmp:   return isExpired ? "Basic expired · Claim live" : "\(daysLeft) days"
        case .family: return "\(daysLeft) days"
        case .muni:   return daysLeft <= 0 ? "Window expired" : "\(daysLeft) days"
        }
    }
    private var startLabel: String {
        switch store.activeCase {
        case .rcmp:   return "Incident · Aug 2023"
        case .family: return "Discovery · May 2026"
        case .muni:   return "Incident · May 2026"
        }
    }
    private var endLabel: String {
        switch store.activeCase {
        case .rcmp:   return "Ultimate: Aug 2038"
        case .family: return "Deadline: May 2028"
        case .muni:   return "Notice window: 2 months"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(bannerLabel)
                        .font(.system(size: 9, weight: .bold))
                        .tracking(1.4)
                        .textCase(.uppercase)
                        .foregroundStyle(.briefDanger)
                    Text(bannerSub)
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(daysLabel)
                    .font(.system(size: (isExpired && store.activeCase == .rcmp) ? 13 : 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.briefDanger)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4).fill(Color.secondary.opacity(0.2)).frame(height: 5)
                    RoundedRectangle(cornerRadius: 4).fill(Color.briefDanger.opacity(0.5))
                        .frame(width: geo.size.width * progress, height: 5)
                    Circle().fill(Color.briefDanger).frame(width: 11, height: 11)
                        .offset(x: geo.size.width * progress - 5.5)
                }
            }
            .frame(height: 11)
            HStack {
                Text(startLabel)
                Spacer()
                Text(endLabel)
            }
            .font(.system(size: 9, design: .monospaced))
            .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.briefDanger.opacity(0.08))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.briefDanger, lineWidth: 1))
        )
    }
}
