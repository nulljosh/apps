import SwiftUI

struct TrophyView: View {
    @Environment(ProgressManager.self) private var progressManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Trophies")
                    .font(.title2.weight(.bold))
                Spacer()
                Button("Done") { dismiss() }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            Divider()

            List {
                ForEach(Trophies.all) { trophy in
                    let isUnlocked = progressManager.progress.trophyIds.contains(trophy.id)
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(isUnlocked ? Color.yellow.opacity(0.2) : Theme.adaptiveBgTertiary)
                                .frame(width: 40, height: 40)
                            Image(systemName: trophy.icon)
                                .font(.body)
                                .foregroundStyle(isUnlocked ? .yellow : .secondary)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(trophy.name)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(isUnlocked ? .primary : .secondary)
                            Text(trophy.desc)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        if isUnlocked {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Theme.success)
                        }
                    }
                    .opacity(isUnlocked ? 1 : 0.5)
                    .padding(.vertical, 2)
                }
            }
            .listStyle(.plain)
        }
    }
}
