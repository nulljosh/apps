import SwiftUI

struct ContentView: View {
    private let s = LifeData.sections

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                heroPage
                timelinePage
                chartsPage

                // Early Childhood (long section, own page)
                sectionPage([s[0]])

                // Pull Quote + Aggression Chart
                combinedPage {
                    PullQuoteView(text: LifeData.pullQuotes[0])
                    AggressionChart()
                }

                // Intrusive Memories + Triggers
                sectionWithVisual([s[1]]) { TriggersChart() }

                // Siblings, Extended Family, Pets & Loss
                sectionPage([s[2], s[3], s[4]])

                // School, Religion
                sectionPage([s[5], s[6]])

                // ADHD/Autism, Medication, Previous Therapy + Diagnosis Gap
                sectionWithVisual([s[7], s[8], s[9]]) { DiagnosisGapChart() }

                // Relationships + Relationship Chart
                sectionWithVisual([s[10]]) { RelationshipChart() }

                // Sexuality, Friendships + Social Circle
                sectionWithVisual([s[11], s[12]]) { SocialCircleChart() }

                // Housing + Pull Quote + Housing Chart
                sectionWithVisual([s[13]]) {
                    PullQuoteView(text: LifeData.pullQuotes[1])
                    HousingChart()
                }

                // Mental Health (long section, own page)
                sectionPage([s[14]])

                // Pull Quote + Coping Chart
                combinedPage {
                    PullQuoteView(text: LifeData.pullQuotes[2])
                    CopingChart()
                }

                // Identity & Worldview + Stats
                sectionWithVisual([s[15]]) { StatsGridView() }

                // Current Life + Daily Routine
                sectionWithVisual([s[16]]) { DailyRoutineChart() }

                // Work History, Career & Projects + Map
                sectionWithVisual([s[17], s[18]]) { LifeMapView() }

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

    private func sectionWithVisual<Visual: View>(_ sections: [LifeSection], @ViewBuilder visual: () -> Visual) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ForEach(sections) { section in
                    SectionCardView(section: section)
                }
                visual()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
        }
        .containerRelativeFrame(.vertical)
    }

    private func combinedPage<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                content()
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
