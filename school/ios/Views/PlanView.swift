import SwiftUI

struct PlanView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Now") {
                    PlanRow(title: "Module 1 Exam Rewrite", detail: "3–6pm · Room A179 · last opportunity", badge: "Today", badgeColor: .red)
                    PlanRow(title: "Class at 6:30 if skipping rewrite", detail: "Finish U4 · start U5 in class", badge: "Tonight", badgeColor: .orange)
                    PlanRow(title: "Unit 3 — Polynomials Project", detail: "Submitted May 26 · awaiting grade", badge: "Grading", badgeColor: .orange)
                    PlanRow(title: "Unit 4 — Exponents & Logs", detail: "In class since May 26", badge: "Active", badgeColor: .orange)
                }

                Section("Applications") {
                    PlanRow(title: "Capilano University", detail: "Paralegal Studies · North Vancouver, 2026", badge: "Applying", badgeColor: .blue)
                    PlanRow(title: "UBC", detail: "Law · after CapU", badge: "Future", badgeColor: nil)
                }

                Section("Completed") {
                    GradeRow(title: "English Studies 12", grade: "A · 87%", color: .green)
                    GradeRow(title: "Anatomy & Physiology 12", grade: "C+ · 67%", color: .orange)
                    GradeRow(title: "Law 12", grade: "C- · 50%", color: .red)
                }

                Section("Pre-Calc 12 · Unit Progress") {
                    UnitProgressRow(unit: 1, topic: "Sequences & Series", pct: 88)
                    UnitProgressRow(unit: 2, topic: "Transformations", pct: 78)
                    UnitProgressRow(unit: 3, topic: "Polynomials", pct: nil, status: "Grading")
                    UnitProgressRow(unit: 4, topic: "Exponents & Logs", pct: nil, status: "Active")
                    UnitProgressRow(unit: 5, topic: "Rational Expressions", pct: nil, status: "Active")
                    UnitProgressRow(unit: 6, topic: "Sinusoidal Functions", pct: nil, status: "Pending")
                    UnitProgressRow(unit: 7, topic: "Trig Identities", pct: nil, status: "Self-study")
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .navigationTitle("Plan")
            .background(Color.black)
        }
    }
}

private struct PlanRow: View {
    let title: String
    let detail: String
    let badge: String
    let badgeColor: Color?

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title).fontWeight(.medium)
                Text(detail).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text(badge)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(badgeColor ?? Color.secondary)
        }
        .padding(.vertical, 2)
    }
}

private struct GradeRow: View {
    let title: String
    let grade: String
    let color: Color

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(grade).foregroundStyle(color).fontWeight(.medium)
        }
    }
}

private struct UnitProgressRow: View {
    let unit: Int
    let topic: String
    let pct: Double?
    var status: String?

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("U\(unit) · \(topic)").font(.subheadline)
            }
            Spacer()
            if let pct {
                Text("\(Int(pct))%")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(gradeColor(pct))
            } else if let status {
                Text(status)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
