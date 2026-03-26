import SwiftUI

struct TrophyView: View {
    @Environment(ProgressManager.self) private var progressManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(Trophies.all) { trophy in
                    let isUnlocked = progressManager.progress.trophyIds.contains(trophy.id)
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(isUnlocked ? Color.yellow.opacity(0.2) : Color(.systemGray5))
                                .frame(width: 44, height: 44)
                            Image(systemName: trophy.icon)
                                .font(.title3)
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
                                .foregroundStyle(.green)
                        }
                    }
                    .opacity(isUnlocked ? 1 : 0.5)
                }
            }
            .navigationTitle("Trophies")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
