import SwiftUI 

struct ContentView: View {
    private let s = LifeData.sections
    @State private var heroAppeared = false
    @State private var bounceChevron = false

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

                // Intrusive Memories + Triggers + Trigger Flow
                sectionWithVisual([s[1]]) {
                    TriggersChart()
                    TriggerFlowView()
                }

                // Anger & Conflict, Sleep + Sleep Quality Chart
                sectionWithVisual([s[2], s[3]]) { SleepQualityChart() }

                // Siblings, Extended Family, Pets & Loss
                sectionPage([s[4], s[5], s[6]])

                // Grief & Accumulated Loss
                sectionPage([s[7]])

                // School, Religion
                sectionPage([s[8], s[9]])

                // ADHD/Autism + Sensory Profile + Sensory Heatmap
                sectionWithVisual([s[10], s[11]]) { SensoryHeatmapChart() }

                // Masking & Burnout + Energy Budget + Comparison Table + Dialog Pattern
                sectionWithVisual([s[12]]) {
                    MaskingEnergyChart()
                    ComparisonTableView()
                    DialogBlockView()
                }

                sectionWithVisual([s[13], s[14]]) { DiagnosisGapChart() }

                // Relationships + Relationship Chart
                sectionWithVisual([s[15]]) { RelationshipChart() }

                // Trust & Attachment
                sectionPage([s[16]])

                // Sexuality, Boundaries + Boundaries Chart, Friendships + Social Circle
                sectionWithVisual([s[17], s[18]]) { BoundariesChart() }

                sectionWithVisual([s[19]]) { SocialCircleChart() }

                // Housing + Pull Quote + Housing Chart
                sectionWithVisual([s[20]]) {
                    PullQuoteView(text: LifeData.pullQuotes[1])
                    HousingChart()
                }

                // Mental Health (long section, own page)
                sectionPage([s[21]])

                // Substances Expanded + Pull Quote + Substance Chart
                sectionWithVisual([s[22]]) {
                    PullQuoteView(text: LifeData.pullQuotes[3])
                    SubstanceChart()
                }

                // Pull Quote + Coping Chart
                combinedPage {
                    PullQuoteView(text: LifeData.pullQuotes[2])
                    CopingChart()
                }

                // Physical Health & Body + Body Chart
                sectionWithVisual([s[23]]) { BodyChart() }

                // Identity & Worldview, Screen Time + Stats
                sectionWithVisual([s[24], s[25]]) { StatsGridView() }

                // Current Life + Daily Routine + Progress Trackers
                sectionWithVisual([s[26]]) {
                    DailyRoutineChart()
                    ProgressTrackersView()
                }

                // Financial Reality + Financial Timeline Chart
                sectionWithVisual([s[27]]) { FinancialTimelineChart() }

                // Work History, Career & Projects + Map
                sectionWithVisual([s[28], s[29]]) { LifeMapView() }

                // Strengths & What Keeps Me Going + Strengths Chart
                sectionWithVisual([s[30]]) { StrengthsChart() }

                // Then vs Now + Radar Self-Assessment
                combinedPage {
                    ThenNowView()
                    RadarChartView()
                }

                // What I Want from Therapy
                sectionPage([s[31]])

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
                .scaleEffect(heroAppeared ? 1.0 : 0.92)
                .opacity(heroAppeared ? 1.0 : 0)
            Text("Updated March 2026")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top, 8)
                .opacity(heroAppeared ? 1.0 : 0)
            Spacer()
            Image(systemName: "chevron.down")
                .font(.title3)
                .foregroundStyle(.tertiary)
                .offset(y: bounceChevron ? 4 : -4)
                .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity)
        .containerRelativeFrame(.vertical)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                heroAppeared = true
            }
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                bounceChevron = true
            }
        }
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
            VStack(alignment: .leading, spacing: 28) {
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
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
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
