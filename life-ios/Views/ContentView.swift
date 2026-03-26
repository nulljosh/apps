import SwiftUI

struct ContentView: View {
    private let pageGroups: [[LifeSection]] = {
        let s = LifeData.sections
        return [
            [s[0]],                     // Early Childhood & Family
            [s[1]],                     // Intrusive Memories
            [s[2], s[3], s[4]],         // Siblings, Extended Family, Pets & Loss
            [s[5], s[6]],              // School, Religion
            [s[7], s[8], s[9]],        // ADHD/Autism, Medication, Previous Therapy
            [s[10]],                    // Relationships
            [s[11], s[12]],            // Sexuality, Friendships
            [s[13]],                    // Housing
            [s[14]],                    // Mental Health
            [s[15], s[16]],            // Identity & Worldview, Current Life
            [s[17], s[18], s[19]],     // Work History, Career & Projects, Therapy Goals
        ]
    }()

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                heroPage
                timelinePage
                chartsPage

                ForEach(Array(pageGroups.enumerated()), id: \.offset) { _, group in
                    sectionPage(group)
                }

                footerPage
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
    }

    private var heroPage: some View {
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
    }

    private var timelinePage: some View {
        ScrollView {
            TimelineView()
                .padding(.horizontal, 24)
                .padding(.vertical, 32)
        }
        .containerRelativeFrame(.vertical)
    }

    private var chartsPage: some View {
        ScrollView {
            ChartsView()
                .padding(.horizontal, 24)
                .padding(.vertical, 32)
        }
        .containerRelativeFrame(.vertical)
    }

    private func sectionPage(_ sections: [LifeSection]) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(sections) { section in
                    SectionCardView(section: section)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
        }
        .containerRelativeFrame(.vertical)
    }

    private var footerPage: some View {
        VStack {
            Spacer()
            Link("github.com/nulljosh/apps/life-ios", destination: URL(string: "https://github.com/nulljosh/apps/tree/main/life-ios")!)
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
}
