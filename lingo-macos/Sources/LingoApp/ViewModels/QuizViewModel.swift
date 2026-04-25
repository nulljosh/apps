import Foundation
import SwiftUI

@Observable
final class QuizViewModel {

    // MARK: - Configuration

    let totalQuestions = 10
    let xpPerCorrect = 10

    // MARK: - State

    var currentQuestionIndex = 0
    var correctAnswers = 0
    var hearts = 5
    var lessonQuestions: [Question] = []
    var selectedAnswer: String?
    var answerWords: [String] = []
    var typedAnswer: String = ""
    var hasChecked = false
    var isCorrect = false
    var isFinished = false
    var subjectId: String = ""

    var currentQuestion: Question? {
        guard currentQuestionIndex < lessonQuestions.count else { return nil }
        return lessonQuestions[currentQuestionIndex]
    }

    var progressFraction: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(currentQuestionIndex) / Double(totalQuestions)
    }

    var xpEarned: Int {
        correctAnswers * xpPerCorrect
    }

    // MARK: - Setup

    func startLesson(subjectId: String) {
        self.subjectId = subjectId
        currentQuestionIndex = 0
        correctAnswers = 0
        hearts = 5
        selectedAnswer = nil
        answerWords = []
        typedAnswer = ""
        hasChecked = false
        isCorrect = false
        isFinished = false

        let allQuestions = QuestionBank.shared.questions[subjectId] ?? []
        lessonQuestions = Array(allQuestions.shuffled().prefix(totalQuestions))
    }

    // MARK: - Answer handling

    func selectChoice(_ choice: String) {
        guard !hasChecked else { return }
        selectedAnswer = choice
    }

    func toggleWord(_ word: String) {
        guard !hasChecked else { return }
        if let index = answerWords.lastIndex(of: word) {
            answerWords.remove(at: index)
        } else {
            answerWords.append(word)
        }
        selectedAnswer = answerWords.joined(separator: " ")
    }

    func removeWord(at index: Int) {
        guard !hasChecked, index < answerWords.count else { return }
        answerWords.remove(at: index)
        selectedAnswer = answerWords.joined(separator: " ")
    }

    // MARK: - Check

    func checkAnswer() {
        guard let question = currentQuestion, !hasChecked else { return }
        hasChecked = true

        switch question.type {
        case .translation, .mathChoice:
            isCorrect = selectedAnswer == question.answer
        case .sentence:
            isCorrect = selectedAnswer == question.answer
        case .listening:
            isCorrect = typedAnswer.trimmingCharacters(in: .whitespaces)
                .lowercased() == question.answer.lowercased()
        case .math:
            let cleaned = typedAnswer.trimmingCharacters(in: .whitespaces)
                .lowercased()
                .replacingOccurrences(of: " ", with: "")
            let expected = question.answer.lowercased()
                .replacingOccurrences(of: " ", with: "")
            isCorrect = cleaned == expected
        }

        if isCorrect {
            correctAnswers += 1
        } else {
            hearts -= 1
        }
    }

    // MARK: - Navigation

    func nextQuestion() {
        currentQuestionIndex += 1
        selectedAnswer = nil
        answerWords = []
        typedAnswer = ""
        hasChecked = false
        isCorrect = false

        if currentQuestionIndex >= lessonQuestions.count || hearts <= 0 {
            isFinished = true
        }
    }

    func finishLesson(progressManager: ProgressManager) {
        progressManager.addXP(xpEarned)
        progressManager.markSubjectCompleted(subjectId)
        progressManager.updateStreak()
        progressManager.resetHearts()
        progressManager.checkAndAwardTrophies(
            correctAnswers: correctAnswers,
            totalQuestions: totalQuestions
        )
    }
}
