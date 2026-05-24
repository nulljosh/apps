import SwiftUI

// MARK: - CASE-0003: Baitz v. City of Surrey

let muniCaseFacts: [CaseFact] = [
    CaseFact(key: "Plaintiff",       value: "Sylvia Baitz"),
    CaseFact(key: "Defendant",       value: "City of Surrey"),
    CaseFact(key: "Forum",           value: "BC Small Claims / Supreme"),
    CaseFact(key: "Incident date",   value: "[DATE] — confirm immediately"),
    CaseFact(key: "Location",        value: "Main Street, Surrey BC · near intersection"),
    CaseFact(key: "Hazard",          value: "Sunken/uneven sidewalk panel · gravel displaced · raised edge"),
    CaseFact(key: "Injury",          value: "Bilateral knee lacerations · road rash · bandaged, bleeding"),
    CaseFact(key: "Photos",          value: "3 preserved: IMG_9319 (dip close-up), IMG_9320 (scene wide), IMG_9322 (injuries)", fullWidth: true),
    CaseFact(key: "Notice deadline", value: "2 months from incident · Community Charter s.285"),
    CaseFact(key: "Status",          value: "Notice required — urgent")
]

let muniCaseGrounds: [Ground] = [
    Ground(id: "occ", number: 1, title: "Occupiers Liability", section: "BC OLA RSBC 1996 c.337 s.3",
           value: "$4–8k", accent: .briefDanger,
           description: "Municipality is occupier of the sidewalk. Duty to take reasonable care to see that persons on the premises are reasonably safe. The pavement dip is an observable structural hazard; photographic evidence establishes the defect pre-existed the fall.",
           citation: "BC Occupiers Liability Act RSBC 1996 c.337 s.3 · Waldick v. Malcolm [1991] 2 SCR 456",
           risk: "Surrey argues the hazard was open and obvious · Counter: Waldick holds occupiers must address known hazards regardless; elderly plaintiff with altered gait is a foreseeable visitor.",
           openByDefault: true),

    Ground(id: "neg", number: 2, title: "Municipal Negligence", section: "Anns/Cooper — operational failure",
           value: "$3–6k", accent: .briefWarn,
           description: "Post-2021 SCC, municipalities are not immune for operational decisions — daily maintenance failures are actionable. Sunken concrete panel + displaced gravel = operational (not policy) failure. City of Surrey owes a duty of care to pedestrians on its sidewalks.",
           citation: "Nelson (City) v. Marchi, 2021 SCC 41 · Anns/Cooper test — proximity + foreseeability",
           risk: "Surrey invokes policy immunity (budgeting/prioritization) · Counter: Marchi 2021 SCC held operational maintenance failures are not shielded by policy immunity."),

    Ground(id: "notice", number: 3, title: "Mandatory Notice Requirement", section: "BC Community Charter s.285",
           value: "prerequisite", accent: Color.secondary,
           description: "Written notice must be given to the municipality within 2 months of the incident or the claim is barred entirely. Notice must specify date, time, location, and general nature of injury. Send registered mail + email to Surrey City Clerk immediately.",
           citation: "BC Community Charter SBC 2003 c.26 s.285",
           risk: "Missing the 2-month window bars the claim entirely · Send notice before anything else — this is the only truly time-gated step in the entire claim.")
]

let muniCaseWitnesses: [Witness] = []

let muniCaseLawyers: [Lawyer] = [
    Lawyer(id: "lawsociety-pi", initials: "LS", name: "Law Society of BC — PI Referral",
           subtitle: "Lawyer Referral Service · free consult · PI specialists · contingency",
           tags: [LawyerTag(label: "Free consult", style: .good), LawyerTag(label: "PI specialists", style: .good), LawyerTag(label: "Contingency", style: .good)],
           phone: "18006631919", phoneNote: nil, email: nil, website: "lawsocietybc.ca"),

    Lawyer(id: "slater-muni", initials: "SV", name: "Slater Vecchio LLP",
           subtitle: "Vancouver BC · personal injury · municipal claims",
           tags: [LawyerTag(label: "Slip & fall", style: .good), LawyerTag(label: "Municipal liability", style: .good)],
           phone: nil, phoneNote: nil, email: nil, website: "slatervecchio.com"),

    Lawyer(id: "asfs", initials: "AH", name: "Acheson Sweeney Foley Sahota",
           subtitle: "Surrey / Vancouver BC · personal injury",
           tags: [LawyerTag(label: "Surrey local", style: .good), LawyerTag(label: "Municipal liability", style: .good)],
           phone: "6045911777", phoneNote: nil, email: nil, website: nil)
]

let muniCaseChecklist: [ChecklistItem] = [
    ChecklistItem(id: 200, label: "Send written notice to Surrey City Clerk — registered mail + email TODAY", priority: .now),
    ChecklistItem(id: 201, label: "Preserve all 3 photos with date/GPS metadata intact (IMG_9319, 9320, 9322)", priority: .now),
    ChecklistItem(id: 202, label: "Document exact incident date, time, and intersection", priority: .now),
    ChecklistItem(id: 203, label: "GP or walk-in visit — get injury documented on file today", priority: .now),
    ChecklistItem(id: 204, label: "Keep all medical receipts (wound care, physio, meds)", priority: .now),
    ChecklistItem(id: 205, label: "Return to scene — measure dip depth with tape measure, photograph", priority: .soon),
    ChecklistItem(id: 206, label: "Check if hazard was previously reported to Surrey (FOI request)", priority: .soon),
    ChecklistItem(id: 207, label: "Document any missed work, appointments, or activities (dates + amounts)", priority: .soon),
    ChecklistItem(id: 208, label: "Get free consult with PI lawyer — contingency means no upfront cost", priority: .now),
    ChecklistItem(id: 209, label: "Witness contact info — anyone who saw the fall or knows the hazard", priority: .soon)
]

let muniCaseTimeline: [TimelineStep] = [
    TimelineStep(when: "NOW — urgent", title: "Send notice to Surrey",
                 description: "BC Community Charter s.285: written notice within 2 months or claim is barred. Send to Surrey City Clerk: 13450 104 Ave, Surrey BC V3T 1V8. Include: date, location, nature of injury. Registered mail + email.",
                 dotStyle: .now),
    TimelineStep(when: "Week 1–2", title: "Evidence build",
                 description: "Photograph hazard with measuring tape. GP visit for injury on record. Preserve all receipts. Write precise incident account with timestamps.",
                 dotStyle: .neutral),
    TimelineStep(when: "Month 1", title: "Lawyer consult",
                 description: "PI lawyers take these on contingency — no upfront cost. Free consult through Law Society BC (1-800-663-1919) or call Slater Vecchio / ASFS directly.",
                 dotStyle: .neutral),
    TimelineStep(when: "Month 1–3", title: "Demand to Surrey",
                 description: "Lawyer sends without-prejudice demand. Surrey Risk Management typically settles to avoid litigation cost on clear operational failures.",
                 dotStyle: .warn),
    TimelineStep(when: "Month 3–12", title: "Settlement",
                 description: "Most municipal slip-and-falls settle within 6 months. Lump sum covers medical + pain/suffering. No trial needed at this quantum.",
                 dotStyle: .good),
    TimelineStep(when: "2 yrs from incident", title: "Hard limitation",
                 description: "2-year limitation from incident date. Must file BC Supreme Court (or Small Claims under $35k) or have settlement before this date.",
                 dotStyle: .danger)
]

let muniCaseScenarios: [Scenario] = [
    Scenario(name: "Best case",  description: "Bone or joint injury confirmed. Not minor injury classification. Full special damages.", amount: "$20–40k", probability: 0.10, accentColor: .briefGreen),
    Scenario(name: "Likely",     description: "Notice sent. PI lawyer retained. Surrey settles to avoid litigation cost.", amount: "$8–14k",  probability: 0.50, accentColor: .briefWarn),
    Scenario(name: "Floor",      description: "Minor injury cap ($5,500) + out-of-pocket medical only.", amount: "$6–8k",   probability: 0.30, accentColor: Color.secondary),
    Scenario(name: "Worst",      description: "Notice window missed. Claim barred entirely.", amount: "$0",      probability: 0.10, accentColor: .briefDanger)
]

let muniDamageHeads: [DamageHead] = [
    DamageHead(head: "Minor injury — pain & suffering cap",    range: "$3–5.5k", note: "Road rash = minor injury cap"),
    DamageHead(head: "Medical expenses (out of pocket)",       range: "$0.5–2k", note: "Physio, wound care, GP visits"),
    DamageHead(head: "Lost wages / activity",                  range: "$0–3k",   note: "If any work or activities missed"),
    DamageHead(head: "Future medical",                         range: "$0–1.5k", note: "If treatment ongoing")
]

let muniCallScript = """
WRITTEN NOTICE TO SURREY — send immediately, registered mail:

City of Surrey, City Clerk
13450 104 Ave
Surrey, BC V3T 1V8

Re: Notice of Claim — Sidewalk Slip and Fall
Pursuant to: BC Community Charter SBC 2003 c.26, s.285

Claimant: Sylvia Baitz
Incident date: [DATE OF FALL]
Incident location: Main Street (near [CROSS STREET]), Surrey, BC
Nature of injury: Fall caused by sunken/uneven sidewalk panel. Bilateral knee lacerations and abrasions. Ongoing pain and reduced mobility.

The claimant reserves all rights to pursue a civil claim for damages.

Yours truly,
[Signature]
[Date]

---

LAWYER CALL (30 seconds):
"Hi, I'm calling about a slip-and-fall against the City of Surrey. My grandmother Sylvia Baitz fell on a sunken sidewalk panel at Main Street, Surrey in [MONTH] 2026. She has bilateral knee injuries — road rash and lacerations. We have photos of the hazard and injuries. I need to confirm the s.285 notice has gone out and then retain counsel. Do you take municipal slip-and-fall cases on contingency?"
"""
