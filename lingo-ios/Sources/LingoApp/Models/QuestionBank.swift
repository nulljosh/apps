import Foundation

/// Loads and decodes the question bank from the embedded JSON resource.
enum QuestionBank {

    // MARK: - JSON structures for decoding

    private struct RawData: Decodable {
        let categories: [String: RawCategory]
        let questions: [String: [RawQuestion]]
    }

    private struct RawCategory: Decodable {
        let title: String
        let subjects: [RawSubject]
    }

    private struct RawSubject: Decodable {
        let id: String
        let name: String
        let icon: String
        let level: String
    }

    private struct RawQuestion: Decodable {
        let id: String?
        let type: String
        let question: String
        let answer: String
        let choices: [String]?
        let words: [String]?
        let audio: String?
    }

    // MARK: - SF Symbol mapping from FontAwesome

    private static let iconMap: [String: String] = [
        "fa-solid fa-earth-americas": "globe.americas.fill",
        "fa-solid fa-earth-europe": "globe.europe.africa.fill",
        "fa-solid fa-earth-asia": "globe.asia.australia.fill",
        "fa-solid fa-earth-africa": "globe.europe.africa.fill",
        "fa-solid fa-language": "textformat",
        "fa-solid fa-pizza-slice": "fork.knife",
        "fa-brands fa-js": "chevron.left.forwardslash.chevron.right",
        "fa-brands fa-python": "chevron.left.forwardslash.chevron.right",
        "fa-brands fa-rust": "gearshape.2.fill",
        "fa-solid fa-microchip": "cpu",
        "fa-brands fa-java": "cup.and.saucer.fill",
        "fa-brands fa-golang": "server.rack",
        "fa-solid fa-database": "cylinder.split.1x2.fill",
        "fa-solid fa-plus": "plus",
        "fa-solid fa-superscript": "x.squareroot",
        "fa-solid fa-draw-polygon": "triangle",
        "fa-solid fa-wave-square": "waveform.path.ecg",
        "fa-solid fa-infinity": "infinity",
        "fa-solid fa-chart-bar": "chart.bar.fill",
        "fa-solid fa-table-cells": "tablecells",
        "fa-solid fa-puzzle-piece": "puzzlepiece.fill",
        "fa-solid fa-atom": "atom",
        "fa-solid fa-flask": "flask.fill",
        "fa-solid fa-dna": "allergens",
        "fa-solid fa-satellite": "sparkles",
        "fa-solid fa-chess": "crown.fill",
        "fa-solid fa-music": "music.note",
        "fa-solid fa-guitar": "guitars.fill",
        "fa-solid fa-landmark": "building.columns.fill",
        "fa-solid fa-globe": "globe",
    ]

    private static let categoryOrder = ["languages", "programming", "math", "science", "skills"]

    private static let categoryIcons: [String: String] = [
        "languages": "globe",
        "programming": "chevron.left.forwardslash.chevron.right",
        "math": "function",
        "science": "atom",
        "skills": "lightbulb.fill"
    ]

    // MARK: - Public API

    static let shared: (categories: [Category], questions: [String: [Question]]) = {
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let raw = try? JSONDecoder().decode(RawData.self, from: data) else {
            return (categories: [], questions: [:])
        }

        let categories: [Category] = categoryOrder.compactMap { key in
            guard let rawCat = raw.categories[key] else { return nil }
            let subjects = rawCat.subjects.map { s in
                Subject(
                    id: s.id,
                    name: s.name,
                    icon: iconMap[s.icon] ?? "questionmark.circle",
                    level: s.level
                )
            }
            return Category(
                id: key,
                title: rawCat.title,
                icon: categoryIcons[key] ?? "questionmark.circle",
                subjects: subjects
            )
        }

        var questions: [String: [Question]] = [:]
        for (subjectId, rawQuestions) in raw.questions {
            questions[subjectId] = rawQuestions.enumerated().map { index, rq in
                let qId = rq.id ?? "\(subjectId)-\(rq.type)-\(index + 1)"
                let qType = QuestionType(rawValue: rq.type) ?? .translation
                return Question(
                    id: qId,
                    type: qType,
                    question: rq.question,
                    answer: rq.answer,
                    choices: rq.choices,
                    words: rq.words,
                    audio: rq.audio
                )
            }
        }

        return (categories: categories, questions: questions)
    }()

    /// Language subject IDs that support speech features.
    static let languageSubjectIds: Set<String> = [
        "spanish", "french", "german", "italian", "portuguese",
        "japanese", "chinese", "korean", "russian", "arabic", "hindi", "dutch"
    ]

    /// Math subject IDs for the math wizard trophy.
    static let mathSubjectIds: Set<String> = [
        "arithmetic", "algebra", "geometry", "trigonometry",
        "calculus", "statistics", "linear_algebra", "logic"
    ]
}
