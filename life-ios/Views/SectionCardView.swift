import SwiftUI

struct SectionCardView: View {
    let section: LifeSection

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(section.label.uppercased())
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .tracking(0.8)
                .padding(.top, 28)
                .padding(.bottom, 12)

            Divider()

            VStack(alignment: .leading, spacing: 14) {
                ForEach(Array(section.paragraphs.enumerated()), id: \.offset) { _, paragraph in
                    Text(paragraph)
                        .font(.subheadline)
                        .lineSpacing(4)
                }
            }
            .padding(.vertical, 16)

            if let note = section.note {
                Divider()
                Text(note)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .italic()
                    .padding(.vertical, 12)
            }
        }
    }
}
