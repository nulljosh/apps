import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Life")
                    .font(.system(size: 48, weight: .ultraLight))
                    .tracking(-1)
                    .padding(.bottom, 8)

                Text("Updated March 2026")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 32)

                TimelineView()
                    .padding(.bottom, 24)

                ForEach(LifeData.sections) { section in
                    SectionCardView(section: section)
                }

                Divider().padding(.top, 32)
                Link("github.com/nulljosh/life", destination: URL(string: "https://github.com/nulljosh/life")!)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 12)

                Text("Life")
                    .font(.system(size: 96, weight: .ultraLight))
                    .tracking(-4)
                    .foregroundStyle(.primary.opacity(0.08))
                    .padding(.top, 48)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
        }
    }
}
