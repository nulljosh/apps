import Foundation
import SwiftUI

enum TimelineCategory: String, CaseIterable {
    case crisis
    case event
    case forward

    var color: Color {
        switch self {
        case .crisis: .red
        case .event: .primary
        case .forward: .green
        }
    }

    var displayName: String { rawValue.capitalized }
}

struct TimelineEntry: Identifiable {
    let id = UUID()
    let year: String
    let text: String
    let detail: String?
    let category: TimelineCategory
}

struct LifeSection: Identifiable {
    let id = UUID()
    let label: String
    let paragraphs: [String]
    let note: String?
}

struct StabilityPoint: Identifiable {
    let id = UUID()
    let year: Int
    let label: String
    let score: Double
    let category: TimelineCategory
}

struct PhaseData: Identifiable {
    let id = UUID()
    let phase: String
    let ages: String
    let count: Int
    let category: TimelineCategory
}

struct AggressionPeriod: Identifiable {
    let id = UUID()
    let label: String
    let startAge: Int
    let endAge: Int
    let category: TimelineCategory
    let detail: String?
}

struct TriggerItem: Identifiable {
    let id = UUID()
    let label: String
    let detail: String
    let intensity: Double // 0-1, controls bubble size
}

struct DiagnosisMilestone: Identifiable {
    let id = UUID()
    let age: Int
    let label: String
    let category: TimelineCategory
}

struct RelationshipPeriod: Identifiable {
    let id = UUID()
    let name: String
    let startYear: Int
    let endYear: Int
    let category: TimelineCategory
    let detail: String
}

struct SocialPoint: Identifiable {
    let id = UUID()
    let year: Int
    let label: String
    let count: Double
    let category: TimelineCategory
}

struct HousingState: Identifiable {
    let id = UUID()
    let label: String
    let year: String
    let level: Double // 0=none, 0.5=unstable, 1=stable
    let category: TimelineCategory
}

struct CopingItem: Identifiable {
    let id = UUID()
    let label: String
    let detail: String
    let intensity: Double // 0-1
    let isHealthy: Bool
}

struct DailySegment: Identifiable {
    let id = UUID()
    let label: String
    let hours: Double
    let category: TimelineCategory
}

struct StatItem: Identifiable {
    let id = UUID()
    let number: String
    let label: String
}

struct MapLocation: Identifiable {
    let id = UUID()
    let name: String
    let detail: String
    let category: TimelineCategory
    let isOffMap: Bool
    let latitude: Double
    let longitude: Double
}

struct SensoryItem: Identifiable {
    let id = UUID()
    let sense: String
    let detail: String
    let intensity: Double // 0-1
}

struct SubstancePoint: Identifiable {
    let id = UUID()
    let age: Int
    let label: String
    let weedIntensity: Double // 0-1
    let vapingIntensity: Double // 0-1
}

struct StrengthItem: Identifiable {
    let id = UUID()
    let label: String
    let intensity: Double // 0-1
}

struct SleepPhase: Identifiable {
    let id = UUID()
    let phase: String
    let years: String
    let quality: Double // 0-1, 1=good
    let category: TimelineCategory
}

struct FinancialPeriod: Identifiable {
    let id = UUID()
    let label: String
    let years: String
    let source: String
    let category: TimelineCategory
}

struct ComparisonRow: Identifiable {
    let id = UUID()
    let left: String
    let right: String
}

struct DialogLine: Identifiable {
    let id = UUID()
    let speaker: String
    let text: String
    let isInternal: Bool
}

struct ThenNowItem: Identifiable {
    let id = UUID()
    let text: String
}

struct FlowStep: Identifiable {
    let id = UUID()
    let label: String
    let detail: String?
    let category: TimelineCategory
}

struct ProgressItem: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
    let direction: String
    let detail: String
}

struct RadarDimension: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
}

enum LifeData {
    static let stability: [StabilityPoint] = [
        StabilityPoint(year: 1999, label: "Born", score: 0.5, category: .forward),
        StabilityPoint(year: 2001, label: "Trauma", score: 0.35, category: .crisis),
        StabilityPoint(year: 2007, label: "ADHD dx", score: 0.65, category: .event),
        StabilityPoint(year: 2008, label: "Travel", score: 0.75, category: .forward),
        StabilityPoint(year: 2014, label: "First rel.", score: 0.7, category: .event),
        StabilityPoint(year: 2017, label: "Prom", score: 0.75, category: .event),
        StabilityPoint(year: 2019, label: "2nd rel.", score: 0.15, category: .crisis),
        StabilityPoint(year: 2021, label: "Breakdown", score: 0.08, category: .crisis),
        StabilityPoint(year: 2024, label: "Homeless", score: 0.18, category: .crisis),
        StabilityPoint(year: 2025, label: "Autism dx", score: 0.5, category: .event),
        StabilityPoint(year: 2026, label: "Therapy", score: 0.7, category: .forward),
    ]

    static let phases: [PhaseData] = [
        PhaseData(phase: "Childhood", ages: "0-10", count: 4, category: .event),
        PhaseData(phase: "Adolescence", ages: "11-18", count: 2, category: .event),
        PhaseData(phase: "Early 20s", ages: "19-22", count: 3, category: .crisis),
        PhaseData(phase: "Recent", ages: "23-26", count: 2, category: .forward),
    ]

    static let aggression: [AggressionPeriod] = [
        AggressionPeriod(label: "Physical", startAge: 0, endAge: 5, category: .crisis, detail: nil),
        AggressionPeriod(label: "Verbal + intimidation", startAge: 0, endAge: 21, category: .crisis, detail: "\"You better listen or your dad will hit you\""),
        AggressionPeriod(label: "Calm", startAge: 21, endAge: 26, category: .forward, detail: nil),
    ]

    static let triggers: [TriggerItem] = [
        TriggerItem(label: "Family", detail: "constant", intensity: 1.0),
        TriggerItem(label: "Nighttime", detail: "when masking drops", intensity: 0.9),
        TriggerItem(label: "Places", detail: "specific locations", intensity: 0.6),
        TriggerItem(label: "Conversations", detail: "specific topics", intensity: 0.6),
        TriggerItem(label: "Random", detail: "no pattern", intensity: 0.55),
    ]

    static let diagnosisMilestones: [DiagnosisMilestone] = [
        DiagnosisMilestone(age: 8, label: "ADHD dx", category: .event),
        DiagnosisMilestone(age: 8, label: "Dr. Chapman", category: .event),
        DiagnosisMilestone(age: 8, label: "ADHD meds (brief)", category: .event),
        DiagnosisMilestone(age: 25, label: "Autism dx", category: .event),
        DiagnosisMilestone(age: 26, label: "Sertraline", category: .forward),
        DiagnosisMilestone(age: 26, label: "Amanda", category: .forward),
        DiagnosisMilestone(age: 26, label: "PWD pending", category: .event),
    ]

    static let relationships: [RelationshipPeriod] = [
        RelationshipPeriod(name: "First", startYear: 2014, endYear: 2017, category: .event, detail: "prom, NYC"),
        RelationshipPeriod(name: "Second", startYear: 2019, endYear: 2019, category: .crisis, detail: "9 months"),
        RelationshipPeriod(name: "Longest", startYear: 2021, endYear: 2023, category: .event, detail: "breakdown after"),
    ]

    static let socialCircle: [SocialPoint] = [
        SocialPoint(year: 2005, label: "Childhood", count: 0.7, category: .forward),
        SocialPoint(year: 2014, label: "High school", count: 0.75, category: .event),
        SocialPoint(year: 2018, label: "'17-'19", count: 0.72, category: .event),
        SocialPoint(year: 2020, label: "'20", count: 0.15, category: .crisis),
        SocialPoint(year: 2021, label: "'21", count: 0.12, category: .crisis),
        SocialPoint(year: 2024, label: "'24", count: 0.05, category: .crisis),
        SocialPoint(year: 2026, label: "'26", count: 0.02, category: .crisis),
    ]

    static let housing: [HousingState] = [
        HousingState(label: "Home", year: "'99-'24", level: 1.0, category: .forward),
        HousingState(label: "Car", year: "Summer '24", level: 0.0, category: .crisis),
        HousingState(label: "AirBnB", year: "Fall '24", level: 0.5, category: .event),
        HousingState(label: "Home again", year: "Late '24+", level: 1.0, category: .forward),
    ]

    static let coping: [CopingItem] = [
        CopingItem(label: "Weed", detail: "daily, heavy, to suppress memory", intensity: 1.0, isHealthy: false),
        CopingItem(label: "Vaping", detail: "", intensity: 0.6, isHealthy: false),
        CopingItem(label: "Self-harm", detail: "since age 22", intensity: 0.7, isHealthy: false),
        CopingItem(label: "Suppression", detail: "memory erasure", intensity: 0.5, isHealthy: false),
        CopingItem(label: "Gym", detail: "daily, 1-2 hours, hitting PRs", intensity: 0.9, isHealthy: true),
        CopingItem(label: "Coding", detail: "satisfaction + avoidance, 18h sessions", intensity: 0.85, isHealthy: true),
        CopingItem(label: "Gaming", detail: "escape / flow state", intensity: 0.7, isHealthy: true),
        CopingItem(label: "Studying", detail: "calc + bio", intensity: 0.5, isHealthy: true),
    ]

    static let dailyRoutine: [DailySegment] = [
        DailySegment(label: "Sleep", hours: 8, category: .event),
        DailySegment(label: "Gym", hours: 2, category: .forward),
        DailySegment(label: "Coding", hours: 4, category: .forward),
        DailySegment(label: "Gaming", hours: 3, category: .event),
        DailySegment(label: "Other", hours: 7, category: .event),
    ]

    static let sensoryProfile: [SensoryItem] = [
        SensoryItem(sense: "Sound", detail: "loud noises, group conversations", intensity: 0.8),
        SensoryItem(sense: "Tactile", detail: "hair twirling (trichotillomania)", intensity: 0.9),
        SensoryItem(sense: "Repetitive", detail: "hand washing 10+/day, feet rubbing", intensity: 0.7),
        SensoryItem(sense: "Social overload", detail: "4-5 people talking at once", intensity: 0.85),
        SensoryItem(sense: "General", detail: "everything stimulates", intensity: 1.0),
    ]

    static let substanceTimeline: [SubstancePoint] = [
        SubstancePoint(age: 17, label: "First time", weedIntensity: 0.05, vapingIntensity: 0.0),
        SubstancePoint(age: 18, label: "Occasional", weedIntensity: 0.15, vapingIntensity: 0.0),
        SubstancePoint(age: 19, label: "Regular", weedIntensity: 0.4, vapingIntensity: 0.1),
        SubstancePoint(age: 21, label: "Daily", weedIntensity: 0.6, vapingIntensity: 0.3),
        SubstancePoint(age: 23, label: "Heavy daily", weedIntensity: 0.8, vapingIntensity: 0.5),
        SubstancePoint(age: 25, label: "5+/day", weedIntensity: 0.95, vapingIntensity: 0.6),
        SubstancePoint(age: 27, label: "Current", weedIntensity: 1.0, vapingIntensity: 0.6),
    ]

    static let strengths: [StrengthItem] = [
        StrengthItem(label: "STEM", intensity: 0.95),
        StrengthItem(label: "Resiliency", intensity: 0.9),
        StrengthItem(label: "Kindness", intensity: 0.85),
        StrengthItem(label: "Intelligence", intensity: 0.9),
        StrengthItem(label: "Humor", intensity: 0.8),
    ]

    static let sleepPhases: [SleepPhase] = [
        SleepPhase(phase: "Childhood", years: "'99-'07", quality: 0.6, category: .event),
        SleepPhase(phase: "Teens", years: "'14-'18", quality: 0.45, category: .event),
        SleepPhase(phase: "Early 20s", years: "'19-'23", quality: 0.25, category: .crisis),
        SleepPhase(phase: "Homeless", years: "'24", quality: 0.1, category: .crisis),
        SleepPhase(phase: "Now", years: "'25-'26", quality: 0.4, category: .event),
    ]

    static let financialTimeline: [FinancialPeriod] = [
        FinancialPeriod(label: "Parents", years: "'99-'17", source: "Family", category: .forward),
        FinancialPeriod(label: "Jobs", years: "'17-'22", source: "Employment", category: .event),
        FinancialPeriod(label: "Fired/quit", years: "'22-'24", source: "Parents", category: .crisis),
        FinancialPeriod(label: "Welfare", years: "'24-now", source: "Government", category: .event),
        FinancialPeriod(label: "Planned", years: "'27+", source: "AI career 100K+", category: .forward),
    ]

    static let stats: [StatItem] = [
        StatItem(number: "17", label: "years between\ndiagnoses"),
        StatItem(number: "21", label: "years of verbal\naggression"),
        StatItem(number: "8", label: "age at first\ntherapist"),
        StatItem(number: "26", label: "current\nage"),
        StatItem(number: "0", label: "close friends\nnearby"),
        StatItem(number: "2", label: "rehab\nstays"),
        StatItem(number: "5+", label: "bong tokes\nper day"),
        StatItem(number: "130+", label: "IQ"),
        StatItem(number: "50/50", label: "help vs.\nhurt"),
        StatItem(number: "17", label: "age first\nsmoked weed"),
        StatItem(number: "0", label: "boundaries\nthat worked"),
        StatItem(number: "50%", label: "time spent\nmasking"),
    ]

    static let pullQuotes: [String] = [
        "If my dad gave me a billion dollars it wouldn't change it.",
        "I don't know why I was kicked out. I don't know what made them let me back in.",
        "The coping mechanisms are a mix of self-destructive and genuinely healthy. They just coexist.",
        "It half-deactivated my autism and helped me just relax and stop thinking.",
    ]

    static let mapLocations: [MapLocation] = [
        MapLocation(name: "Langley", detail: "home, current", category: .forward, isOffMap: false, latitude: 49.1044, longitude: -122.6603),
        MapLocation(name: "Vancouver Island", detail: "rehab x2, best friend, planned move", category: .event, isOffMap: false, latitude: 49.6500, longitude: -125.4490),
        MapLocation(name: "Kamloops", detail: "cousins, childhood", category: .forward, isOffMap: false, latitude: 50.6745, longitude: -120.3273),
        MapLocation(name: "Seattle", detail: "CodeDay", category: .forward, isOffMap: false, latitude: 47.6062, longitude: -122.3321),
        MapLocation(name: "NYC", detail: "best week of my life", category: .forward, isOffMap: true, latitude: 40.7128, longitude: -74.0060),
        MapLocation(name: "Florida", detail: "Disneyland, family trips", category: .forward, isOffMap: true, latitude: 28.3852, longitude: -81.5639),
        MapLocation(name: "Hawaii", detail: "family trips, Feb 2026", category: .forward, isOffMap: true, latitude: 20.7984, longitude: -156.3319),
    ]

    static let comparisonTable: [ComparisonRow] = [
        ComparisonRow(left: "Normal family", right: "Dad hitting me at 2, mom weaponizing it"),
        ComparisonRow(left: "Nice house, vacations", right: "Constant arguing, fear, intimidation"),
        ComparisonRow(left: "Kid who has it good", right: "Kid carrying shame that never left"),
        ComparisonRow(left: "Quiet teenager", right: "Masking 50% of the day, crying at night"),
        ComparisonRow(left: "Independent young adult", right: "Homeless, living in a car, hospitalized"),
        ComparisonRow(left: "Smart guy with potential", right: "130+ IQ, no diagnosis for 17 years, smoking weed to stop thinking"),
    ]

    static let dialogPattern: [DialogLine] = [
        DialogLine(speaker: "Them", text: "How are you doing?", isInternal: false),
        DialogLine(speaker: "Me", text: "I'm good, yeah", isInternal: false),
        DialogLine(speaker: "Them", text: "Cool, good to hear", isInternal: false),
        DialogLine(speaker: "", text: "masking, dissociating, replaying memories from 20 years ago", isInternal: true),
    ]

    static let triggerFlow: [FlowStep] = [
        FlowStep(label: "Trigger hits", detail: "Family, nighttime, specific places, random", category: .crisis),
        FlowStep(label: "Mask holds (if daytime)", detail: "Keep composure, push through, nobody notices", category: .event),
        FlowStep(label: "Mask drops (nighttime)", detail: "Crying, overwhelm, memories replay at full intensity", category: .crisis),
        FlowStep(label: "Smoke weed", detail: "Suppress REM sleep, suppress memory, stop thinking", category: .event),
        FlowStep(label: "Sleep with nightmares", detail: "Or without, if enough weed", category: .event),
        FlowStep(label: "Wake up crying", detail: "Loop resets. Same thing tomorrow.", category: .crisis),
    ]

    static let thenItems: [ThenNowItem] = [
        ThenNowItem(text: "No autism diagnosis"),
        ThenNowItem(text: "No therapist"),
        ThenNowItem(text: "Mental breakdown"),
        ThenNowItem(text: "Self-harm starting"),
        ThenNowItem(text: "Relationship ending"),
        ThenNowItem(text: "No direction"),
    ]

    static let nowItems: [ThenNowItem] = [
        ThenNowItem(text: "Autism dx, PWD pending"),
        ThenNowItem(text: "Therapy with Amanda"),
        ThenNowItem(text: "Gym daily, hitting PRs"),
        ThenNowItem(text: "Studying calc + bio"),
        ThenNowItem(text: "Building real projects"),
        ThenNowItem(text: "Planning university on the Island"),
    ]

    static let progressTrackers: [ProgressItem] = [
        ProgressItem(label: "Nightmares", value: 0.2, direction: "flat", detail: "still frequent"),
        ProgressItem(label: "Self-awareness", value: 0.85, direction: "up", detail: "high"),
        ProgressItem(label: "Physical health", value: 0.8, direction: "up", detail: "strong"),
        ProgressItem(label: "Social connections", value: 0.1, direction: "down", detail: "very low"),
        ProgressItem(label: "Housing stability", value: 0.5, direction: "flat", detail: "uncertain"),
        ProgressItem(label: "Academics", value: 0.95, direction: "up", detail: "strong"),
    ]

    static let radarDimensions: [RadarDimension] = [
        RadarDimension(label: "Physical", value: 0.8),
        RadarDimension(label: "Academics", value: 0.95),
        RadarDimension(label: "Creative", value: 0.85),
        RadarDimension(label: "Emotional", value: 0.3),
        RadarDimension(label: "Social", value: 0.05),
        RadarDimension(label: "Financial", value: 0.15),
    ]

    static let timeline: [TimelineEntry] = [
        TimelineEntry(year: "1999", text: "Born", detail: nil, category: .forward),
        TimelineEntry(year: "~2001", text: "Earliest memory: dad hitting me at age 2", detail: "Physical aggression until preschool. Verbal aggression continues for years.", category: .crisis),
        TimelineEntry(year: "2007", text: "ADHD diagnosis (age 8)", detail: nil, category: .event),
        TimelineEntry(year: "2008", text: "First Disneyland trip (age 8)", detail: "Florida and Hawaii trips throughout 2010 to 2020. Hawaii again Feb 2026.", category: .forward),
        TimelineEntry(year: "~2014", text: "Met a girl online. First serious relationship.", detail: nil, category: .event),
        TimelineEntry(year: "2017", text: "Prom (age 18). NYC trip.", detail: nil, category: .event),
        TimelineEntry(year: "2019", text: "Second relationship (Sept to Dec). Pregnancy. Abortion.", detail: "Breakup. Both moved back in with parents.", category: .crisis),
        TimelineEntry(year: "~2021", text: "Fallout with dad. Verbal aggression finally stops.", detail: "Longest relationship ends (age 22 to 23). Self-harm begins. Mental breakdown.", category: .crisis),
        TimelineEntry(year: "2024", text: "Homeless for several months (summer 2024)", detail: "Lived in car until it broke down. AirBnB. Detained by police. Hospitalized. Eventually allowed back home.", category: .crisis),
        TimelineEntry(year: "Oct 2025", text: "Autism diagnosis. Applied for PWD.", detail: nil, category: .event),
        TimelineEntry(year: "2026", text: "Age 26. Living in Langley. Therapy with Amanda.", detail: "Planning move to Vancouver Island. Studying calc + bio.", category: .forward),
    ]

    static let sections: [LifeSection] = [
        // 0
        LifeSection(label: "Early Childhood & Family", paragraphs: [
            "The biggest problem in my life is what happened when I was a kid. My dad hit me from when I was a toddler until around preschool age. My earliest memory is him hitting me when I was around 2. I genuinely cannot find a way to accept or make sense of hitting a child that young, someone who doesn't even understand language yet. I've tried and I can't. The verbal aggression and intimidation continued for years after the hitting stopped, roughly until about 5 years ago. We had to call the police on him once or twice when I was younger because he was so aggressive. Throwing chairs, slamming doors. That was maybe 5 to 10+ years ago now.",
            "My mom didn't just watch. She used it as a weapon. \"You better listen or your dad will hit you.\" She actively threatened me with his violence and framed the whole thing as being for my own good, which she kept saying well into my adult years until I was old enough to actually argue back. She condoned it intentionally. Because of both of them I don't think I'll ever be able to fully trust anyone. My dad acted and my mom weaponized it. Both of them are responsible.",
            "My parents also argued constantly growing up. They only really stopped in the last few years after they realized the arguments were never going anywhere.",
            "My dad hasn't been aggressive in about 5 years. Things eventually got bad enough that they stopped trying to control my life. They're in their 50s now, everyone is mostly fine day to day. Things are calm. But years of fear and intimidation don't just disappear because the house got quieter.",
            "It's generational. My grandpa is 80 with dementia and still cries about his dad beating him as a kid. Three generations of it. The pattern doesn't break on its own.",
            "I've talked to more therapists than the rest of my family put together and I still carry a lot of shame from those early years. Not just anger at him but shame about myself, like something I internalized back then that never really left. Being autistic makes it worse. The memories don't fade the way they might for other people. They replay with the same intensity 20+ years later. I'm not trying to get anything over on him or use it for points. It just genuinely still hurts all the time.",
            "Research from Harvard (Cuartas et al., 2021) found that hitting a child activates the same threat-response regions in the brain as more severe physical abuse. There were no regions of the brain where the neural response differed between kids who were spanked and kids who were abused. A separate study (Tomoda et al., 2009) found that harsh corporal punishment was associated with a 19% reduction in prefrontal cortex gray matter volume, the same regions that show damage in sexual abuse victims. And Teicher & Samson (2016) in Nature Reviews Neuroscience found that the brain's stress-response architecture does not meaningfully distinguish between being hit and being sexually abused. The neurological effects overlap significantly.",
        ], note: "Sources: Cuartas et al. (2021), Child Development. Tomoda et al. (2009), NeuroImage. Teicher & Samson (2016), Nature Reviews Neuroscience. Gershoff (2016), Family Relations."),

        // 1
        LifeSection(label: "Intrusive Memories, Nightmares, and Shame", paragraphs: [
            "The intrusive thoughts are constant. All day, every day. Nightmares almost every night unless I smoke enough weed to suppress REM sleep. The nightmares are hard to describe. Abstract, recurring, almost always the same theme. Running away from people, or people running away from me. Triggers are everywhere: seeing my family, being alone at night when the masking drops, specific reminders like places or conversations, and sometimes completely random with no pattern at all.",
            "There is one specific dream I have had since I was about five. Once or twice a month. Always corridors. I'm chasing a faceless figure. When I catch them they turn around and it's me. Then they start chasing me. No exit, just the reversal. It was there at five and it's still there now. Some mornings I'm not sure if I'm relieved or disappointed to be awake.",
            "The shame isn't as simple as \"I deserved it.\" It's deeper than that, harder to put into words. It's a full-body thing, like something got wired wrong early on and never corrected itself. It runs in the background constantly. The good stuff, family trips, being taken care of, it exists, but it doesn't override the early stuff. If my dad gave me a billion dollars it wouldn't change it.",
        ], note: nil),

        // 2 - NEW: Anger & Conflict
        LifeSection(label: "Anger & Conflict", paragraphs: [
            "I usually just talk through disagreements. I'll discuss my opinion until we've both had a chance to talk. I don't usually get upset or angry during an argument. If I feel overwhelmed I leave. Then maybe I'll cry about it later or get angry on my own but I keep composure when I'm talking with people. It's pretty similar with family versus everyone else.",
        ], note: nil),

        // 3 - NEW: Sleep
        LifeSection(label: "Sleep", paragraphs: [
            "I sleep from midnight to 8am or 4am to 11am, give or take. Nightmares just about every night. I smoke weed chronically to get rid of them. My dad hit me probably 3 to 5 times when I was a kid and that was enough to ruin my life. I have PTSD from something that happened 20+ years ago that he doesn't care about. He lives in the house that he pays for and I'm basically a guest.",
        ], note: nil),

        // 4
        LifeSection(label: "Siblings", paragraphs: [
            "I have younger siblings. I've never had any real issues with any of them. They're all pretty easygoing. We have a good relationship.",
        ], note: nil),

        // 5
        LifeSection(label: "Extended Family", paragraphs: [
            "My maternal grandma is probably the most stable person in my life. My maternal grandpa has dementia and cancer. On my dad's side, his mom passed away around the COVID era. She always scared me more than any bully or even my dad himself, for reasons I can't fully explain. My dad's dad is a nice guy, probably the only person who seems more neurotic or anxious than I am.",
        ], note: nil),

        // 6
        LifeSection(label: "Pets & Loss", paragraphs: [
            "I had a French Bulldog briefly but had a mental breakdown and got rid of it. My family has a few dogs and we lost one recently. My dad's mom dying around the same period as COVID and the homelessness added to everything piling up at once.",
        ], note: nil),

        // 7 - NEW: Grief & Accumulated Loss
        LifeSection(label: "Grief & Accumulated Loss", paragraphs: [
            "I've lost everything in the last 5 to 6 years. Girlfriend, money, car, dog, etcetera. The losses often come all at once, piling on together very quickly. I don't process them one at a time. They stack.",
        ], note: nil),

        // 8
        LifeSection(label: "School", paragraphs: [
            "Started high school in honours. Halfway through grade 10 I switched to a more social track, made a few friends, and stopped taking academics as seriously. Some bullying along the way but nothing that stands out as the defining issue. School was fine. It just wasn't where the real damage was happening.",
        ], note: nil),

        // 9
        LifeSection(label: "Religion", paragraphs: [
            "I was raised Christian. Forced. Church, prayers, the whole thing. I rejected it.",
        ], note: nil),

        // 10
        LifeSection(label: "ADHD and Autism", paragraphs: [
            "I was diagnosed with ADHD when I was 8. I was diagnosed with autism in October 2025 as an adult. My family never really suspected it and I only started figuring it out myself a few years ago. I'm currently waiting to hear back about the Persons With Disabilities (PWD) program in BC. Still waiting as of March 2026, which apparently is pretty normal given how slow the system is.",
        ], note: nil),

        // 11 - NEW: Sensory Profile
        LifeSection(label: "Sensory Profile", paragraphs: [
            "I have trichotillomania. I twirl my hair so much I pull it out. When I was younger my mom carried me around and I'd play with her hair. Conditioner makes hair soft and apparently it's a non-sexual sensory thing. I looked it up.",
            "I don't like loud noises, never have. I get overwhelmed when four or five people are talking at once in groups. I don't know who I'm supposed to be talking to, which group I'm supposed to be part of, which thread to follow. I can do it with computer memory because it's all indexed with numbers and hashes but with humans it's exceptionally difficult.",
            "I wash my hands a lot, always have since about age 5 to 7. Like 10+ times a day. Probably OCD. I rub my feet together when I fall asleep. I cry when I wake up and when I fall asleep. That's sort of my defining feature. Everything stimulates me, so I smoke copious amounts of weed so nothing stimulates me. Then when it wears off I get overwhelmed.",
        ], note: nil),

        // 12 - NEW: Masking & Burnout
        LifeSection(label: "Masking & Burnout", paragraphs: [
            "I'm masking about half the day. The other half I get to sit in my room and code or do homework. I would prefer to do that all day but ADHD and I have to go out and eat and talk to people. When the mask drops at night that's when the crying and the overwhelm hits.",
        ], note: nil),

        // 13
        LifeSection(label: "Medication", paragraphs: [
            "I was briefly put on ADHD medication as a child, maybe a few months to a year at most. I'm considering retrying ADHD medication now as an adult. The only other medication I've taken is sertraline (low dose), which I've been on for about 5 to 6 months on and off as of March 2026.",
        ], note: nil),

        // 14
        LifeSection(label: "Previous Therapy", paragraphs: [
            "My first therapist was Dr. Chapman at Vancouver Children's Hospital when I was around 8. My dad brought us. After that I lost count. I've talked to more therapists than the rest of my family combined. None of them stuck long enough to make a lasting difference. Amanda is the current one. My parents pay for the sessions.",
        ], note: nil),

        // 15
        LifeSection(label: "Relationships", paragraphs: [
            "I had a few relationships in my late teens and early twenties. The first serious one was with a girl I met online around 2014 who came to my prom in 2017. My parents flew me to NYC that same year to meet her. Probably the best week of my life. I think back on it so fondly that it makes everything else feel worse by comparison.",
            "The one that still affects me the most was someone I was with from April to December 2019. We moved in together and she got pregnant. The abortion was my decision initially. It was mutual but I pushed for it because neither of us could afford it. She developed psychosis and pulled knives on me. It broke us up. We both moved back in with our parents. The abortion is probably the second most confusing and painful thing that has happened in my life, right after what happened with my dad when I was little.",
            "My longest relationship was from roughly age 21 to 23. When that ended I had a mental breakdown and the self-harm started.",
            "I'm not in a relationship right now and I don't see myself getting into one anytime soon. Past relationships left damage that I'm still dealing with years later. I haven't been able to make one last longer than about 3 years. Right now I'd rather focus on getting my own life sorted out first.",
        ], note: nil),

        // 16 - NEW: Trust & Attachment
        LifeSection(label: "Trust & Attachment", paragraphs: [
            "I'm standoffish at first because of the autism but not too bad. I like meeting people. I met a new guy waiting for the bus the other day. Nervous but open. I don't assume the worst of people, I usually assume the best until they let me down or disappoint me which is probably easy to do. I give people a few chances. I let people get close usually.",
            "The distrust comes from my parents and a history of people just moving away or leaving after a certain amount of time. It's not that I don't try. People just go.",
        ], note: nil),

        // 17
        LifeSection(label: "Sexuality", paragraphs: [
            "I'm straight. I had one gay interaction with an old friend that made me feel grossed out. I have gay friends but most if not all of them have come onto me at some point, which doesn't just turn me off but genuinely disgusts me. Worth noting for the trust and boundaries stuff.",
        ], note: nil),

        // 18 - NEW: Boundaries
        LifeSection(label: "Boundaries", paragraphs: [
            "I absolutely cannot set boundaries. Not even a question. I have a hard time saying no. Can't set them at home either. I can't name a single boundary I've tried to set that actually worked. They mostly just get ignored.",
        ], note: nil),

        // 19
        LifeSection(label: "Friendships", paragraphs: [
            "I lost most of my friends around 2020. My best friend stuck around and still calls me, but he moved to Vancouver Island a year or two ago. He's visited once in two years. We've drifted apart. It felt like losing the last person who was actually around.",
            "My oldest friend Alex and I talked for almost two hours recently about the usual stuff, the future, intelligence, how most people are not applying themselves. Then he started arguing parents should hit their kids more, that his dad throwing him on the couch at 12 was good discipline. Biggest disagreement we have ever had. Kinda bummed me out. I had to laugh a bit because what he described is nothing compared to what I went through at two, and what I went through is nothing compared to my grandpa at 80 still crying about his dad. Hard to hear someone argue it builds character.",
            "Another friend, Ben, deactivated his Twitter recently. Was going to send him something. No way to reach him now. People just disappear.",
        ], note: nil),

        // 20
        LifeSection(label: "Housing", paragraphs: [
            "In summer 2024 I was homeless for several months after things got bad at home with my family. I lived in a car I had recently purchased until it broke down on me. My parents moved me into an AirBnB for a few months until they let me move back in. I don't know why I was kicked out. I don't know what made them let me back in or what I said. The uncertainty around housing and family trust goes all the way back. Feeling safe at home has never been a given for me. His garage door business, Best Choice Garage Doors, has run advertisements using a photo of me taken when I was around ten, without any agreement or compensation.",
            "My parents have called the police on me a few times too. The worst one was during the same period. My dad called the police on me during a self-harm episode. I opened the door and they chased me through the house. I slipped in the kitchen. They arrested me by kneeling on my back, handcuffed me, and brought me to the hospital where I was kept overnight in solitary confinement. They let me out before the end of the next day. The handcuffs left a scar on my wrist that's still there.",
        ], note: nil),

        // 21
        LifeSection(label: "Mental Health", paragraphs: [
            "My depression and suicidal thoughts don't feel like something I live with constantly in the sense that I'm always visibly falling apart. They hit out of nowhere. I can get through a whole day fine, keep it together, and then fall apart at night. A lot of it has to do with masking all day, autism, emotions, everything, and then losing it when I'm alone. Sleep is inconsistent, anywhere from 4 to 8 hours.",
            "Suicidal thoughts have been there since I was a kid, basically since I can remember. I've made a few attempts, nothing super lethal, more impulsive than planned. The self-harm started around age 22 to 23 after my longest relationship ended. Punching myself in the head. Most recent hospitalization was summer 2024, around the same time I was homeless. I also went to rehab twice in the last few years at Ravensview (Homewood) on Vancouver Island.",
            "I've been smoking weed since I was a teenager. It's escalated over the years to heavy daily use, multiple times a day to suppress memory. I also vape. I drink occasionally but it's not a major thing.",
            "I gym for an hour or two almost every day and I'm hitting personal bests regularly. The discipline is compounding. I don't eat too badly either. The coping mechanisms are a mix of self-destructive and genuinely healthy. They just coexist.",
            "I don't really hate myself or anybody specifically. It's more of a general frustration. The anger goes both directions, inward as self-harm, outward as snapping at people. The root of it is frustration with how things are, not with any one person.",
        ], note: nil),

        // 22 - NEW: Substances Expanded
        LifeSection(label: "Substances Expanded", paragraphs: [
            "I first smoked weed at 17 at a party. Didn't get it. A few months later I smoked again and it half-deactivated my autism and helped me just relax and stop thinking. Started smoking every day. Still do at almost 27. About 5+ bong tokes every day.",
            "I've tried to cut back a little but not seriously. When I do the bad dreams come back and I get over-stressed about stuff that doesn't matter. Whether weed helps more than it hurts at this point: fifty fifty.",
        ], note: nil),

        // 23 - NEW: Physical Health & Body
        LifeSection(label: "Physical Health & Body", paragraphs: [
            "I feel fine about my body, just tired. Self-harm was because the world is messed up and I had to deal with it. I got hit by a car, couldn't work for years, stole from my family, was kicked out, lived in my car. It was a very weird situation that's hard to explain years later. It's certainly not solely my fault. I was born like this and have not gotten along great with my family for years.",
            "I love myself. I wouldn't hurt myself on purpose. People around me obviously hurt me very badly. I didn't intentionally hurt myself. I gym every single day and go as hard as I possibly can about 75% of the time. I'm not the problem.",
        ], note: nil),

        // 24
        LifeSection(label: "Identity & Worldview", paragraphs: [
            "If someone asks me who I am, I honestly don't have a clear answer. I'm still figuring that out. I know what I'm good at and what I care about, but the bigger picture is still blurry. I recently changed my portfolio from old interests to the work I actually want to do now. Small edit, weirdly personal. It made me admit the center of gravity has moved.",
            "I have read a lot of Jung and some Freud. The dream stuff, the shadow, the idea that you are running from parts of yourself. It resonates more than I expected it to. I did not go looking for it to validate anything. I just kept finding my own patterns described in their work.",
            "My earliest good memories are playing N64 (Diddy Kong Racing, Excitebike), playing at my cousins' house in Kamloops on their Super Nintendo, and playing on our PC when I was very young, before age 10. Screens were the first place I felt safe.",
        ], note: nil),

        // 25 - NEW: Screen Time & Digital Life
        LifeSection(label: "Screen Time & Digital Life", paragraphs: [
            "Screens are still my safe place, no question. The line between coding as real work and coding as avoidance is 50/50, like anything else. Social media is about 40 minutes a day. Whether it helps or hurts is also 50/50.",
        ], note: nil),

        // 26
        LifeSection(label: "Current Life", paragraphs: [
            "I'm 26 and living with my parents in Langley, BC. I'm not working right now. I'm waiting on PWD and welfare. The plan is university first, then a career that actually pays well enough to justify it. I'm not interested in grinding minimum wage jobs that go nowhere. School is going well so far. Pre-Calc: Projects 88%, Unit Tests 100%, Quizzes 94%. Anatomy: Learning Guides 100%, Projects 100%, Unit Exams 97%.",
            "Connection with people is hard for me right now. A typical day is sleeping, smoking weed, vaping, gymming, and coding. It's routine, but it's stable. Was at my mom's birthday recently. Cake and coffee. Went to a doctor's appointment, nothing major. Small stuff that feels normal.",
            "I'm hoping to move to Vancouver Island by the end of 2026 to start school. I spend most of my time coding and gaming. Coding is genuine satisfaction, building something real. Gaming is more escape. Both are flow states that keep me out of my head. The fastest way to not think about yourself is to build something complicated enough to require all your attention. I have done eighteen-hour sessions more than once. It works until it doesn't.",
        ], note: nil),

        // 27 - NEW: Financial Reality
        LifeSection(label: "Financial Reality", paragraphs: [
            "I'm in 5 to 10K of debt. I live with my parents and I don't pay for anything. I couldn't give a fuck about money if I spent a million lifetimes on this planet. There are children being bombed in Gaza. OpenAI is worth 0.8 trillion dollars. Anthropic is worth half that. There are more pressing issues than making money day by day. I live off welfare. I don't care.",
            "I can sell B2B software. My parents will pay for my education, then I can get a job working in AI software engineering for 100K+ a year. It's not hard. I'm 26, I have time.",
        ], note: nil),

        // 28
        LifeSection(label: "Work History", paragraphs: [
            "I've had more jobs than I can count. Mix of getting fired, quitting, and burning out. Nothing lasted longer than about 3 years. The pattern is the same every time: start strong, can't sustain it. I've done Apple licensed tech support at Macinhome and Simply Computing, worked at a few restaurants, among other things.",
        ], note: nil),

        // 29
        LifeSection(label: "Career & Projects", paragraphs: [
            "I want to work in fintech or AI. Wealthsimple and Anthropic are what I'm aiming for. I'm studying calculus and biology and I tend to have a pretty strong memory for things I actually care about.",
            "I've built lots of projects I'm proud of. Around age 16, I co-founded Maybulb (maybulb.com) with some internet friends and built Nimble, a Wolfram Alpha menubar app for macOS. We almost sold it for $10K. The ideas and the building aren't the problem. It's getting the motivation to start in the first place, and then figuring out what's next afterwards.",
        ], note: nil),

        // 30 - NEW: Strengths & What Keeps Me Going
        LifeSection(label: "Strengths & What Keeps Me Going", paragraphs: [
            "I'm genuinely good at STEM. Science, technology, engineering, mathematics. What's kept me alive through the worst of it is my resiliency, my mom, and my possessions. Material stuff matters when everything else is gone.",
            "People who actually know me say I'm kind, benevolent, smart, intelligent, and funny. I'll take it.",
        ], note: nil),

        // 31
        LifeSection(label: "What I Want from Therapy", paragraphs: [
            "Work through what happened growing up. Get the intrusive memories and nightmares to ease up. Understand how all of it affects my relationships. And figure out how to build a more stable life.",
        ], note: nil),
    ]
}
