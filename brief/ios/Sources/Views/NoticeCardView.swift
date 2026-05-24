import SwiftUI

struct NoticeCardView: View {
    private var incidentDate: Date {
        Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 24)) ?? .now
    }
    private var deadline: Date {
        Calendar.current.date(byAdding: .day, value: 60, to: incidentDate) ?? .now
    }
    private var daysLeft: Int {
        max(0, Calendar.current.dateComponents([.day], from: .now, to: deadline).day ?? 0)
    }
    private var isUrgent: Bool { daysLeft <= 14 }

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("BC COMMUNITY CHARTER S.285 — MANDATORY")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .tracking(1.5)
                    .foregroundStyle(Color.briefDanger)
                Text("Send written notice to Surrey within 2 months")
                    .font(.system(size: 15, weight: .semibold))
                Text("Registered mail to Surrey City Clerk: 13450 104 Ave, Surrey BC V3T 1V8. Include: claimant name, date, location, nature of injury. Failure to notify bars the claim entirely.")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            VStack(spacing: 2) {
                Text("\(daysLeft)")
                    .font(.system(size: 36, weight: .bold).monospacedDigit())
                    .foregroundStyle(Color.briefDanger)
                Text("days left")
                    .font(.system(size: 9, design: .monospaced))
                    .foregroundStyle(.secondary)
            }
            .frame(width: 70)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.briefDanger.opacity(0.08))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.briefDanger, lineWidth: 1))
        )
    }
}
