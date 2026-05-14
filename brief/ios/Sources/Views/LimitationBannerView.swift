import SwiftUI

struct LimitationBannerView: View {
    private var daysLeft: Int {
        let deadline = Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 1))!
        return Calendar.current.dateComponents([.day], from: .now, to: deadline).day ?? -1
    }
    private var isExpired: Bool { daysLeft < 0 }
    private var progress: Double {
        let incident = Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 1))!
        let deadline = Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 1))!
        let p = Date.now.timeIntervalSince(incident) / deadline.timeIntervalSince(incident)
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
                    Text("Basic limit: Aug 1, 2025 · Ultimate: Aug 1, 2038")
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
                Text("Incident · Aug 2023")
                Spacer()
                Text("Ultimate: Aug 2038")
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
