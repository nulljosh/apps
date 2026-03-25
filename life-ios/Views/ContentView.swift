import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                // Page 1: Hero name
                VStack {
                    Spacer()
                    Text("Joshua Adam Trommel")
                        .font(.system(size: 42, weight: .bold))
                        .tracking(-1)
                        .multilineTextAlignment(.center)
                    Text("Updated March 2026")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 8)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.title3)
                        .foregroundStyle(.tertiary)
                        .padding(.bottom, 40)
                }
                .frame(maxWidth: .infinity)
                .containerRelativeFrame(.vertical)

                // Page 2: Timeline
                ScrollView {
                    TimelineView()
                        .padding(.horizontal, 24)
                        .padding(.vertical, 32)
                }
                .containerRelativeFrame(.vertical)

                // Pages 3+: Each content section
                ForEach(LifeData.sections) { section in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            SectionCardView(section: section)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 32)
                    }
                    .containerRelativeFrame(.vertical)
                }

                // Final page: Footer
                VStack {
                    Spacer()
                    Link("github.com/nulljosh/life", destination: URL(string: "https://github.com/nulljosh/life")!)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Joshua Adam Trommel")
                        .font(.system(size: 72, weight: .bold))
                        .tracking(-3)
                        .foregroundStyle(.primary.opacity(0.08))
                        .padding(.top, 24)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .containerRelativeFrame(.vertical)
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
    }
}
