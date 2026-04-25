import Foundation

enum QuestionType: String, Codable, CaseIterable {
    case translation
    case sentence
    case listening
    case math
    case mathChoice
}

struct Question: Codable, Identifiable, Equatable {
    let id: String
    let type: QuestionType
    let question: String
    let answer: String
    var choices: [String]?
    var words: [String]?
    var audio: String?

    static func == (lhs: Question, rhs: Question) -> Bool {
        lhs.id == rhs.id
    }
}
