import SwiftUI

struct ContentView: View {
    private let s = LifeData.sections

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                heroPage
                timelinePage
                chartsPage

                // Early Childhood & Family
                sectionPage([s[0]])
                visualPage { PullQuoteView(text: LifeData.pullQuotes[0]) }
                visualPage { AggressionChart() }

                // Intrusive Memories
                sectionPage([s[1]])
                visualPage { TriggersChart() }

                // Siblings, Extended Family, Pets & Loss
                sectionPage([s[2], s[3], s[4]])

                // School, Religion
                sectionPage([s[5], s[6]])

                // ADHD/Autism, Medication, Previous Therapy
                sectionPage([s[7], s[8], s[9]])
                visualPage { DiagnosisGapChart() }

                // Relationships
                sectionPage([s[10]])
                visualPage { RelationshipChart() }

                // Sexuality, Friendships
                sectionPage([s[11], s[12]])
                visualPage { SocialCircleChart() }

                // Housing
                sectionPage([s[13]])
                visualPage { PullQuoteView(text: LifeData.pullQuotes[1]) }
                visualPage { HousingChart() }

                // Mental Health
                sectionPage([s[14]])
                visualPage { PullQuoteView(text: LifeData.pullQuotes[2]) }
                visualPage { CopingChart() }

                // Identity & Worldview
                sectionPage([s[15]])
                visualPage { StatsGridView() }

                // Current Life
                sectionPage([s[16]])
                visualPage { DailyRoutineChart() }

                // Work History, Career & Projects
                sectionPage([s[17], s[18]])
                visualPage { LifeMapView() }

                // What I Want from Therapy
                sectionPage([s[19]])

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

    private func visualPage<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        ScrollView {
            content()
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
