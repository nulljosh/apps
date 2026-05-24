import SwiftUI

// MARK: - CASE-0002: Trommel v. Trommel

let familyCaseFacts: [CaseFact] = [
    CaseFact(key: "Plaintiff",      value: "Joshua Trommel"),
    CaseFact(key: "Defendants",     value: "Brian + Christine Trommel"),
    CaseFact(key: "Jurisdiction",   value: "BC Supreme Court"),
    CaseFact(key: "Location",       value: "Langley, BC"),
    CaseFact(key: "Status",         value: "Pre-litigation"),
    CaseFact(key: "Discovery",      value: "May 2026"),
    CaseFact(key: "Deadline",       value: "May 1, 2028"),
    CaseFact(key: "Core claims",    value: "Appropriation of personality · IIMS · parental negligence · battery · wrongful eviction", fullWidth: true)
]

let familyCaseGrounds: [Ground] = [
    Ground(id: "likeness", number: 1, title: "Appropriation of Personality", section: "BC Privacy Act s.3",
           value: "$75–200k", accent: .briefDanger,
           description: "Brian Trommel used Joshua's face and likeness on family business vehicles and advertising without consent. Commercial exploitation for financial gain. Ongoing tort — limitation clock runs from last use date or from May 2026 discovery. Strongest claim on limitation. Photograph every vehicle with timestamps.",
           citation: "BC Privacy Act RSBC 1996 c.373 s.3 · Krouse v. Chrysler Canada Ltd (1973) — appropriation of personality",
           risk: "Defendants argue use was incidental or consented by proximity to the family business · Counter: Krouse holds commercial exploitation without express consent is actionable; ongoing vehicle use keeps limitation running from the last use date.",
           openByDefault: true),

    Ground(id: "iims", number: 2, title: "Intentional Infliction of Mental Suffering", section: "IIMS",
           value: "$100–200k", accent: .briefDanger,
           description: "20+ year pattern of calculated conduct: police weaponized against Joshua at ages 10 and 15 for crying. Eviction from family home into homelessness. Parking lot confrontation while Joshua was homeless — Brian's stated priority was a Yelp review, not his son's welfare. Each act outrageous by any objective standard. PTSD resulted.",
           citation: "Wilkinson v. Downton [1897] 2 QB 57 · Piresferreira v. Ayotte 2010 ONCA 384",
           risk: "Defendants argue conduct was normal parenting · Counter: Piresferreira confirms a sustained pattern satisfies Wilkinson; police weaponized twice, eviction into homelessness, and parking-lot Yelp confrontation collectively reach calculated outrage."),

    Ground(id: "negligence", number: 3, title: "Parental Negligence", section: "Negligence",
           value: "$50–150k", accent: .briefWarn,
           description: "Parents owed a duty of care. Breaches: calling police on a child for crying, evicting an adult child into homelessness with no safety net, using police as a control mechanism. Causation to PTSD and lost earning capacity (age 26, 35+ working years). Psychiatric evidence must separate RCMP PTSD from family PTSD to protect both claims.",
           citation: "Jordan House Ltd v. Menow [1974] SCR 239",
           risk: "Defendants argue parental duty ends at majority · Counter: Jordan House recognizes duty where reliance and vulnerability persist; causation must be separated from RCMP PTSD by independent psychiatric evidence."),

    Ground(id: "battery", number: 4, title: "Battery — Non-Consensual Surgery", section: "Battery",
           value: "$25–75k", accent: Color.secondary,
           description: "Circumcision performed in infancy without capacity for consent. Irreversible bodily modification. BC Limitation Act s.16 suspends limitation during minority — clock started at age 19 (~2019). Discoverability: first understood as actionable May 2026. Novel argument in BC — no direct appellate authority. Include as supplementary, not lead claim.",
           citation: "Malette v. Shulman (1990) 72 OR (2d) 417 · BC Limitation Act s.16",
           risk: "Defendants argue limitation has expired and procedure was standard medical care · Counter: Malette holds non-consensual contact is battery; Limitation Act s.16 suspends the clock during minority, placing start of limitation at approximately age 19."),

    Ground(id: "eviction", number: 5, title: "Wrongful Eviction", section: "Negligence",
           value: "$25–75k", accent: Color.secondary,
           description: "Evicted from the only family home — Joshua's sole shelter. No notice, no transition support. Subsequently located by Brian Trommel in a parking lot while Joshua was homeless. Brian's stated priority: a Yelp review. That confrontation while homeless is the IIMS centerpiece. Special damages: shelter costs, lost income during homeless period.",
           citation: "Parental duty of care · special damages causation",
           risk: "Defendants argue adults have no right to remain in a parent's home · Counter: parental duty survives financial dependence; the homeless parking-lot confrontation with Yelp as stated priority corroborates breach and causation for special damages.")
]

let familyCaseWitnesses: [Witness] = []

let familyCaseLawyers: [Lawyer] = [
    Lawyer(id: "lawsociety-f", initials: "LS", name: "Law Society of BC",
           subtitle: "Lawyer Referral Service · 30-min free, then $25",
           tags: [LawyerTag(label: "Civil tort referrals", style: .good), LawyerTag(label: "Find a specialist", style: .good)],
           phone: "18006631919", phoneNote: nil, email: nil, website: "lawsocietybc.ca"),

    Lawyer(id: "bccla-f", initials: "BC", name: "BCCLA Referral Line",
           subtitle: "BC Civil Liberties Association",
           tags: [LawyerTag(label: "Free referrals", style: .good), LawyerTag(label: "Civil rights", style: .good)],
           phone: "6046872919", phoneNote: nil, email: nil, website: "bccla.org"),

    Lawyer(id: "slater-vecchio", initials: "SV", name: "Slater Vecchio LLP",
           subtitle: "Vancouver BC · Civil litigation, personal injury",
           tags: [LawyerTag(label: "Tort claims", style: .good), LawyerTag(label: "Personal injury", style: .good)],
           phone: nil, phoneNote: nil, email: nil, website: "slatervecchio.com"),

    Lawyer(id: "harper-grey", initials: "HG", name: "Harper Grey LLP",
           subtitle: "Vancouver BC · Civil litigation",
           tags: [LawyerTag(label: "Civil tort", style: .good), LawyerTag(label: "Intentional torts", style: .good)],
           phone: nil, phoneNote: nil, email: nil, website: "harpergrey.com"),

    Lawyer(id: "watson-goepel", initials: "WG", name: "Watson Goepel LLP",
           subtitle: "Vancouver BC · Civil litigation",
           tags: [LawyerTag(label: "Civil tort", style: .good), LawyerTag(label: "Limitation Act exp.", style: .good)],
           phone: nil, phoneNote: nil, email: nil, website: "watsongoepel.com")
]

let familyCaseTimeline: [TimelineStep] = [
    TimelineStep(when: "Now", title: "Find civil tort counsel",
                 description: "Law Society referral: 1-800-663-1919. Ask for tort / intentional harm / appropriation of personality. NOT Charter — different practice area.",
                 dotStyle: .now),
    TimelineStep(when: "Week 1–2", title: "Evidence gathering",
                 description: "Photograph every vehicle with likeness. Screenshot online presence. Write precise dates for all incidents. Preserve texts, emails, voicemails from parents.",
                 dotStyle: .neutral),
    TimelineStep(when: "Month 1–2", title: "Limitation analysis with counsel",
                 description: "Lawyer must assess which claims survive limitation. Discoverability formally documented. Pin May 2026 as discovery date.",
                 dotStyle: .neutral),
    TimelineStep(when: "Month 2–6", title: "Demand letter",
                 description: "Without-prejudice demand to both defendants. Outlines claims, limitation basis, settlement figure. Sets negotiation clock.",
                 dotStyle: .warn),
    TimelineStep(when: "Month 6–18", title: "File or settle",
                 description: "Most civil cases settle once counsel retained and demand delivered. Parents own $1M+ home — judgment can be registered against title in BC.",
                 dotStyle: .good),
    TimelineStep(when: "May 1, 2028", title: "Hard deadline",
                 description: "2-year basic limitation from May 2026 discovery. Must file or have documented discoverability argument before this date.",
                 dotStyle: .danger)
]

let familyCaseChecklist: [ChecklistItem] = [
    ChecklistItem(id: 100, label: "Photograph all vehicles / materials with your likeness — timestamp every photo", priority: .now),
    ChecklistItem(id: 101, label: "Screenshot online presence (website, social, Google My Business) using your image", priority: .now),
    ChecklistItem(id: 102, label: "Write precise timeline of the homelessness period (dates, locations, anyone who saw it)", priority: .now),
    ChecklistItem(id: 103, label: "Preserve texts, emails, voicemails from parents re: eviction, parking lot, Yelp", priority: .now),
    ChecklistItem(id: 104, label: "Find or reconstruct the Yelp review and any response from your father", priority: .now),
    ChecklistItem(id: 105, label: "Document approximate dates of police calls at ages 10 and 15 (any incident numbers)", priority: .soon),
    ChecklistItem(id: 106, label: "Identify witnesses to the homelessness period or parking lot confrontation", priority: .soon),
    ChecklistItem(id: 107, label: "Get therapy records documenting psychological harm from family (separate from RCMP)", priority: .soon),
    ChecklistItem(id: 108, label: "Research family business: name, registration, revenue (bcregistry.gov.bc.ca)", priority: .soon),
    ChecklistItem(id: 109, label: "Pin discoverability date: formal written record — May 2026 = when you understood these as legal claims", priority: .now),
    ChecklistItem(id: 110, label: "Contact Law Society BC referral (1-800-663-1919) — ask for civil tort specialist", priority: .now),
    ChecklistItem(id: 111, label: "Audit digital footprint (social media, public posts) — anything that could be used against you", priority: .soon)
]

let familyCaseScenarios: [Scenario] = [
    Scenario(name: "Best case",    description: "Full trial, all heads viable, punitive granted. Parents settle to avoid public judgment.", amount: "$1.5–2M",    probability: 0.10, accentColor: .briefGreen),
    Scenario(name: "Strong",       description: "Likeness + IIMS survive limitation. Settlement with real leverage.",                      amount: "$700k–1.2M", probability: 0.25, accentColor: .briefWarn),
    Scenario(name: "Most likely",  description: "Likeness + recent IIMS survive. Childhood claims used for damages context only.",         amount: "$300k–600k", probability: 0.45, accentColor: Color.secondary),
    Scenario(name: "Worst",        description: "Limitation kills most claims. Parents have assets but settle minimally.",                  amount: "$0–100k",    probability: 0.20, accentColor: .briefDanger)
]

let familyDamageHeads: [DamageHead] = [
    DamageHead(head: "Appropriation of personality (ongoing)", range: "$75–200k",  note: "Strongest — cleanest limitation"),
    DamageHead(head: "IIMS — pattern of conduct",             range: "$100–200k", note: "Needs psychiatric proof of illness"),
    DamageHead(head: "Parental negligence — PTSD",            range: "$50–150k",  note: "Must split from RCMP PTSD"),
    DamageHead(head: "Lost earning capacity",                  range: "$100–300k", note: "Age 26, 35+ working years"),
    DamageHead(head: "Battery — non-consensual surgery",       range: "$25–75k",   note: "Novel — lead with others"),
    DamageHead(head: "Special (shelter, therapy, lost income)",range: "$25–75k",   note: "Homelessness period"),
    DamageHead(head: "Punitive",                               range: "$25–100k",  note: "Parking lot + ongoing likeness use")
]

let familyCallScript = """
30-SECOND — USE VERBATIM (Law Society referral):
"Hi, my name is Josh Trommel. I'm looking for a civil litigation lawyer with experience in intentional torts and appropriation of personality in BC. I have claims against my parents arising from commercial use of my likeness without consent, intentional infliction of mental suffering over a 20-year period, parental negligence, and wrongful eviction into homelessness. Discovery date is May 2026, basic limitation expires May 2028. I'd like to book a 30-minute consultation."

---

FULL OUTREACH EMAIL:
Subject: Civil Consultation — Appropriation of Personality / IIMS — Trommel

Hi [Name],

My name is Joshua Trommel. I'm seeking a civil litigation lawyer with experience in intentional torts and/or appropriation of personality claims in BC.

I have potential claims against my parents:

1. Commercial use of my face and likeness on family business vehicles without consent — ongoing appropriation of personality tort under BC Privacy Act s.3 and common law.

2. Intentional infliction of mental suffering — documented pattern: eviction into homelessness, police weaponized against me during emotional distress in my youth, and a parking lot confrontation while I was homeless where my father's stated priority was a Yelp review, not my welfare.

3. Parental negligence contributing to documented PTSD.

I have a separate Charter claim against the Attorney General of Canada (RCMP) and understand the limitation issues in both cases.

Discovery date: May 2026. Basic limitation expires May 2028.

Available for consultation at your earliest convenience.

Joshua Trommel
778-201-4533
"""

let familyOutreachEmail = familyCallScript
