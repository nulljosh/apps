import Foundation

/// Fetches the catalog and per-course packs from the live web app and decodes
/// them into domain models. Replaces the old bundled QuestionBank: content is
/// data served over HTTP (same packs the web app uses), never hardcoded here.
@MainActor
@Observable
final class CourseStore {

    static let baseURL = "https://lingo.heyitsmejosh.com"

    private(set) var categories: [Category] = []
    private var flattened: [String: [Question]] = [:]
    private(set) var courses: [String: CoursePack] = [:]

    // MARK: - Decoding structures (mirror content/schema.json)

    private struct RawCatalog: Decodable { let categories: [String: RawCategory] }
    private struct RawCategory: Decodable { let title: String; let subjects: [RawSubject] }
    private struct RawSubject: Decodable {
        let id: String; let name: String; let icon: String; let level: String; let lang: String?
    }
    private struct RawPack: Decodable {
        let id: String; let name: String; let category: String
        let icon: String?; let level: String?; let lang: String?; let units: [RawUnit]
    }
    private struct RawUnit: Decodable { let id: String; let title: String; let lessons: [RawLesson] }
    private struct RawLesson: Decodable { let id: String; let title: String; let exercises: [RawExercise] }
    private struct RawExercise: Decodable {
        let id: String?; let type: String; let question: String; let answer: String
        let choices: [String]?; let words: [String]?; let audio: String?
    }

    // MARK: - Public API

    /// Fetch the catalog once. Safe to call repeatedly.
    func loadCatalog() async {
        guard categories.isEmpty else { return }
        guard let url = URL(string: "\(Self.baseURL)/content/catalog.json"),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let raw = try? JSONDecoder().decode(RawCatalog.self, from: data) else { return }
        categories = Self.categoryOrder.compactMap { key in
            guard let rawCat = raw.categories[key] else { return nil }
            let subjects = rawCat.subjects.map { sub in
                Subject(id: sub.id, name: sub.name,
                        icon: Self.iconMap[sub.icon] ?? "questionmark.circle", level: sub.level)
            }
            return Category(id: key, title: rawCat.title,
                            icon: Self.categoryIcons[key] ?? "questionmark.circle", subjects: subjects)
        }
    }

    /// Lazily fetch a course pack and return its exercises as a flat question list.
    @discardableResult
    func loadCourse(_ subjectId: String) async -> [Question] {
        if let cached = flattened[subjectId] { return cached }
        guard let url = URL(string: "\(Self.baseURL)/content/courses/\(subjectId).json"),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let raw = try? JSONDecoder().decode(RawPack.self, from: data) else {
            flattened[subjectId] = []
            return []
        }
        var index = 0
        var units: [CourseUnit] = []
        var flat: [Question] = []
        for rawUnit in raw.units {
            var lessons: [CourseLesson] = []
            for rawLesson in rawUnit.lessons {
                let questions = rawLesson.exercises.map { ex -> Question in
                    let qId = ex.id ?? "\(subjectId)_\(index)"
                    index += 1
                    return Question(
                        id: qId,
                        type: QuestionType(rawValue: ex.type) ?? .translation,
                        question: ex.question, answer: ex.answer,
                        choices: ex.choices, words: ex.words, audio: ex.audio
                    )
                }
                flat.append(contentsOf: questions)
                lessons.append(CourseLesson(id: rawLesson.id, title: rawLesson.title, questions: questions))
            }
            units.append(CourseUnit(id: rawUnit.id, title: rawUnit.title, lessons: lessons))
        }
        courses[subjectId] = CoursePack(id: raw.id, name: raw.name, lang: raw.lang, units: units)
        flattened[subjectId] = flat
        return flat
    }

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

    // MARK: - FontAwesome -> SF Symbol mapping

    private static let categoryOrder = ["languages", "programming", "computers", "math", "science", "skills"]

    private static let categoryIcons: [String: String] = [
        "languages": "globe",
        "programming": "chevron.left.forwardslash.chevron.right",
        "computers": "desktopcomputer",
        "math": "function",
        "science": "atom",
        "skills": "lightbulb.fill"
    ]

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
        "fa-solid fa-computer": "desktopcomputer",
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
        "fa-solid fa-book": "book.fill",
        "fa-solid fa-book-open": "book.fill",
        "fa-solid fa-heart-pulse": "heart.fill",
        "fa-solid fa-globe": "globe",
    ]
}

// MARK: - Structured course (units -> lessons), kept for the skill-tree path

struct CoursePack {
    let id: String
    let name: String
    let lang: String?
    let units: [CourseUnit]
}

struct CourseUnit: Identifiable {
    let id: String
    let title: String
    let lessons: [CourseLesson]
}

struct CourseLesson: Identifiable {
    let id: String
    let title: String
    let questions: [Question]
}
