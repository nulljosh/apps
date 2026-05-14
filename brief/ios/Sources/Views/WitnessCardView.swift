import SwiftUI

struct WitnessCardView: View {
    let witness: Witness

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.secondary.opacity(0.15))
                        .frame(width: 38, height: 38)
                    Text(witness.initials)
                        .font(.system(size: 15, weight: .bold, design: .monospaced))
                        .foregroundStyle(.briefAccent)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(witness.name)
                        .font(.system(size: 14, weight: .semibold))
                    Text("\(witness.role) · \(witness.date)")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundStyle(.secondary)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    ForEach(witness.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 9, weight: .semibold, design: .monospaced))
                            .foregroundStyle(.briefGreen)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.briefGreen.opacity(0.12), in: Capsule())
                            .overlay(Capsule().stroke(Color.secondary.opacity(0.2)))
                    }
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("STATEMENT — VERBATIM")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .tracking(1)
                Text(witness.statement)
                    .font(.system(size: 12))
                    .foregroundStyle(.primary)
                    .lineSpacing(4)
                    .padding(12)
                    .background(Color.secondary.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.15))
                    )
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("LEGAL ANNOTATIONS")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .tracking(1)
                ForEach(witness.annotations) { annotation in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\"\(annotation.quote)\"")
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundStyle(.briefWarn)
                        Text(annotation.note)
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                    }
                    .padding(10)
                    .background(Color.secondary.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.briefWarn.opacity(0.4), lineWidth: 1)
                    )
                }
            }
        }
        .padding(18)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}
