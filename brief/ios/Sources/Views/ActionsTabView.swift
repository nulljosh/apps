import SwiftUI

struct ActionsTabView: View {
    @Environment(Store.self) private var store
    private var rcmp: Bool  { store.activeCase == .rcmp }
    private var muni: Bool  { store.activeCase == .muni }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    if muni { NoticeCardView() }
                    lawyersSection
                    strategySection
                    timelineSection
                    SectionCard("Evidence checklist", roman: "§13") { ChecklistView() }
                    if rcmp {
                        CallScriptView(text: callScript, title: "Callback prep")
                        CallScriptView(text: outreachEmail, title: "Outreach email")
                        risksSection
                        evidenceGapsSection
                        draftsSection
                        callbackLogSection
                    } else if muni {
                        CallScriptView(text: muniCallScript, title: "Notice draft + lawyer pitch")
                        muniRisksSection
                    } else {
                        CallScriptView(text: familyCallScript, title: "Outreach script")
                        familyRisksSection
                        familyEvidenceSection
                    }
                }
                .padding(.horizontal, 16).padding(.bottom, 32)
            }
            .navigationTitle("Actions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(CaseID.allCases) { c in
                            Button { store.activeCase = c } label: {
                                if store.activeCase == c { Label(c.title, systemImage: "checkmark") }
                                else { Text(c.title) }
                            }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(store.activeCase.rawValue)
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                            Image(systemName: "chevron.up.chevron.down")
                                .font(.system(size: 10))
                        }
                        .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private var lawyersSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Lawyers").font(.system(size:10,weight:.bold)).tracking(1.4).textCase(.uppercase).foregroundStyle(.secondary).padding(.horizontal,4)
            let lawyers: [Lawyer] = {
                switch store.activeCase { case .rcmp: return caseLawyers; case .family: return familyCaseLawyers; case .muni: return muniCaseLawyers }
            }()
            ForEach(lawyers) { LawyerCardView(lawyer: $0) }
        }
    }

    private var muniRisksSection: some View {
        SectionCard("Risks — what Surrey will argue") {
            VStack(alignment:.leading,spacing:10) {
                risk("Notice missed (kill shot).", "If the 2-month window under Community Charter s.285 passes without written notice, the claim is barred — full stop. No lawyer can fix this.", .briefDanger)
                risk("Policy immunity.", "Surrey argues the hazard was a policy/budget decision. Counter: post-Marchi 2021 SCC, operational maintenance failures aren't shielded.", .briefWarn)
                risk("Open and obvious.", "Surrey argues the hazard was visible and plaintiff assumed the risk. Counter: Waldick v. Malcolm holds occupiers must address known hazards regardless.", .briefWarn)
                risk("Minor injury cap.", "Road rash is classified as a minor injury under BC tort law — $5,500 cap on pain/suffering. Get a GP to document any joint or bone involvement to change classification.", .briefWarn)
            }
        }
    }

    private var strategySection: some View {
        SectionCard("Strategy") {
            VStack(alignment: .leading, spacing: 10) {
                if rcmp {
                    Text("Contact at least 3 lawyers before committing to any one. Compare retainer structures — contingency terms vary significantly. Do not sign until all consultations are complete.")
                        .font(.system(size:13)).foregroundStyle(.primary).lineSpacing(3)
                    Text("Basic 2-yr limit expired Aug 1, 2025 — claim survives on discoverability (s.8(1)(d)) and PTSD incapacity (s.18). Therapy start May 2026 supports both. Ultimate deadline: Aug 1, 2038. File as soon as counsel confirms.")
                        .font(.system(size:11,design:.monospaced)).foregroundStyle(.briefWarn).lineSpacing(3).fontWeight(.bold)
                    Text("DECLINED: Paul Kent (KSW) May 18 — not taking new cases. DLA Law (Ingrid) May 15 — not able to assist.\n\nPriority referrals from Kent:\n1. Thomas Harding — did Degen case ($317k Surrey RCMP)\n2. Neil Chantler — does this type of case\n\nStill awaiting:\n3. Cameron Ward — cameronward.com\n4. Arvay Finlay LLP — 604-696-9928\n5. Klein Lawyers — callkleinlawyers.com\n6. McQuarrie Hunter LLP — 604-581-7001\n7. Sean Hern Law Corp — 604-684-9151\n8. Pivot Legal — 604-255-9700\n9. BCCLA Referral — 604-687-2919\n10. CBA BC — 604-687-3221 / info@cbabc.org\n11. Dinsley Litigation (Sean Dinsley) — 604-477-0766 / admin@dinsleylawcorp.ca — Maple Ridge, civil litigation + PI")
                        .font(.system(size:11,design:.monospaced)).foregroundStyle(.secondary).lineSpacing(3)
                    Text("Be expensive to fight quietly. Each press-capable lawyer contact, each documented evidence piece, each Charter ground formally pleaded raises the AG's internal cost of suppressing this case publicly.")
                        .font(.system(size:11,design:.monospaced)).foregroundStyle(.secondary).lineSpacing(3)
                } else if store.activeCase == .muni {
                    Text("Do these in order: (1) send the s.285 notice today — registered mail is sufficient; (2) book a free PI consult through Law Society BC; (3) let the lawyer send the demand to Surrey Risk Management.")
                        .font(.system(size:13)).foregroundStyle(.primary).lineSpacing(3)
                    Text("PI lawyers in BC take slip-and-fall municipal claims on contingency. No upfront cost. They know how Surrey's risk team prices claims and will handle the notice if you haven't sent it yet.")
                        .font(.system(size:11,design:.monospaced)).foregroundStyle(.secondary).lineSpacing(3)
                    Text("The evidence is solid: two angles of the hazard plus the injury photo. Add a GP visit for injury documentation on record. That's a clean file.")
                        .font(.system(size:11,design:.monospaced)).foregroundStyle(.briefWarn).lineSpacing(3)
                } else {
                    Text("Contact a civil litigation lawyer specializing in intentional torts and/or appropriation of personality. Call Law Society BC referral first — 1-800-663-1919.")
                        .font(.system(size:13)).foregroundStyle(.primary).lineSpacing(3)
                    Text("Basic 2-yr limit expires May 1, 2028 (discovery May 2026). Appropriation of personality is the cleanest limitation story — ongoing if still in commercial use. Lead with that. File before May 2028.")
                        .font(.system(size:11,design:.monospaced)).foregroundStyle(.briefWarn).lineSpacing(3).fontWeight(.bold)
                    Text("Asset enforcement: parents own $1M+ Langley home. BC has no homestead exemption — a registered judgment can force a sale. Defendants are ~60, retired. Private defendants settle faster than government.")
                        .font(.system(size:11,design:.monospaced)).foregroundStyle(.secondary).lineSpacing(3)
                }
            }
        }
    }

    private var timelineSection: some View {
        SectionCard("Timeline") {
            VStack(spacing: 0) {
                let timeline: [TimelineStep] = {
                    switch store.activeCase { case .rcmp: return caseTimeline; case .family: return familyCaseTimeline; case .muni: return muniCaseTimeline }
                }()
                ForEach(timeline) { step in
                    HStack(alignment: .top, spacing: 14) {
                        VStack(spacing: 0) {
                            Circle()
                                .fill(dotColor(step.dotStyle))
                                .frame(width: 9, height: 9)
                                .padding(.top, 4)
                                .overlay(step.dotStyle == .now ? Circle().stroke(dotColor(step.dotStyle).opacity(0.3), lineWidth: 4) : nil)
                            if step.id != timeline.last?.id {
                                Rectangle().fill(Color.secondary.opacity(0.2)).frame(width:1).frame(minHeight:20)
                            }
                        }
                        VStack(alignment:.leading,spacing:3) {
                            Text(step.when).font(.system(size:9,weight:.bold)).tracking(1).textCase(.uppercase).foregroundStyle(.secondary)
                            Text(step.title).font(.system(size:13,weight:.semibold))
                            Text(step.description).font(.system(size:12)).foregroundStyle(.secondary).lineSpacing(2)
                        }
                        .padding(.bottom, 18)
                    }
                }
            }
        }
    }

    private var risksSection: some View {
        SectionCard("Risks — what AG will attack") {
            VStack(alignment:.leading,spacing:10) {
                risk("Limitation (kill shot).", "Rule 9-5 strike likely. s.8(1)(d) discoverability + s.18 incapacity must both be argued. Anything showing 2023–2025 functional capacity (taxes, leases, employment, banking, driving) hurts s.18.", .briefDanger)
                risk("Godoy doorway.", "R v. Godoy [1999] 1 SCR 311 gives 911-wellness entry authority. Counter-attack is scope — entry to verify safety, not detain/medicate. The 911 call audio defines the doorway size.", .briefWarn)
                risk("MHA s.28 apprehension.", "If lawful, forced-medication ground weakens. Father's 'answering well… not violent' testimony is the linchpin against s.28 threshold.", .briefWarn)
                risk("Causation / baseline.", "AG hires their own forensic psychiatrist; will subpoena pre-2023 GP records looking for alternative causes.", .briefWarn)
                risk("Self-rep admissions.", "Audit every email, complaint, social post you wrote pre-retainer for inconsistencies before disclosure.", .briefWarn)
            }
        }
    }

    private var familyRisksSection: some View {
        SectionCard("Risks — what defendants will attack") {
            VStack(alignment:.leading,spacing:10) {
                risk("Limitation (primary risk).", "Defendants will move to strike childhood claims immediately. Must document May 2026 discoverability in writing now. Appropriation survives if ongoing commercial use continues.", .briefDanger)
                risk("Causation separation.", "PTSD must be partitioned between RCMP claim and family claim — two cases, two defendants, two expert witnesses. Failure to separate weakens both.", .briefWarn)
                risk("Family dispute framing.", "Defendants will characterize as family conflict, not a tort. Counsel must anchor in commercial exploitation and documented pattern conduct — not emotion.", .briefWarn)
                risk("Novel battery claim.", "No BC appellate authority on circumcision as battery. Include as supplementary only — don't let it distract from stronger heads.", .briefWarn)
            }
        }
    }

    private var evidenceGapsSection: some View {
        SectionCard("Evidence gaps — not yet on checklist") {
            Text("· 911 call audio + CAD notes (E-Comm 9-1-1 BC FOI)\n· RCMP officer notebooks Form 1624 (ATIP)\n· BCEHS paramedic ePCR\n· Mental Health Act Form 4 / Form 1 (hospital)\n· Pharmacy records post-incident\n· Pre-incident GP records 2022 – Jul 2023 (baseline)\n· Income records / T4s 2022–2026\n· Photos — injuries, dwelling damage\n· Pre-retainer comms audit (admissions check)\n\nNote: existing checklist item \"OPCC complaint\" should be CRCC. RCMP is federal — OPCC handles BC municipal only.")
                .font(.system(size:11,design:.monospaced)).foregroundStyle(.secondary).lineSpacing(4)
        }
    }

    private var familyEvidenceSection: some View {
        SectionCard("Evidence priorities") {
            Text("· Photograph all vehicles and materials using your likeness — timestamped\n· Screenshot online presence: website, Google My Business, social media\n· Write precise homelessness timeline (dates, locations, witnesses)\n· Preserve all texts, emails, voicemails from Brian + Christine\n· Find or reconstruct the Yelp review and any parental response\n· Document police call dates from childhood (ages 10, 15) — any incident numbers\n· Therapy records separating family PTSD from RCMP PTSD\n· BC Registry search on family business (bcregistry.gov.bc.ca)\n· Written memo: May 2026 = date you understood these as legal claims")
                .font(.system(size:11,design:.monospaced)).foregroundStyle(.secondary).lineSpacing(4)
        }
    }

    private var draftsSection: some View {
        SectionCard("Drafts") {
            Text("CRCC complaint skeleton, FOI/ATIP requests, demand letter skeleton, extra questions for Paul — see heyitsmejosh.com/brief for full drafts.\n\nNothing here sent without Paul's sign-off.")
                .font(.system(size:11,design:.monospaced)).foregroundStyle(.secondary).lineSpacing(4)
        }
    }

    private var callbackLogSection: some View {
        SectionCard("Callback log") {
            Text("Record after each lawyer call:\n— Limitation verdict (viable / not viable / needs more info)\n— Fee structure (contingency % / hourly rate)\n— Their assessment of May 11, 2026 as s.8(d) discovery date\n— Next step they recommended\n— Will they take the case? (Y / N / maybe)\n— Referral to another lawyer?")
                .font(.system(size:11,design:.monospaced)).foregroundStyle(.secondary).lineSpacing(4)
        }
    }

    @ViewBuilder
    private func risk(_ bold: String, _ text: String, _ color: Color) -> some View {
        Text("\(bold) \(text)")
            .font(.system(size:12)).lineSpacing(3)
            .foregroundStyle(color)
            .environment(\.font, .system(size:12))
    }

    private func dotColor(_ s: TimelineStep.DotStyle) -> Color {
        switch s { case .now: return .briefDanger; case .warn: return .briefWarn; case .good: return .briefGreen; case .danger: return .briefDanger; case .neutral: return .secondary }
    }
}
