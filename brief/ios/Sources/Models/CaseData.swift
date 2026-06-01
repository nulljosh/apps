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
    var risk: String = ""
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
    case muni   = "CASE-0003"
    var id: String { rawValue }
    var title: String {
        switch self {
        case .rcmp:   return "Trommel v. AG Canada"
        case .family: return "Trommel v. Trommel"
        case .muni:   return "Baitz v. City of Surrey"
        }
    }
    var subtitle: String {
        switch self {
        case .rcmp:   return "Charter civil · RCMP · Aug 2023"
        case .family: return "Family tort · appropriation, IIMS"
        case .muni:   return "Municipal negligence · slip & fall"
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
    Ground(id: "s8", number: 1, title: "Unreasonable search & seizure", section: "Charter s.8",
           value: "$200–500k", accent: .briefDanger,
           description: "Warrantless entry into a private dwelling on a non-criminal wellness call. Highest-tier s.8 violation under Feeney — the home is the most protected space in Charter jurisprudence. No exigent circumstances doctrine survives close scrutiny here: father present, plaintiff visible at kitchen table, no medical emergency observable from doorway. Subject was fully cooperative at the door: voluntarily discussed approximately 20 tattoos, answered officer questions coherently and amicably for several minutes. Declined only to discuss his family — when asked about his mother, brother, and sister, he didn't engage. Told officers he lived there with his father. That is all. The 911 call was placed by the father following a verbal disagreement — not a crime, not a threat, not an observable medical emergency. A cooperative, lucid subject at their own doorstep cannot ground a Feeney warrant exception.",
           citation: "R v. Feeney, [1997] 2 SCR 13 — warrantless dwelling entry presumptively unreasonable. R v. Godoy, [1999] 1 SCR 311 — limits 911-wellness entry to safety verification only.",
           risk: "AG argues Godoy wellness-call authority justified entry · Counter: Godoy permits safety verification only; Feeney makes warrantless dwelling entry presumptively unreasonable once restraint begins inside the home.",
           openByDefault: true),

    Ground(id: "s9", number: 2, title: "Arbitrary detention", section: "Charter s.9",
           value: "$150–350k", accent: .briefDanger,
           description: "Prone restraint, transport to hospital, overnight hold. No charge laid, no underlying crime. Detention must be authorized by law and not arbitrary — MHA s.28 threshold not met (father testimony defeats apprehension standard). Subject's sole non-compliance was declining to discuss his family when asked about his mother, brother, and sister. He told officers he lived there with his father — nothing more. That is the full extent of the non-cooperation that preceded detention. The 911 call originated from the father following a verbal disagreement between them. No crime. No threat. No observable harm risk. A cooperative, lucid person declining to answer personal family questions does not meet MHA s.28's requirement of a reasonable officer belief of likelihood of harm.",
           citation: "R v. Grant, 2009 SCC 32 — definition of detention. Mental Health Act (BC) s.28 — apprehension requires officer-formed belief of likelihood of harm.",
           risk: "AG argues MHA s.28 belief threshold was met on 911-call context · Counter: Grant requires non-arbitrary detention; subject was cogent and cooperative throughout — discussed ~20 tattoos with officers, declined only to discuss his family when asked — told officers he lived with his father, said nothing more (protected right to silence on personal matters). Father's verbal-argument 911 call plus subject's own cooperative conduct destroy the s.28 apprehension standard."),

    Ground(id: "s7", number: 3, title: "Life, liberty, security of person", section: "Charter s.7",
           value: "$250–600k", accent: .briefDanger,
           description: "Forced antipsychotic medication absent consent and absent meaningful incapacity assessment. Fleming v. Ontario establishes that even validly detained persons retain bodily integrity. Engages physical, psychological, and dignity interests simultaneously.",
           citation: "Fleming v. Ontario, 2019 SCC 45 — bodily integrity protected during state detention. Carter v. Canada, 2015 SCC 5 — s.7 protects against state-imposed physical intervention.",
           risk: "AG argues valid MHA detention lawfully limits s.7 under s.1 · Counter: Fleming holds bodily integrity survives lawful detention; forced antipsychotic medication without capacity assessment is not saved by s.1. AG may further argue high function (daily coding, legal self-study) negates injury · Counter: capacity in unrelated domains does not negate domain-specific litigation incapacity (s.19) or the severity of non-pecuniary PTSD harm — 'no good days since Aug 1, 2023' is the lived measure."),

    Ground(id: "s10b", number: 4, title: "Right to counsel", section: "Charter s.10(b)",
           value: "$50–150k", accent: Color.secondary,
           description: "No caution given at any point of the encounter. Detention triggered s.10(b) immediately under Grant; failure to inform of right to counsel before transport and forced medication compounds every downstream violation.",
           citation: "R v. Suberu, 2009 SCC 33 — s.10(b) attaches on detention without delay.",
           risk: "AG argues no formal arrest means s.10(b) did not attach · Counter: Suberu makes clear s.10(b) attaches on detention without delay — prone restraint was detention and no caution was given at any point."),

    Ground(id: "s12", number: 5, title: "Cruel & unusual treatment", section: "Charter s.12",
           value: "$100–300k", accent: .briefWarn,
           description: "Prone restraint by kneeling on the back created positional asphyxia risk. Forced antipsychotic injection followed by overnight solitary, no family notification, discharge without aftercare. The aggregate satisfies the s.12 grossly disproportionate threshold.",
           citation: "R v. Smith, [1987] 1 SCR 1045 — grossly disproportionate test. R v. Boudreault, 2018 SCC 58 — modern s.12 framework.",
           risk: "AG argues each measure was individually proportionate · Counter: Boudreault assesses s.12 in aggregate; prone restraint plus forced injection plus overnight solitary plus no aftercare satisfies Smith's grossly disproportionate test."),

    Ground(id: "battery", number: 6, title: "Battery & excessive force", section: "common law tort",
           value: "$80–200k", accent: .briefWarn,
           description: "Non-consensual physical contact exceeding any lawful authority. Pre-existing wrist fracture aggravated by restraint — additional special damages head. Standard of force assessed objectively per Anderson; officer notebooks must demonstrate proportionality, and the 30-second contact window per father testimony fails that standard.",
           citation: "Anderson v. Smith, 2010 BCCA — proportionality standard for police use of force.",
           risk: "AG argues force was objectively proportionate · Counter: Anderson requires proportionality to actual conduct; father confirms zero resistance before prone restraint, and the pre-existing wrist fracture aggravation is a separate special-damages head."),

    Ground(id: "falseimp", number: 7, title: "False imprisonment", section: "common law tort",
           value: "$60–180k", accent: .briefWarn,
           description: "Overnight solitary confinement absent lawful authority. Each hour past the s.28 examination window is independently actionable. Combined with hospital MHA Form 4 procedural review — was a Form 1 ever generated, signed, and on what evidentiary basis?",
           citation: "Bird v. The Queen, 2019 SCC 7 — false imprisonment within state custody.",
           risk: "AG argues MHA s.28 authorized the detention · Counter: Bird requires each hour beyond lawful authority to be independently justified; if no Form 1 was generated or the s.28 threshold was unmet, every hour of the overnight hold is actionable."),

    Ground(id: "neginv", number: 8, title: "Negligent investigation", section: "tort — Hill",
           value: "$50–150k", accent: Color.secondary,
           description: "Officers owed a duty of care in investigation. Failure to verify wellness-call basis (911 audio defines this), failure to attempt verbal engagement before physical contact, failure to verify MHA s.28 threshold — all breach the Hill standard. Damages flow from downstream harms.",
           citation: "Hill v. Hamilton-Wentworth Regional Police, 2007 SCC 41 — duty of care in police investigation.",
           risk: "AG argues officers exercised reasonable real-time judgment · Counter: Hill imposes a duty of care; failure to attempt verbal engagement or verify the s.28 threshold before physical contact are discrete breaches causally tied to downstream harms.")
]

let caseFacts: [CaseFact] = [
    CaseFact(key: "Date", value: "August 1, 2023"),
    CaseFact(key: "Time", value: "~11:00 AM"),
    CaseFact(key: "Location", value: "Langley, BC"),
    CaseFact(key: "Department", value: "Langley RCMP, Brookswood"),
    CaseFact(key: "Defendant", value: "AG of Canada"),
    CaseFact(key: "Officers", value: "Two officers — identities unknown, pending ATIP"),
    CaseFact(key: "Witness", value: "Father, in kitchen"),
    CaseFact(key: "Status", value: "Pre-litigation"),
    CaseFact(key: "Wrist injury", value: "Pre-existing fracture aggravated by prone restraint — additional physical harm head", fullWidth: true),
    CaseFact(key: "ICBC claim", value: "MVA claim 2022–2024 (separate matter) — documents pre-existing wrist fracture + pre-incident medical baseline", fullWidth: true),
    CaseFact(key: "Family support", value: "Mother assisted navigating the ICBC claim and this legal process — corroborates s.19 incapacity")
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
    JournalEntry(date: "2026-06-01", text: "Getting better, slowly — but the PTSD still hits hard. Being able to code every day and study law does not mean I am not traumatized by the unlawful actions of the government and police. High function in one part of life is not the absence of injury in another. For the record: my mom helped me navigate all of this — I could not have carried the claim alone."),
    JournalEntry(date: "2026-06-01", text: "For the file: an ICBC claim ran 2022–2024 (a separate motor-vehicle matter). It documents the pre-existing wrist fracture and a pre-incident medical baseline. The PTSD here is causally tied to the August 1, 2023 police incident; any apportionment against the MVA injuries to be separated by independent psychiatric evidence."),
    JournalEntry(date: "2026-05-11", text: "Discovery date established. Formally confirmed RCMP file #2023-25586 (August 1, 2023), began active legal research, retained a lawyer for consultation, and first understood that a civil proceeding under Ward v. Vancouver (City) [2010] 2 SCR 27 — a s.24(1) Charter damages claim — is an available and appropriate remedy. This constitutes discovery under BC Limitation Act s.8(1)(d). Called Paul Kent-Snowsell 3x; callback confirmed May 12. Contemporaneous record created."),
    JournalEntry(date: "2026-05-10", text: "Formal PTSD assessment underway. Building clinical paper trail. Session directly connected current symptoms to the August 1, 2023 incident."),
    JournalEntry(date: "2026-05-20", text: "In ongoing therapy with my regular counsellor over the past several months. Raised EMDR with her; she is supportive and is writing a PTSD letter (diagnosis, causation to August 1, 2023, and period of incapacity) — the s.19 disability anchor under the BC Limitation Act. A separate EMDR clinician we tried once was not a good fit; the regular counsellor remains the treating clinician."),
    JournalEntry(date: "2026-05-06", text: "No good days since August 1, 2023. Every day is affected without exception."),
    JournalEntry(date: "2026-05-05", text: "Wakes with stomach aches and night sweats daily. Coping mechanisms developed in direct response to the trauma."),
    JournalEntry(date: "2026-05-03", text: "Nightmares with recurring themes. Worsened in intensity since the incident."),
    JournalEntry(date: "2026-05-01", text: "Incident replays on loop daily. Functioning prior to August 1, 2023. Significantly affected since."),
    JournalEntry(date: "2026-04-28", text: "Family relationships permanently damaged as a direct result of how police handled the incident.")
]

let caseChecklist: [ChecklistItem] = [
    ChecklistItem(id: 22, label: "PRIORITY: Book Law Society limitation read (1-800-663-1919) — one question: does this survive a limitation strike, yes or no?", priority: .now),
    ChecklistItem(id: 23, label: "Get s.19 letter from current counsellor: PTSD Dx + causation to Aug 1 2023 + period of incapacity", priority: .now),
    ChecklistItem(id: 24, label: "Request GP pre-incident records — establish pre-Aug 2023 baseline functioning", priority: .now),
    ChecklistItem(id: 25, label: "Request ICBC claim file (2022–2024) — wrist fracture records + pre-incident medical baseline", priority: .now),
    ChecklistItem(id: 0, label: "Paul Kent declined May 18 — contact Thomas Harding & Neil Chantler (PK referrals — Degen case)", priority: .now),
    ChecklistItem(id: 1, label: "PTSD assessment started (therapy) — get Dx letter", priority: .now),
    ChecklistItem(id: 2, label: "Body cam footage requested from RCMP", priority: .now),
    ChecklistItem(id: 3, label: "Police report — confirm officer identities via ATIP (names unknown)", priority: .now),
    ChecklistItem(id: 19, label: "RCMP complaint file 2023-XCAP — request copy for record", priority: .now),
    ChecklistItem(id: 4, label: "Hospital discharge records", priority: .now),
    ChecklistItem(id: 5, label: "Pain journal — daily entries", priority: .now),
    ChecklistItem(id: 6, label: "Therapist letter confirming PTSD & causation", priority: .now),
    ChecklistItem(id: 7, label: "CRCC complaint — window likely closed; ask about an extension (RCMP is federal — OPCC is BC municipal only)", priority: .soon),
    ChecklistItem(id: 8, label: "Father witness statement documented", priority: .soon),
    ChecklistItem(id: 9, label: "Incident date confirmed: August 1, 2023 (File #2023-25586)", priority: .now),
    ChecklistItem(id: 10, label: "Hospital name confirmed", priority: .soon),
    ChecklistItem(id: 11, label: "Career & personality impact documented", priority: .soon),
    ChecklistItem(id: 12, label: "Therapist letter: PTSD Dx + period of incapacity re: this claim + causation to Aug 1, 2023", priority: .now),
    ChecklistItem(id: 13, label: "Pin discovery date: when you first understood a civil Charter claim was an appropriate remedy", priority: .now),
    ChecklistItem(id: 14, label: "ATIP filed with RCMP — officer names, notebooks (Form 1624), BWC footage, File #2023-25586", priority: .now),
    ChecklistItem(id: 15, label: "FOI filed with E-Comm 9-1-1 BC — 911 audio + CAD notes (neutralizes Godoy scope argument)", priority: .now),
    ChecklistItem(id: 16, label: "Outreach status: Cameron Ward (declined), Arvay Finlay (declined May 25), Klein (declined — class-action only), BCCLA", priority: .now),
    ChecklistItem(id: 17, label: "PRIORITY: Call Thomas Harding — TLAG 604-635-1330 (Degen $317k, PK referral)", priority: .now),
    ChecklistItem(id: 18, label: "PRIORITY: Call Neil Chantler — 604-424-8454 / neilchantler@chantlerlaw.ca (PK referral)", priority: .now),
    ChecklistItem(id: 20, label: "Contact Dinsley Litigation — Sean Dinsley 604-477-0766 (Maple Ridge, civil litigation + PI)", priority: .now),
    ChecklistItem(id: 21, label: "Call CBA BC Lawyer Referral Service — 604-687-3221 / info@cbabc.org", priority: .soon)
]

let caseLawyers: [Lawyer] = [
    Lawyer(id: "lawsociety", initials: "LS", name: "Law Society of BC — PRIORITY",
           subtitle: "Lawyer Referral Service · paid limitation read · 30-min, then $25",
           tags: [LawyerTag(label: "Limitation opinion", style: .urgent), LawyerTag(label: "Survive a strike?", style: .urgent), LawyerTag(label: "PRIORITY", style: .urgent)],
           phone: "18006631919", phoneNote: nil, email: nil, website: "lawsocietybc.ca"),

    Lawyer(id: "th", initials: "TH", name: "Thomas Harding — PRIORITY",
           subtitle: "Thomas Harding Law Corp (TLAG) · Surrey BC · PK referral · Degen case $317k",
           tags: [LawyerTag(label: "Degen case $317k", style: .good), LawyerTag(label: "RCMP misconduct", style: .good), LawyerTag(label: "PK referral", style: .urgent), LawyerTag(label: "PRIORITY", style: .urgent)],
           phone: "6046351330", phoneNote: nil, email: nil, website: "tlag.ca"),

    Lawyer(id: "nc", initials: "NC", name: "Neil Chantler — PRIORITY",
           subtitle: "Chantler & Company · Vancouver BC · PK referral",
           tags: [LawyerTag(label: "Civil rights", style: .good), LawyerTag(label: "PK referral", style: .urgent), LawyerTag(label: "PRIORITY", style: .urgent)],
           phone: "6044248454", phoneNote: nil, email: "neilchantler@chantlerlaw.ca", website: "chantlerlaw.ca"),

    Lawyer(id: "pk", initials: "PK", name: "Paul G. Kent-Snowsell",
           subtitle: "Kane Shannon & Weiler (KSW) · Surrey BC · Declined May 18 — referred Harding & Chantler",
           tags: [LawyerTag(label: "33 yrs trial", style: .good), LawyerTag(label: "Sued RCMP", style: .good), LawyerTag(label: "Declined May 18", style: .fail)],
           phone: "6045917321", phoneNote: nil, email: "pgkent@kswlawyers.ca", website: nil),

    Lawyer(id: "dl", initials: "DL", name: "DLA Law (Ingrid Eiermann)",
           subtitle: "Vancouver BC · Declined May 15",
           tags: [LawyerTag(label: "Police Misconduct", style: .good), LawyerTag(label: "Wrongful arrest", style: .good), LawyerTag(label: "Declined May 15", style: .fail)],
           phone: "6043276381", phoneNote: nil, email: "Ingrid@dlalaw.ca", website: nil),

    Lawyer(id: "mh", initials: "MH", name: "McQuarrie Hunter LLP",
           subtitle: "Surrey BC",
           tags: [LawyerTag(label: "BC Limitation Act", style: .good), LawyerTag(label: "Discoverability / s.19", style: .good)],
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
           tags: [LawyerTag(label: "Fairy Creek RCMP class action", style: .good), LawyerTag(label: "Charter ss.2/7/8/9", style: .good), LawyerTag(label: "Declined May 25", style: .fail)],
           phone: "6046969928", phoneNote: nil, email: nil, website: "arvayfinlay.ca"),

    Lawyer(id: "kl", initials: "KL", name: "Klein Lawyers",
           subtitle: "1385 W 8th Ave #400 · Vancouver BC · Declined — class-action only",
           tags: [LawyerTag(label: "RCMP class actions", style: .good), LawyerTag(label: "Declined", style: .fail)],
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
           phone: "6046873221", phoneNote: nil, email: "info@cbabc.org", website: nil),

    Lawyer(id: "sd", initials: "SD", name: "Dinsley Litigation",
           subtitle: "Sean Dinsley · Maple Ridge BC · civil litigation & personal injury",
           tags: [LawyerTag(label: "Civil litigation", style: .good), LawyerTag(label: "Personal injury", style: .good)],
           phone: "6044770766", phoneNote: nil, email: "admin@dinsleylawcorp.ca", website: "dinsleylawcorp.ca")
]

let caseScenarios: [Scenario] = [
    Scenario(name: "Best case", description: "Full trial, all heads, Ward functions maximally triggered, punitive granted.", amount: "$2–3M", probability: 0.15, accentColor: .briefGreen),
    Scenario(name: "Strong", description: "Settlement with silence premium, evidence fully assembled, press-capable counsel.", amount: "$1.5–2.5M", probability: 0.30, accentColor: .briefWarn),
    Scenario(name: "Most likely", description: "AG settles to suppress precedent on forced medication + solitary + Charter violations. No underlying crime. Confidentiality clause standard.", amount: "$1.2–1.8M", probability: 0.40, accentColor: Color.secondary),
    Scenario(name: "Limitation pressure", description: "Limitation read comes back weak, or early settlement without litigation momentum. Still a live floor given 8 breaches and no underlying crime.", amount: "$800k–1.2M", probability: 0.15, accentColor: .briefDanger)
]

let damageHeads: [DamageHead] = [
    DamageHead(head: "Charter s.24(1) damages", range: "$200–500k", note: "Ward — compensation + vindication + deterrence"),
    DamageHead(head: "Future earning capacity", range: "$300–600k", note: "Age 26, 35+ working years; vocational economist"),
    DamageHead(head: "General / non-pecuniary", range: "$150–300k", note: "Pain, suffering, loss of dignity, PTSD"),
    DamageHead(head: "Aggravated damages", range: "$100–200k", note: "Deliberate, bad-faith state action"),
    DamageHead(head: "Punitive damages", range: "$100–400k", note: "Egregious conduct, public deterrence"),
    DamageHead(head: "Loss of dignity", range: "$100–200k", note: "Forced medication, solitary, no aftercare"),
    DamageHead(head: "Special / medical, lost income", range: "$50–100k", note: "Treatment, meds, time off, wrist injury"),
    DamageHead(head: "Wrist injury / aggravation", range: "$40–80k", note: "Pre-existing fracture worsened by restraint")
]

let caseComparables: [CaseComparable] = [
    CaseComparable(label: "Ward v. Vancouver City (2010 SCC)", year: "2010", award: "$5k", note: "Charter framework — damages minimal"),
    CaseComparable(label: "Joseph v. Meier (BCSC)", year: "2020", award: "$55k", note: "BC wrongful detention, RCMP"),
    CaseComparable(label: "Elmardy v. TPSB (ONSC)", year: "2019", award: "$130k", note: nil),
    CaseComparable(label: "Degen v. Min. Public Safety (BCSC)", year: "2023", award: "$317k", note: "Canadian floor — Surrey RCMP, PTSD", highlight: true),
    CaseComparable(label: "Wang v. AG Canada (BC RCMP)", year: "2021", award: "Confidential", note: "Kelowna wellness call, dragged/assaulted, officer convicted — RCMP chose to settle", highlight: true),
    CaseComparable(label: "Francis v. Ontario (solitary confinement)", year: "2020", award: "$30M class", note: "Solitary confinement as s.7/s.12 Charter violation — Ontario precedent"),
    CaseComparable(label: "Merlo v. Canada (RCMP class action)", year: "2017", award: "$90–100M", note: "Largest RCMP settlement — establishes RCMP settlement pattern"),
    CaseComparable(label: "BC Prison Solitary Class Action", year: "2026", award: "$60M / ~$88k pp", note: "BC s.12 solitary precedent — per-person baseline for single-night claims", highlight: true),
    CaseComparable(label: "This case (estimated)", year: "—", award: "$1.5M–2.5M", note: "5+ Charter breaches, forced med, solitary, no underlying crime, age 26", highlight: true),
    CaseComparable(label: "Henry v. BC (BCSC)", year: "2016", award: "$8.1M", note: "Largest Canadian single-plaintiff Charter award — wrongful conviction")
]

let caseTimeline: [TimelineStep] = [
    TimelineStep(when: "Now", title: "Get the paid limitation read", description: "Five specialist declines (PK, DLA, Cameron Ward, Arvay, Klein) is the market's answer on viability. Book a paid Law Society limitation read (1-800-663-1919) — one question: does this survive a strike? Stop cold-pitching contingency firms until that answer is in hand.", dotStyle: .now),
    TimelineStep(when: "Month 1–2", title: "Evidence gathering", description: "Police report, hospital records, body cam, formal PTSD Dx (in progress), CRCC complaint, ATIP + E-Comm FOI.", dotStyle: .neutral),
    TimelineStep(when: "Month 2–4", title: "Claim filed", description: "Basic deadline expired Aug 1, 2025. If discoverability argument succeeds, file immediately — every day increases risk.", dotStyle: .neutral),
    TimelineStep(when: "Month 6–18", title: "Discovery & negotiation", description: "Evidence exchanged. Settlement talks begin. Federal AG typically prefers quiet settlement.", dotStyle: .warn),
    TimelineStep(when: "Month 12–24", title: "Settlement", description: "~80% of cases settle before trial. Lump sum + confidentiality.", dotStyle: .good),
    TimelineStep(when: "Year 2–4", title: "Trial (if no settlement)", description: "Rare. Longer, riskier, potentially higher payout. Kent has 100+ trials.", dotStyle: .danger)
]

let callScript = """
STATUS UPDATE — May 20, 2026
Paul Kent (KSW) — DECLINED May 18: "Not taking new cases at this time." Referred Thomas Harding & Neil Chantler.
DLA Law (Ingrid Eiermann) — DECLINED May 15: "Not able to assist with your matter."

PRIORITY CONTACTS (PK referrals):
1. Thomas Harding — did the Degen v. Min. Public Safety 2023 BCSC ($317k Surrey RCMP)
2. Neil Chantler — does this type of case

---
COLD CALL SCRIPT — use verbatim

Have ready:
— File #: 2023-25586 (RCMP file, confirmed Aug 1/2023)
— Date of incident: August 1, 2023 (CONFIRMED)
— Officers: two officers, identities unknown — pending ATIP — Langley RCMP, Brookswood
— RCMP complaint file: 2023-XCAP
— Witness: Father — written statement documented May 11, 2026 (in hand)
— PTSD therapy ongoing with regular counsellor — PTSD letter (Dx + causation + incapacity) in progress
— Pre-existing wrist injury (prior fracture) aggravated by prone restraint (special damages)
— Basic 2-yr limitation expired Aug 1, 2025 — lead with this

LEAD QUESTIONS (limitation defense first):
1. Basic limitation expired Aug 1, 2025. Is discoverability (s.8(1)(d)) viable — I didn't know a civil Charter claim was an appropriate remedy until recently?
2. Does PTSD-based incapacity qualify under s.19? What does the therapist letter need to say?
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
3. Arvay Finlay — DECLINED May 25 (Robin Gage, Managing Partner — no capacity)
4. Klein Lawyers — DECLINED (class-action only)

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

The incident involved unlawful entry into my home, excessive force, arbitrary detention, forced antipsychotic medication, and overnight solitary confinement, all without charge. I have been in therapy since August 2025 and am pursuing a formal PTSD diagnosis. The basic 2-year limitation expired August 2025; the claim survives on discoverability and PTSD-based incapacity under the BC Limitation Act.

I've put together a detailed case brief here for your review:
https://heyitsmejosh.com/brief

It covers the alleged Charter breaches (ss. 7, 8, 9, 12), relevant case law, estimated damages, and a full timeline. Based on your background, including prior RCMP litigation and precedent-setting work, I believe you'd be well-suited for this matter.

I'd like to book an in-person consultation at your earliest convenience. Please let me know your availability.

Thank you,
Joshua Trommel
778-201-4533
"""
