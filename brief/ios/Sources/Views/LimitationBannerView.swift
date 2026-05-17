import SwiftUI

struct LimitationBannerView: View {
    @Environment(Store.self) private var store
    private var rcmp: Bool { store.activeCase == .rcmp }

    private var basicDeadline: Date {
        rcmp
            ? Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 1))!
            : Calendar.current.date(from: DateComponents(year: 2028, month: 5, day: 1))!
    }
    private var incidentDate: Date {
        rcmp
            ? Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 1))!
            : Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 11))!
    }
    private var daysLeft: Int {
        Calendar.current.dateComponents([.day], from: .now, to: basicDeadline).day ?? -1
    }
    private var isExpired: Bool { daysLeft < 0 }
    private var progress: Double {
        let p = Date.now.timeIntervalSince(incidentDate) / basicDeadline.timeIntervalSince(incidentDate)
        return min(1, max(0, p))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(isExpired ? "Limitation — Discoverability + s.18 Active" : "Limitation Deadline")
                        .font(.system(size: 9, weight: .bold))
                        .tracking(1.4)
                        .textCase(.uppercase)
                        .foregroundStyle(.briefDanger)
                    Text(rcmp
                         ? "Basic limit: Aug 1, 2025 · Ultimate: Aug 1, 2038"
                         : "Basic limit: May 1, 2028 · Pin discoverability now")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(isExpired ? "Basic expired · Claim live" : "\(daysLeft) days")
                    .font(.system(size: isExpired ? 13 : 28, weight: .bold, design: .rounded))
                    .foregroundStyle(.briefDanger)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.secondary.opacity(0.2))
                        .frame(height: 5)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.briefDanger.opacity(0.5))
                        .frame(width: geo.size.width * progress, height: 5)
                    Circle()
                        .fill(Color.briefDanger)
                        .frame(width: 11, height: 11)
                        .offset(x: geo.size.width * progress - 5.5)
                }
            }
            .frame(height: 11)
            HStack {
                Text(rcmp ? "Incident · Aug 2023" : "Discovery · May 2026")
                Spacer()
                Text(rcmp ? "Ultimate: Aug 2038" : "Deadline: May 2028")
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
