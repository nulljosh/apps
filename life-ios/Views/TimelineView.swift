import SwiftUI

struct TimelineView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Timeline: 1999 to 2026")
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.bottom, 12)

            HStack(spacing: 16) {
                ForEach(TimelineCategory.allCases, id: \.self) { cat in
                    legendItem(color: cat.color, label: cat.displayName)
                }
            }
            .padding(.bottom, 16)

            ForEach(Array(LifeData.timeline.enumerated()), id: \.element.id) { index, entry in
                HStack(alignment: .top, spacing: 14) {
                    VStack(spacing: 0) {
                        Circle()
                            .fill(entry.category.color)
                            .frame(width: 10, height: 10)
                        if index < LifeData.timeline.count - 1 {
                            Rectangle()
                                .fill(.tertiary)
                                .frame(width: 1)
                                .frame(maxHeight: .infinity)
                        }
                    }
                    .frame(width: 10)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(entry.year)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        Text(entry.text)
                            .font(.subheadline)
                        if let detail = entry.detail {
                            Text(detail)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.bottom, 16)
                }
            }
        }
        .padding(.vertical, 16)
    }

    private func legendItem(color: Color, label: String) -> some View {
        HStack(spacing: 6) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(label).font(.caption2).foregroundStyle(.secondary)
        }
    }
}
