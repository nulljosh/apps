import SwiftUI

// MARK: - Types

struct Ground: Identifiable {
    let id: String
    let number: Int
    let title: String
    let section: String
    let value: String
    let accent: Color
    let description: String
    let citation: String
    var openByDefault: Bool = false
}

struct WitnessAnnotation: Identifiable {
    let id = UUID()
    let quote: String
    let note: String
}

struct Witness: Identifiable {
    let id = UUID()
    let initials: String
    let name: String
    let role: String
    let date: String
    let tags: [String]
    let statement: String
    let annotations: [WitnessAnnotation]
}

struct JournalEntry: Identifiable, Codable, Hashable {
    var id: String { date }
    let date: String
    var text: String
}

struct ChecklistItem: Identifiable {
    let id: Int
    let label: String
    let priority: Priority
    enum Priority { case now, soon }
}

enum TagStyle { case good, urgent, fail, neutral }

struct LawyerTag {
    let label: String
    let style: TagStyle
}

struct Lawyer: Identifiable {
    let id: String
    let initials: String
    let name: String
    let subtitle: String
    let tags: [LawyerTag]
    let phone: String?
    let phoneNote: String?
    let email: String?
    let website: String?
}

struct Scenario: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let amount: String
    let probability: Double
    let accentColor: Color
}

struct TimelineStep: Identifiable {
    let id = UUID()
    let when: String
    let title: String
    let description: String
    let dotStyle: DotStyle
    enum DotStyle { case now, warn, good, danger, neutral }
}

struct DamageHead: Identifiable {
    let id = UUID()
    let head: String
    let range: String
    let note: String
}

struct CaseComparable: Identifiable {
    let id = UUID()
    let label: String
    let year: String
    let award: String
    let note: String?
    var highlight: Bool = false
}

struct CaseFact: Identifiable {
    let id = UUID()
    let key: String
    let value: String
    var fullWidth: Bool = false
}

enum CaseID: String, CaseIterable, Identifiable {
    case rcmp   = "CASE-0001"
    case family = "CASE-0002"
    var id: String { rawValue }
    var title: String {
        switch self {
        case .rcmp:   return "Trommel v. AG Canada"
        case .family: return "Trommel v. Trommel"
        }
    }
    var subtitle: String {
        switch self {
        case .rcmp:   return "Charter civil · RCMP · Aug 2023"
        case .family: return "Family tort · appropriation, IIMS"
        }
    }
}

// MARK: - Colors

extension Color {
    static let briefDanger = Color(red: 0.753, green: 0.224, blue: 0.169)
    static let briefWarn   = Color(red: 0.788, green: 0.486, blue: 0.165)
    static let briefGreen  = Color(red: 0.165, green: 0.616, blue: 0.435)
    static let briefAccent = Color(red: 0, green: 0.443, blue: 0.89)
}

extension ShapeStyle where Self == Color {
    static var briefDanger: Color { Color(red: 0.753, green: 0.224, blue: 0.169) }
    static var briefWarn:   Color { Color(red: 0.788, green: 0.486, blue: 0.165) }
    static var briefGreen:  Color { Color(red: 0.165, green: 0.616, blue: 0.435) }
    static var briefAccent: Color { Color(red: 0, green: 0.443, blue: 0.89) }
}

// MARK: - Data

let caseGrounds: [Ground] = [
    Ground(id: "force", number: 1, title: "Excessive Force", section: "s.7",
           value: "$100–200k", accent: .briefDanger,
           description: "Officers knelt on subject's back while prone, causing respiratory distress consistent with positional asphyxia — a documented cause of in-custody death. No crime committed. Officers had post-2020 training and knew this technique is prohibited in low-risk situations. Father witnessed. Subject had a pre-existing wrist injury (prior fracture) that was directly aggravated and reinvigorated by the prone restraint — elevates special damages and supports an independent physical harm head. Aggravated assault causing bodily harm.",
           citation: "Elmardy v. TPSB, 2019 ONSC 2931 ($130k) · Degen v. Min. Public Safety, 2023 BCSC ($317k — Surrey RCMP, PTSD, positional force)",
           openByDefault: true),

    Ground(id: "punitive", number: 2, title: "Punitive Conduct", section: "—",
           value: "$50–150k", accent: .briefWarn,
           description: "Sustained 7-step cascade of misconduct: unlawful entry, physical assault, arrest without grounds, forced medication, solitary confinement, overnight hold, discharge with no aftercare. Each step a choice. Langley RCMP had no MICR/mental health co-responder in August 2023. Officers responded to a psychiatric wellness call with zero psychiatric support. A helping role weaponized into the worst night of the subject's life.",
           citation: "High-handed, bad-faith state action — Ward v. Vancouver [2010] SCC 27"),

    Ground(id: "ptsd", number: 3, title: "PTSD General", section: "—",
           value: "$75–150k", accent: .briefWarn,
           description: "Every day affected since August 1, 2023 — 33+ months of documented daily impact. No good days. Formal PTSD assessment underway May 2026. Clinical paper trail building. Causation to incident expected to be confirmed in writing by treating therapist. Separate from future earning capacity (age 26, 35+ working years — argued independently).",
           citation: "Non-pecuniary damages, ongoing — pain, suffering, loss of dignity"),

    Ground(id: "meds", number: 4, title: "Forced Medication", section: "s.7",
           value: "$30–75k", accent: .briefWarn,
           description: "Involuntary antipsychotics administered without consent. Absolute right to refuse treatment is one of the most fundamental rights in Canadian law. Dual liability: s.7 Charter breach (security of the person) + battery tort. Crown defense — BC MHA s.31 'deemed consent' — is itself under active constitutional challenge as a s.7 violation (CCD v. AG BC, BCSC trial May 2025, decision pending).",
           citation: "Fleming v. Ontario [2019] SCC 45 · CCD v. AG BC (BCSC 2025, pending)"),

    Ground(id: "entry", number: 5, title: "Unlawful Entry", section: "s.8",
           value: "$25–60k", accent: .briefWarn,
           description: "No Feeney warrant. No genuine exigent circumstances — subject answered door, spoke coherently, exercised right to walk away. Entry into a dwelling is the highest-tier s.8 breach. This is the root violation that enabled the entire chain of events that followed.",
           citation: "R. v. Feeney [1997] 2 SCR 13"),

    Ground(id: "detain", number: 6, title: "Arbitrary Detention", section: "s.9",
           value: "$20–50k", accent: Color.secondary,
           description: "Walking away during a non-arrest wellness call is not flight — it is a legal right. Detention began at physical restraint with no lawful authority. Overnight hold with no charge. Mental Health Act apprehension criteria need scrutiny: did the observed behavior legally justify s.28 apprehension?",
           citation: "R. v. Grant [2009] 2 SCR 353"),

    Ground(id: "solitary", number: 7, title: "Solitary Confinement", section: "ss.7,12",
           value: "$15–40k", accent: Color.secondary,
           description: "Overnight solitary confinement with no charge and no crime committed. Subject was in mental health crisis — placing a distressed person in isolation is the clinical opposite of appropriate care. Released with no aftercare plan, no referral to psychiatric services, no follow-up.",
           citation: "Ward v. Vancouver [2010] SCC 27"),

    Ground(id: "counsel", number: 8, title: "Denial of Counsel", section: "s.10(b)",
           value: "$15–35k", accent: Color.secondary,
           description: "Upon detention, Charter s.10(b) requires immediate notification of the right to retain and instruct counsel, and a reasonable opportunity to exercise it. Detention is established at the moment of physical restraint. Once detention is proven, the burden shifts to the Crown to demonstrate s.10(b) was complied with. No compliance = automatic breach.",
           citation: "R. v. Bartle [1994] 3 SCR 173 · R. v. Sinclair [2010] 2 SCR 310")
]

let caseFacts: [CaseFact] = [
    CaseFact(key: "Date", value: "August 1, 2023"),
    CaseFact(key: "Time", value: "~11:00 AM"),
    CaseFact(key: "Location", value: "Langley, BC"),
    CaseFact(key: "Department", value: "Langley RCMP, Brookswood"),
    CaseFact(key: "Defendant", value: "AG of Canada"),
    CaseFact(key: "Officers", value: "Daryl + D. Ryl"),
    CaseFact(key: "Witness", value: "Father, in kitchen"),
    CaseFact(key: "Status", value: "Pre-litigation"),
    CaseFact(key: "Wrist injury", value: "Pre-existing fracture aggravated by prone restraint — additional physical harm head", fullWidth: true)
]

let caseWitnesses: [Witness] = [
    Witness(
        initials: "F",
        name: "Father",
        role: "Eyewitness — present throughout",
        date: "Documented May 11, 2026",
        tags: ["No violence confirmed", "Kneeling corroborated", "Unlawful entry corroborated", "Hospital stonewalled family"],
        statement: """
To the best of my recollection, we were having some trouble with our son Joshua and were concerned about his mental health and wanted the police to come take him to the hospital for a proper wellness check up and hopefully get some help.

I remember the 2 police officers coming to the front door and chatting with us, and then asking Josh some questions to see what was going on. Josh was answering all the questions well, but when they asked him who lived there with him, he answered that he lived there with his dad. He didn't mention his mom or brother or sister. They asked again and when he answered the same way, they looked at me and I shrugged, and waited to see if they were going to bring him to hospital or not, or ask more questions.

It seems they decided that they were going to bring him in, and when they reached for him, he left and went away from the foyer towards the kitchen. They followed him inside and immediately grabbed him aggressively and put him down onto the kitchen floor. I got down by the floor beside him while they put him in handcuffs and kneeled on his back. It looked painful. I was extremely disturbed by how forceful things got quickly, even though he wasn't being violent & I had called them for help. I pleaded with him to not resist them and for them to be careful.

They brought him to hospital after that and I couldn't see him until next day and the hospital wouldn't give me any information… and then they let him out on his own without telling me. I was very very disappointed with how the system failed us and traumatized my son instead of helping him.
""",
        annotations: [
            WitnessAnnotation(quote: "he left and went away from the foyer towards the kitchen",
                              note: "Retreat is not flight. Walking away during a wellness call is a legal right — not grounds for arrest. No threat, no crime."),
            WitnessAnnotation(quote: "immediately grabbed him aggressively",
                              note: "Officers escalated to force instantly. No de-escalation attempt — destroys any good-faith defense."),
            WitnessAnnotation(quote: "put him down onto the kitchen floor … kneeled on his back",
                              note: "Independent corroboration of prone positional restraint. Supports s.7 asphyxia ground and excessive force claim."),
            WitnessAnnotation(quote: "even though he wasn't being violent",
                              note: "Father's direct testimony: zero provocation. Dismantles any exigent-circumstances or officer-safety justification for force."),
            WitnessAnnotation(quote: "I had called them for help",
                              note: "Caller himself was 'extremely disturbed' by the response. Supports punitive/bad-faith ground — a helping role weaponized."),
            WitnessAnnotation(quote: "the hospital wouldn't give me any information … let him out on his own without telling me",
                              note: "Family stonewalled at hospital + discharged without notification. Compounds s.10(b) breach and no-aftercare s.7/s.12 argument.")
        ]
    )
]

let journalSeed: [JournalEntry] = [
    JournalEntry(date: "2026-05-11", text: "Discovery date established. Formally confirmed RCMP file #2023-25586 (August 1, 2023), began active legal research, retained a lawyer for consultation, and first understood that a civil proceeding under Ward v. Vancouver (City) [2010] 2 SCR 27 — a s.24(1) Charter damages claim — is an available and appropriate remedy. This constitutes discovery under BC Limitation Act s.8(1)(d). Called Paul Kent-Snowsell 3x; callback confirmed May 12. Contemporaneous record created."),
    JournalEntry(date: "2026-05-10", text: "Started PTSD therapy today. Formal assessment underway — building the clinical paper trail. First session directly connected current symptoms to the August 1, 2023 incident."),
    JournalEntry(date: "2026-05-06", text: "No good days since August 1, 2023. Every day is affected without exception."),
    JournalEntry(date: "2026-05-05", text: "Wakes with stomach aches and night sweats daily. Coping mechanisms developed in direct response to the trauma."),
    JournalEntry(date: "2026-05-03", text: "Nightmares with recurring themes. Worsened in intensity since the incident."),
    JournalEntry(date: "2026-05-01", text: "Incident replays on loop daily. Functioning prior to August 1, 2023. Significantly affected since."),
    JournalEntry(date: "2026-04-28", text: "Family relationships permanently damaged as a direct result of how police handled the incident.")
]

let caseChecklist: [ChecklistItem] = [
    ChecklistItem(id: 0, label: "Call Paul Kent-Snowsell — book appointment", priority: .now),
    ChecklistItem(id: 1, label: "PTSD assessment started (therapy) — get Dx letter", priority: .now),
    ChecklistItem(id: 2, label: "Body cam footage requested from RCMP", priority: .now),
    ChecklistItem(id: 3, label: "Police report — both Daryls full names", priority: .now),
    ChecklistItem(id: 4, label: "Hospital discharge records", priority: .now),
    ChecklistItem(id: 5, label: "Pain journal — daily entries", priority: .now),
    ChecklistItem(id: 6, label: "Therapist letter confirming PTSD & causation", priority: .now),
    ChecklistItem(id: 7, label: "CRCC complaint filed (RCMP is federal — OPCC is BC municipal only)", priority: .soon),
    ChecklistItem(id: 8, label: "Father witness statement documented", priority: .soon),
    ChecklistItem(id: 9, label: "Incident date confirmed: August 1, 2023 (File #2023-25586)", priority: .now),
    ChecklistItem(id: 10, label: "Hospital name confirmed", priority: .soon),
    ChecklistItem(id: 11, label: "Career & personality impact documented", priority: .soon),
    ChecklistItem(id: 12, label: "Therapist letter: PTSD Dx + period of incapacity re: this claim + causation to Aug 1, 2023", priority: .now),
    ChecklistItem(id: 13, label: "Pin discovery date: when you first understood a civil Charter claim was an appropriate remedy", priority: .now),
    ChecklistItem(id: 14, label: "ATIP filed with RCMP — officer names, notebooks (Form 1624), BWC footage, File #2023-25586", priority: .now),
    ChecklistItem(id: 15, label: "FOI filed with E-Comm 9-1-1 BC — 911 audio + CAD notes (neutralizes Godoy scope argument)", priority: .now),
    ChecklistItem(id: 16, label: "Email outreach sent to: Cameron Ward, Arvay Finlay, Klein Lawyers, BCCLA — email, don't call", priority: .now)
]

let caseLawyers: [Lawyer] = [
    Lawyer(id: "pk", initials: "PK", name: "Paul G. Kent-Snowsell",
           subtitle: "Kane Shannon & Weiler (KSW) · Surrey BC · Of Counsel",
           tags: [LawyerTag(label: "33 yrs trial", style: .good), LawyerTag(label: "Sued RCMP", style: .good)],
           phone: "6045917321", phoneNote: nil, email: "pgkent@kswlawyers.ca", website: nil),

    Lawyer(id: "dl", initials: "DL", name: "DLA Law (Dosanjh Ladner Arora)",
           subtitle: "Vancouver BC",
           tags: [LawyerTag(label: "Police Misconduct", style: .good), LawyerTag(label: "Wrongful arrest", style: .good)],
           phone: "6043276381", phoneNote: nil, email: "Ingrid@dlalaw.ca", website: nil),

    Lawyer(id: "mh", initials: "MH", name: "McQuarrie Hunter LLP",
           subtitle: "Surrey BC",
           tags: [LawyerTag(label: "BC Limitation Act", style: .good), LawyerTag(label: "Discoverability / s.18", style: .good)],
           phone: "6045817001", phoneNote: nil, email: nil, website: nil),

    Lawyer(id: "sh", initials: "SH", name: "Sean Hern Law Corporation",
           subtitle: "Vancouver BC · formerly Farris LLP",
           tags: [LawyerTag(label: "Commercial litigation", style: .good), LawyerTag(label: "Pro bono", style: .good), LawyerTag(label: "BC FOI/Privacy Assoc.", style: .good)],
           phone: "6046849151", phoneNote: nil, email: nil, website: nil),

    Lawyer(id: "cw", initials: "CW", name: "Cameron Ward",
           subtitle: "Cameron Ward & Co · Gastown, Vancouver BC · 40+ yrs",
           tags: [LawyerTag(label: "Ward v. Vancouver SCC", style: .good), LawyerTag(label: "Charter & police misconduct", style: .good)],
           phone: "6046886881", phoneNote: nil, email: "cward@cameronward.com", website: "cameronward.com"),

    Lawyer(id: "af", initials: "AF", name: "Arvay Finlay LLP",
           subtitle: "Vancouver BC",
           tags: [LawyerTag(label: "Fairy Creek RCMP class action", style: .good), LawyerTag(label: "Charter ss.2/7/8/9", style: .good)],
           phone: "6046969928", phoneNote: nil, email: nil, website: "arvayfinlay.ca"),

    Lawyer(id: "kl", initials: "KL", name: "Klein Lawyers",
           subtitle: "1385 W 8th Ave #400 · Vancouver BC · Free consult · Contingency",
           tags: [LawyerTag(label: "RCMP class actions", style: .good), LawyerTag(label: "Federal court", style: .good), LawyerTag(label: "Contingency", style: .good)],
           phone: "6048747171", phoneNote: nil, email: nil, website: "callkleinlawyers.com"),

    Lawyer(id: "pl", initials: "PL", name: "Pivot Legal",
           subtitle: "Vancouver BC · Backup / referrals",
           tags: [LawyerTag(label: "Referral source", style: .good)],
           phone: "6042559700", phoneNote: nil, email: nil, website: nil),

    Lawyer(id: "bc", initials: "BC", name: "BCCLA Referral Line",
           subtitle: "BC Civil Liberties Association",
           tags: [LawyerTag(label: "Free referrals", style: .good), LawyerTag(label: "Civil rights", style: .good)],
           phone: "6046872919", phoneNote: "referral line", email: nil, website: "bccla.org"),

    Lawyer(id: "ar", initials: "AR", name: "Aitken Robertson",
           subtitle: "Vancouver BC",
           tags: [LawyerTag(label: "Police negligence", style: .good), LawyerTag(label: "Charter civil", style: .good)],
           phone: "6043251155", phoneNote: "out of order", email: nil, website: nil),

    Lawyer(id: "cb", initials: "CB", name: "Canadian Bar Association BC",
           subtitle: "Lawyer Referral Service",
           tags: [LawyerTag(label: "Free referrals", style: .good)],
           phone: "6046873221", phoneNote: nil, email: "info@cbabc.org", website: nil)
]

let caseScenarios: [Scenario] = [
    Scenario(name: "Best case", description: "Full trial, all heads, Ward functions maximally triggered, punitive granted.", amount: "$2–3M", probability: 0.15, accentColor: .briefGreen),
    Scenario(name: "Strong", description: "Settlement with silence premium, evidence fully assembled.", amount: "$1.2–1.8M", probability: 0.30, accentColor: .briefWarn),
    Scenario(name: "Most likely", description: "AG settles to suppress precedent. Confidentiality clause standard.", amount: "$800k–1.2M", probability: 0.40, accentColor: Color.secondary),
    Scenario(name: "Worst", description: "Limitation fails OR settles early without leverage.", amount: "$0–350k", probability: 0.15, accentColor: .briefDanger)
]

let damageHeads: [DamageHead] = [
    DamageHead(head: "s.8 dwelling entry (Feeney)", range: "$150–300k", note: "Highest-tier warrant breach"),
    DamageHead(head: "s.9 arbitrary detention", range: "$75–150k", note: "No lawful MHA s.28 threshold"),
    DamageHead(head: "s.7 forced medication (Fleming)", range: "$100–200k", note: "Consent violated"),
    DamageHead(head: "s.7 positional asphyxia risk", range: "$75–150k", note: "Respiratory distress documented"),
    DamageHead(head: "PTSD general (Degen floor $317k)", range: "$317–500k", note: "This head alone exceeds Degen"),
    DamageHead(head: "Future earning capacity (age 26, SWE)", range: "$200–400k+", note: "Vocational economist required"),
    DamageHead(head: "Punitive (bad-faith state action)", range: "$100–300k", note: "No underlying crime"),
    DamageHead(head: "Aggravated", range: "$75–150k", note: "Deliberate, concurrent violations"),
    DamageHead(head: "Special", range: "$50–100k", note: "Treatment, meds, lost income, wrist")
]

let caseComparables: [CaseComparable] = [
    CaseComparable(label: "Ward v. Vancouver City (2010 SCC)", year: "2010", award: "$5k", note: "Charter framework — damages minimal"),
    CaseComparable(label: "Joseph v. Meier (BCSC)", year: "—", award: "$55k", note: "BC wrongful detention, RCMP"),
    CaseComparable(label: "Elmardy v. TPSB (ONSC)", year: "2019", award: "$130k", note: nil),
    CaseComparable(label: "Degen v. Min. Public Safety (BCSC)", year: "2023", award: "$317k", note: "Canadian floor — Surrey RCMP, PTSD", highlight: true),
    CaseComparable(label: "Wang v. AG Canada (BC RCMP)", year: "2021", award: "Confidential", note: "Kelowna wellness call, dragged/assaulted, officer convicted — RCMP chose to settle", highlight: true),
    CaseComparable(label: "This case (estimated)", year: "—", award: "$500k–$800k", note: "5 Charter breaches, forced med, solitary, age 26", highlight: true),
    CaseComparable(label: "Henry v. BC (BCSC)", year: "2016", award: "$8.1M", note: "Largest Canadian single-plaintiff Charter award — wrongful conviction")
]

let caseTimeline: [TimelineStep] = [
    TimelineStep(when: "Now", title: "Call Paul Kent-Snowsell", description: "604-591-7321 (Kane Shannon & Weiler). Book appointment. In-person Surrey.", dotStyle: .now),
    TimelineStep(when: "Month 1–2", title: "Evidence gathering", description: "Police report, hospital records, body cam, formal PTSD Dx (in progress), CRCC complaint, ATIP + E-Comm FOI.", dotStyle: .neutral),
    TimelineStep(when: "Month 2–4", title: "Claim filed", description: "Basic deadline expired Aug 1, 2025. If discoverability argument succeeds, file immediately — every day increases risk.", dotStyle: .neutral),
    TimelineStep(when: "Month 6–18", title: "Discovery & negotiation", description: "Evidence exchanged. Settlement talks begin. Federal AG typically prefers quiet settlement.", dotStyle: .warn),
    TimelineStep(when: "Month 12–24", title: "Settlement", description: "~80% of cases settle before trial. Lump sum + confidentiality.", dotStyle: .good),
    TimelineStep(when: "Year 2–4", title: "Trial (if no settlement)", description: "Rare. Longer, riskier, potentially higher payout. Kent has 100+ trials.", dotStyle: .danger)
]

let callScript = """
CALLBACK PREP — Paul Kent-Snowsell, Kane Shannon & Weiler (KSW)
604-591-7321 · pgkent@kswlawyers.ca
Called · voicemail left

Have ready:
— File #: 2023-25586 (RCMP file, confirmed Aug 1/2023)
— Date of incident: August 1, 2023 (CONFIRMED)
— Officers: Daryl + D. Ryl (Langley RCMP, Brookswood)
— Witness: Father — written statement documented May 11, 2026 (in hand)
— PTSD therapy started May 10, 2026 — formal assessment underway
— Pre-existing wrist injury (prior fracture) aggravated by prone restraint (special damages)
— Basic 2-yr limitation expired Aug 1, 2025 — lead with this

LEAD QUESTIONS (limitation defense first):
1. Basic limitation expired Aug 1, 2025. Is discoverability (s.8(1)(d)) viable — I didn't know a civil Charter claim was an appropriate remedy until recently?
2. Does PTSD-based incapacity qualify under s.18? What does the therapist letter need to say?
3. My discovery date is May 11, 2026 — I have a contemporaneous journal record. Is that defensible under s.8(1)(d)?
4. Can I file a claim now to stop the clock while the limitation argument is developed?

SUBSTANTIVE QUESTIONS:
5. Grounds for s.8, s.7, s.9, s.10(b) Charter claims under Feeney?
6. BC Supreme Court or Federal Court for AG Canada?
7. FOIPPA — right mechanism for officer names, reports, body cam?
8. Expert witness for PTSD damages?
9. Fee structure — contingency or hourly?
10. Have you handled Charter cases with expired basic limitation?

Core facts (30-second version):
August 1, 2023, Langley, ~11am. Wellness call. I answered the door, walked away — my right. Officers entered without warrant, restrained me prone (knelt on back — positional asphyxia risk; also aggravated pre-existing wrist fracture), arrested me, forcibly medicated, held overnight in solitary, released with no aftercare. No crime committed. PTSD since. Father witnessed. File #2023-25586.

OUTREACH — VOICEMAILS NOT WORKING, SWITCH TO EMAIL:

Email first:
1. Cameron Ward — cameronward.com — EMAIL — he is the Ward in Ward v. Vancouver
2. DLA Law — Ingrid@dlalaw.ca — EMAIL — follow up
3. Arvay Finlay — arvayfinlay.ca — EMAIL
4. Klein Lawyers — callkleinlawyers.com — EMAIL

Call also viable:
5. Paul Kent-Snowsell — KSW — 604-591-7321
6. McQuarrie Hunter LLP — 604-581-7001
7. Sean Hern Law Corp — 604-684-9151
8. BCCLA Referral Line — 604-687-2919
9. Pivot Legal — 604-255-9700
10. CBA BC — 604-687-3221 / info@cbabc.org
"""

let outreachEmail = """
Subject: Civil Consultation — Wellness Call / RCMP Charter Claim — Trommel

Hi [Name],

My name is Joshua Trommel. I'm reaching out because I have a potential civil claim arising from a warrantless wellness-call entry by Langley RCMP (Brookswood detachment) in August 2023.

The incident involved unlawful entry into my home, excessive force, arbitrary detention, forced antipsychotic medication, and overnight solitary confinement, all without charge. I have been in therapy since May 2026 and am pursuing a formal PTSD diagnosis. The basic 2-year limitation expired August 2025; the claim survives on discoverability and PTSD-based incapacity under the BC Limitation Act.

I've put together a detailed case brief here for your review:
https://heyitsmejosh.com/brief

It covers the alleged Charter breaches (ss. 7, 8, 9, 12), relevant case law, estimated damages, and a full timeline. Based on your background, including prior RCMP litigation and precedent-setting work, I believe you'd be well-suited for this matter.

I'd like to book an in-person consultation at your earliest convenience. Please let me know your availability.

Thank you,
Joshua Trommel
778-201-4533
"""
