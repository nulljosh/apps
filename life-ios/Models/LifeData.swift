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

enum LifeData {
    static let timeline: [TimelineEntry] = [
        TimelineEntry(year: "1999", text: "Born", detail: nil, category: .forward),
        TimelineEntry(year: "~2001", text: "Earliest memory: dad hitting me at age 2", detail: "Physical aggression until preschool. Verbal aggression continues for years.", category: .crisis),
        TimelineEntry(year: "2007", text: "ADHD diagnosis (age 8)", detail: nil, category: .event),
        TimelineEntry(year: "2008", text: "First Disneyland trip (age 8)", detail: "Florida and Hawaii trips throughout 2010 to 2020. Hawaii again Feb 2026.", category: .forward),
        TimelineEntry(year: "~2014", text: "Met Mikayla online. First serious relationship.", detail: nil, category: .event),
        TimelineEntry(year: "2017", text: "Prom with Mikayla (age 18)", detail: nil, category: .event),
        TimelineEntry(year: "2019", text: "Relationship with Olivia (Sept to Dec). Pregnancy. Abortion.", detail: "Breakup. Both moved back in with parents.", category: .crisis),
        TimelineEntry(year: "~2021", text: "Fallout with dad. Verbal aggression finally stops.", detail: "Longest relationship ends (age 22 to 23). Self-harm begins. Mental breakdown.", category: .crisis),
        TimelineEntry(year: "2024", text: "Homeless for several months (summer 2024)", detail: "Lived in car until it broke down. AirBnB. Detained by police. Hospitalized. Eventually allowed back home.", category: .crisis),
        TimelineEntry(year: "Oct 2025", text: "Autism diagnosis. Applied for PWD.", detail: nil, category: .event),
        TimelineEntry(year: "2026", text: "Age 26. Living in Langley. Therapy with Amanda.", detail: "Planning move to Vancouver Island. Studying calc + bio.", category: .forward),
    ]

    static let sections: [LifeSection] = [
        LifeSection(label: "Early Childhood & Family", paragraphs: [
            "The biggest problem in my life is what happened when I was a kid. My dad hit me from when I was a toddler until around preschool age. My earliest memory is him hitting me when I was around 2. I genuinely cannot find a way to accept or make sense of hitting a child that young, someone who doesn't even understand language yet. I've tried and I can't. The verbal aggression and intimidation continued for years after the hitting stopped, roughly until about 5 years ago. We had to call the police on him once or twice when I was younger because he was so aggressive. Throwing chairs, slamming doors. That was maybe 5 to 10+ years ago now.",
            "My mom didn't just watch. She used it as a weapon. \"You better listen or your dad will hit you.\" She actively threatened me with his violence and framed the whole thing as being for my own good, which she kept saying well into my adult years until I was old enough to actually argue back. She condoned it intentionally. Because of both of them I don't think I'll ever be able to fully trust anyone. My dad acted and my mom weaponized it. Both of them are responsible.",
            "My parents also argued constantly growing up. They only really stopped in the last few years after they realized the arguments were never going anywhere.",
            "My dad hasn't been aggressive in about 5 years. Things got so bad that life started hitting harder than my parents ever could. They also got too old to keep trying to fix my life. They realized everyone's doomed from birth and we're all decaying the second we come out the womb. I had to force that reality on them. Things are calm now, my parents are in their 50s, everyone is mostly fine day to day. But years of fear and intimidation don't just go away.",
            "I've talked to more therapists than the rest of my family put together and I still carry a lot of shame from those early years. Not just anger at him but shame about myself, like something I internalized back then that never really left. Being autistic makes it worse. The memories don't fade the way they might for other people. They replay with the same intensity 20+ years later. I'm not trying to get anything over on him or use it for points. It just genuinely still hurts all the time.",
            "Research from Harvard (Cuartas et al., 2021) found that hitting a child activates the same threat-response regions in the brain as more severe physical abuse. There were no regions of the brain where the neural response differed between kids who were spanked and kids who were abused. A separate study (Tomoda et al., 2009) found that harsh corporal punishment was associated with a 19% reduction in prefrontal cortex gray matter volume, the same regions that show damage in sexual abuse victims. And Teicher & Samson (2016) in Nature Reviews Neuroscience found that the brain's stress-response architecture does not meaningfully distinguish between being hit and being sexually abused.",
        ], note: "Sources: Cuartas et al. (2021), Child Development. Tomoda et al. (2009), NeuroImage. Teicher & Samson (2016), Nature Reviews Neuroscience. Gershoff (2016), Family Relations."),

        LifeSection(label: "Intrusive Memories, Nightmares, and Shame", paragraphs: [
            "The intrusive thoughts are constant. All day, every day. Nightmares almost every night unless I smoke enough weed to suppress REM sleep. The nightmares are hard to describe. Abstract, recurring, almost always the same theme. Running away from people, or people running away from me. Triggers are everywhere: seeing my family, being alone at night when the masking drops, specific reminders like places or conversations, and sometimes completely random with no pattern at all.",
            "The shame isn't as simple as \"I deserved it.\" It's deeper than that. Life itself feels evil. My body feels rejected. My mind is repulsed by my own existence. I feel like I was molested just for existing, never mind hit and yelled at for disobeying before I knew my own name or the language. It plays in my head 24/7 and never ends. The good stuff, family trips, being taken care of, it exists, but it doesn't come close to overriding the early stuff. If my dad gave me a billion dollars it wouldn't change it.",
        ], note: nil),

        LifeSection(label: "Siblings", paragraphs: [
            "I have younger siblings. I've never had any real issues with any of them. They're all pretty easygoing. We have a good relationship.",
        ], note: nil),

        LifeSection(label: "Extended Family", paragraphs: [
            "My maternal grandma is probably the most stable person in my life. My maternal grandpa has dementia and cancer. On my dad's side, his mom passed away around the COVID era. She always scared me more than any bully or even my dad himself, for reasons I can't fully explain. My dad's dad is a nice guy, probably the only person who seems more neurotic or anxious than I am.",
        ], note: nil),

        LifeSection(label: "Pets & Loss", paragraphs: [
            "I had a French Bulldog briefly but had a mental breakdown and got rid of it. My family has a few dogs and we lost one recently. My dad's mom dying around the same period as COVID and the homelessness added to everything piling up at once.",
        ], note: nil),

        LifeSection(label: "School", paragraphs: [
            "Started high school in honours. Halfway through grade 10 I switched to a more social track, made a few friends, and stopped taking academics as seriously. Some bullying along the way but nothing that stands out as the defining issue. School was fine. It just wasn't where the real damage was happening.",
        ], note: nil),

        LifeSection(label: "Religion", paragraphs: [
            "I was raised Christian. Forced. Church, prayers, the whole thing. I rejected it.",
        ], note: nil),

        LifeSection(label: "ADHD and Autism", paragraphs: [
            "I was diagnosed with ADHD when I was 8. I was diagnosed with autism in October 2025 as an adult. My family never really suspected it and I only started figuring it out myself a few years ago. I'm currently waiting to hear back about the Persons With Disabilities (PWD) program in BC. Still waiting as of March 2026, which apparently is pretty normal given how slow the system is.",
        ], note: nil),

        LifeSection(label: "Medication", paragraphs: [
            "I was briefly put on ADHD medication as a child, maybe a few months to a year at most. I'm considering retrying ADHD medication now as an adult. The only other medication I've taken is sertraline (low dose), which I've been on for about 5 to 6 months on and off as of March 2026.",
        ], note: nil),

        LifeSection(label: "Previous Therapy", paragraphs: [
            "My first therapist was Dr. Chapman at Vancouver Children's Hospital when I was around 8. My dad brought us. After that I lost count. I've talked to more therapists than the rest of my family combined. None of them stuck long enough to make a lasting difference. Amanda is the current one. My parents pay for the therapy they necessitated.",
        ], note: nil),

        LifeSection(label: "Relationships", paragraphs: [
            "I had a few relationships in my late teens and early twenties. The first serious one was with Mikayla, who I met online around 2014 and who came to my prom in 2017. My parents flew me to NYC that same year to meet her. Probably the best week of my life. I think back on it so fondly that it makes everything else feel worse by comparison.",
            "The one that still affects me the most is Olivia. We were together from April to December 2019. We moved in together and she got pregnant. The abortion was my decision initially. It was mutual but I pushed for it because neither of us could afford it. She developed psychosis and pulled knives on me. It broke us up. We both moved back in with our parents. The abortion is probably the second most confusing and painful thing that's happened in my life, right after what happened with my dad when I was little.",
            "My longest relationship was from roughly age 21 to 23. When that ended I had a mental breakdown and the self-harm started.",
            "I'm not in a relationship anymore and I never will be again. It's a waste of time and money in trade for trauma and lifelong problems.",
        ], note: nil),

        LifeSection(label: "Sexuality", paragraphs: [
            "I'm straight. I had one gay interaction with an old friend that made me feel grossed out. I have gay friends but most if not all of them have come onto me at some point, which doesn't just turn me off but genuinely disgusts me. Worth noting for the trust and boundaries stuff.",
        ], note: nil),

        LifeSection(label: "Friendships", paragraphs: [
            "I lost most of my friends around 2020. My best friend stuck around and still calls me, but he moved to Vancouver Island a year or two ago out of nowhere. Felt abandoned. He's visited once in two years. I don't really see him anymore and don't really feel like we're friends, or ever were, aside from the fact that he lived a 10-minute walk away in my neighbourhood.",
        ], note: nil),

        LifeSection(label: "Housing", paragraphs: [
            "In summer 2024 I was homeless for several months after things got bad at home with my family. I lived in a car I had recently purchased until it broke down on me. My parents moved me into an AirBnB for a few months until they let me move back in. I don't know why I was kicked out. I don't know what made them let me back in or what I said. That uncertainty is its own source of trauma.",
            "My parents have called the police on me a few times too. The worst one was during the same period. My dad called the police on me during a self-harm episode. I opened the door and they chased me through the house. I slipped in the kitchen. They arrested me by kneeling on my back, handcuffed me, and brought me to the hospital where I was kept overnight in solitary confinement. They let me out before the end of the next day. The handcuffs left a scar on my wrist that's still there.",
        ], note: nil),

        LifeSection(label: "Mental Health", paragraphs: [
            "My depression and suicidal thoughts don't feel like something I live with constantly in the sense that I'm always visibly falling apart. They hit me out of nowhere. I can get through a whole day fine, keep it together, and then completely fall apart at night. A lot of it has to do with masking all day, autism, emotions, everything, and then losing it when I'm alone. Sleep is inconsistent, anywhere from 4 to 8 hours.",
            "Suicidal thoughts have been there since I was a kid, basically since I can remember. I've made a few attempts, nothing super lethal, more impulsive than planned. The self-harm started around age 22 to 23 after my longest relationship ended. Punching myself in the head. Most recent hospitalization was summer 2024, around the same time I was homeless. I also went to rehab twice in the last few years at Ravensview (Homewood) on Vancouver Island.",
            "I've been smoking weed since I was a teenager. It's escalated over the years to heavy daily use, multiple times a day to suppress memory. I also vape. I drink occasionally but it's not a major thing.",
            "I gym for an hour or two almost every day and I'm usually beating my athletic average. I don't eat too badly either. The coping mechanisms are a mix of self-destructive and genuinely healthy. They just coexist.",
            "I don't really hate myself or anybody specifically. It's more existential. I'm frustrated that we're all forced into existence, the system is broken and inefficient, and people are generally too stupid or mean for their own good.",
        ], note: nil),

        LifeSection(label: "Identity & Worldview", paragraphs: [
            "If someone asks me who I am, I honestly have no idea. I think everyone is just a need machine. A stomach and a brain. Most people don't use their brains though, and I don't even bother mentioning a heart.",
            "My earliest good memories are playing N64 (Diddy Kong Racing, Excitebike), playing at my cousins' house in Kamloops on their Super Nintendo, and playing on our PC when I was very young, before age 10. Screens were the first place I felt safe.",
        ], note: nil),

        LifeSection(label: "Current Life", paragraphs: [
            "I'm 26 and living with my parents in Langley, BC. I'm not working. I'm waiting on PWD. I'm waiting until Wednesday for my welfare. I will never work again unless it's after university (age 30+) in a job that pays $100K+. Otherwise no job is remotely worth it.",
            "I feel no connection to human beings. I could do people's bidding all day and it wouldn't make me feel any better about myself. A typical day is sleeping as much as possible, smoking weed, vaping, gymming, and coding.",
            "I'm hoping to move to Vancouver Island by the end of 2026 to start school. I spend most of my time coding and gaming. Coding is genuine satisfaction, building something real. Gaming is more escape. Both are flow states that keep me out of my head.",
        ], note: nil),

        LifeSection(label: "Work History", paragraphs: [
            "I've had more jobs than I can count. Mix of getting fired, quitting, and burning out. Nothing lasted longer than about 3 years. The pattern is the same every time: start strong, can't sustain it. I've done Apple licensed tech support at Macinhome and Simply Computing, worked at a few restaurants, among other things.",
        ], note: nil),

        LifeSection(label: "Career & Projects", paragraphs: [
            "I want to work in fintech or AI. Wealthsimple and Anthropic are what I'm aiming for. I'm studying calculus and biology and I tend to have a pretty strong memory for things I actually care about.",
            "I've built lots of projects I'm proud of. Around age 16, I co-founded Maybulb (maybulb.com) with some internet friends and built Nimble, a Wolfram Alpha menubar app for macOS. We almost sold it for $10K. The ideas and the building aren't the problem. It's getting the motivation to start in the first place, and then figuring out what's next afterwards.",
        ], note: nil),

        LifeSection(label: "What I Want from Therapy", paragraphs: [
            "Work through what happened growing up. Get the intrusive memories and nightmares to ease up. Understand how all of it affects my relationships. And figure out how to build a more stable life.",
        ], note: nil),
    ]
}
