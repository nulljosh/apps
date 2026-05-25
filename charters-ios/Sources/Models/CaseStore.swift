import Foundation

struct CaseClaim: Codable, Identifiable {
    var id: String
    var ref: String
    var title: String
    var note: String
}

struct LegalCase: Codable, Identifiable {
    var id: String
    var type: String
    var country: String
    var title: String
    var verdict: String
    var sections: [String]
    var claims: [CaseClaim]
    var bottomLine: String
}

private let seedCases: [LegalCase] = [
    LegalCase(
        id: "case-01", type: "charter", country: "CA",
        title: "Case 01 — Charter Breaches (Police / Government)",
        verdict: "Forced entry during wellness check with no warrant and no clear emergency. If initial entry was unlawful, all subsequent police actions may flow from that breach, creating a cumulative and substantial Charter claim.",
        sections: ["Section 7", "Section 8", "Section 9", "Section 10", "Section 15"],
        claims: [
            CaseClaim(id: "c01-s7", ref: "Section 7", title: "Life, Liberty and Security", note: "Forced entry and resulting PTSD may constitute a serious infringement of personal safety and autonomy."),
            CaseClaim(id: "c01-s8", ref: "Section 8", title: "Search and Seizure", note: "Home receives the highest level of privacy protection. Entry without lawful authority may be unconstitutional."),
            CaseClaim(id: "c01-s9", ref: "Section 9", title: "Arbitrary Detention", note: "Restricting movement inside own home without lawful grounds may amount to arbitrary detention."),
            CaseClaim(id: "c01-s10", ref: "Section 10", title: "Rights on Arrest", note: "If effectively detained, police were required to explain reasons and advise right to counsel."),
            CaseClaim(id: "c01-s15", ref: "Section 15", title: "Equality Rights", note: "Treating a mental health situation as a criminal confrontation rather than a care response may raise equality concerns."),
        ],
        bottomLine: "If initial entry was unlawful, a lawyer could argue all subsequent police actions flowed from that breach — creating a cumulative and substantial Charter claim."
    ),
    LegalCase(
        id: "case-0002", type: "civil", country: "CA",
        title: "CASE-0002 — Civil Claim Against Private Parties",
        verdict: "Legitimate civil case. Strongest claims: appropriation of personality and intentional infliction of mental suffering. Recent conduct remains actionable despite older childhood events potentially being time-barred.",
        sections: [],
        claims: [
            CaseClaim(id: "c02-ap", ref: "Appropriation of Personality", title: "Unauthorized Use of Likeness", note: "Especially if image is still being used commercially."),
            CaseClaim(id: "c02-iims", ref: "IIMS", title: "Intentional Infliction of Mental Suffering", note: "Parking lot confrontation and related conduct may meet the legal threshold for outrageous behavior."),
            CaseClaim(id: "c02-pn", ref: "Parental Negligence", title: "Childhood Failures", note: "Potential claim based on failures during childhood."),
            CaseClaim(id: "c02-lec", ref: "Lost Earning Capacity", title: "Economic Damages", note: "Damages available if the conduct impaired ability to work."),
        ],
        bottomLine: "Weaker than a Charter claim (private parties vs. government) but remains legally viable. Key enforcement advantage: defendants have identifiable assets and property. Build a detailed evidence file regardless of litigation decision."
    )
]

class CaseStore: ObservableObject {
    @Published var cases: [LegalCase] = []
    private var username: String = ""
    private var key: String { "ch-cases-\(username)" }

    func load(for username: String) {
        self.username = username
        if let data = UserDefaults.standard.data(forKey: key),
           let loaded = try? JSONDecoder().decode([LegalCase].self, from: data) {
            cases = loaded
        } else {
            cases = username == "joshua" ? seedCases : []
            save()
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(cases) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func delete(at offsets: IndexSet) {
        cases.remove(atOffsets: offsets)
        save()
    }

    func clear() {
        cases = []
        username = ""
    }
}
