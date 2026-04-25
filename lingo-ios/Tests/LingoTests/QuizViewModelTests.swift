import XCTest
@testable import Lingo

final class QuizViewModelTests: XCTestCase {

    private var vm: QuizViewModel!

    override func setUp() {
        super.setUp()
        vm = QuizViewModel()
    }

    // MARK: - Start Lesson

    func testStartLessonResetsState() {
        vm.startLesson(subjectId: "spanish")
        XCTAssertEqual(vm.currentQuestionIndex, 0)
        XCTAssertEqual(vm.correctAnswers, 0)
        XCTAssertEqual(vm.hearts, 5)
        XCTAssertFalse(vm.isFinished)
        XCTAssertFalse(vm.hasChecked)
    }

    func testStartLessonLoadsQuestions() {
        vm.startLesson(subjectId: "spanish")
        XCTAssertFalse(vm.lessonQuestions.isEmpty)
        XCTAssertLessThanOrEqual(vm.lessonQuestions.count, vm.totalQuestions)
    }

    func testStartLessonUnknownSubjectGivesNoQuestions() {
        vm.startLesson(subjectId: "nonexistent_language_xyz")
        XCTAssertTrue(vm.lessonQuestions.isEmpty)
    }

    // MARK: - Choice Selection

    func testSelectChoice() {
        vm.startLesson(subjectId: "spanish")
        vm.selectChoice("Hola")
        XCTAssertEqual(vm.selectedAnswer, "Hola")
    }

    func testSelectChoiceDisabledAfterCheck() {
        vm.startLesson(subjectId: "spanish")
        guard let q = vm.currentQuestion else { return }
        vm.selectChoice(q.answer)
        vm.checkAnswer()
        vm.selectChoice("something else")
        // Should still be the original answer since hasChecked is true
        XCTAssertEqual(vm.selectedAnswer, q.answer)
    }

    // MARK: - Check Answer

    func testCheckCorrectAnswer() {
        vm.startLesson(subjectId: "spanish")
        guard let q = vm.currentQuestion else { return }
        if q.type == .translation || q.type == .mathChoice {
            vm.selectChoice(q.answer)
        } else if q.type == .sentence {
            for word in q.answer.split(separator: " ") {
                vm.toggleWord(String(word))
            }
        } else {
            vm.typedAnswer = q.answer
        }
        vm.checkAnswer()
        XCTAssertTrue(vm.hasChecked)
        XCTAssertTrue(vm.isCorrect)
        XCTAssertEqual(vm.correctAnswers, 1)
        XCTAssertEqual(vm.hearts, 5) // no heart lost
    }

    func testCheckIncorrectAnswer() {
        vm.startLesson(subjectId: "spanish")
        guard let q = vm.currentQuestion else { return }
        if q.type == .translation || q.type == .mathChoice {
            let wrong = q.choices?.first { $0 != q.answer } ?? "wrong"
            vm.selectChoice(wrong)
        } else {
            vm.typedAnswer = "definitely_wrong_answer_xyz"
        }
        vm.checkAnswer()
        XCTAssertTrue(vm.hasChecked)
        XCTAssertFalse(vm.isCorrect)
        XCTAssertEqual(vm.correctAnswers, 0)
        XCTAssertEqual(vm.hearts, 4)
    }

    func testCheckAnswerOnlyOnce() {
        vm.startLesson(subjectId: "spanish")
        guard let q = vm.currentQuestion else { return }
        vm.selectChoice(q.choices?.first ?? "a")
        vm.checkAnswer()
        let heartsAfterFirst = vm.hearts
        vm.checkAnswer() // should not change anything
        XCTAssertEqual(vm.hearts, heartsAfterFirst)
    }

    // MARK: - Next Question

    func testNextQuestionAdvancesIndex() {
        vm.startLesson(subjectId: "spanish")
        vm.selectChoice("anything")
        vm.checkAnswer()
        vm.nextQuestion()
        XCTAssertEqual(vm.currentQuestionIndex, 1)
        XCTAssertFalse(vm.hasChecked)
        XCTAssertNil(vm.selectedAnswer)
    }

    func testFinishedWhenAllQuestionsAnswered() {
        vm.startLesson(subjectId: "spanish")
        // Answer all questions
        for i in 0..<vm.lessonQuestions.count {
            guard let q = vm.currentQuestion else { break }
            if q.type == .translation || q.type == .mathChoice {
                vm.selectChoice(q.answer)
            } else if q.type == .sentence {
                vm.selectedAnswer = q.answer
                vm.answerWords = q.answer.split(separator: " ").map(String.init)
            } else {
                vm.typedAnswer = q.answer
            }
            vm.checkAnswer()
            if i < vm.lessonQuestions.count - 1 {
                vm.nextQuestion()
            }
        }
        vm.nextQuestion()
        XCTAssertTrue(vm.isFinished)
    }

    func testFinishedWhenHeartsRunOut() {
        vm.startLesson(subjectId: "spanish")
        // Lose all hearts
        for _ in 0..<5 {
            guard vm.currentQuestion != nil else { break }
            vm.selectChoice("definitely_wrong_xyz")
            vm.typedAnswer = "definitely_wrong_xyz"
            vm.checkAnswer()
            if !vm.isFinished {
                vm.nextQuestion()
            }
        }
        XCTAssertTrue(vm.isFinished || vm.hearts <= 0)
    }

    // MARK: - XP Calculation

    func testXPEarned() {
        vm.startLesson(subjectId: "spanish")
        XCTAssertEqual(vm.xpEarned, 0)

        guard let q = vm.currentQuestion else { return }
        if q.type == .translation || q.type == .mathChoice {
            vm.selectChoice(q.answer)
        } else if q.type == .sentence {
            vm.selectedAnswer = q.answer
            vm.answerWords = q.answer.split(separator: " ").map(String.init)
        } else {
            vm.typedAnswer = q.answer
        }
        vm.checkAnswer()
        XCTAssertEqual(vm.xpEarned, 10)
    }

    // MARK: - Progress Fraction

    func testProgressFraction() {
        vm.startLesson(subjectId: "spanish")
        XCTAssertEqual(vm.progressFraction, 0.0, accuracy: 0.001)

        vm.selectChoice("anything")
        vm.checkAnswer()
        vm.nextQuestion()

        let expected = 1.0 / Double(vm.totalQuestions)
        XCTAssertEqual(vm.progressFraction, expected, accuracy: 0.001)
    }

    // MARK: - Sentence Builder

    func testToggleWord() {
        vm.startLesson(subjectId: "spanish")
        vm.toggleWord("El")
        XCTAssertEqual(vm.answerWords, ["El"])
        vm.toggleWord("gato")
        XCTAssertEqual(vm.answerWords, ["El", "gato"])
        vm.toggleWord("El")
        XCTAssertEqual(vm.answerWords, ["gato"])
    }

    func testRemoveWordAtIndex() {
        vm.startLesson(subjectId: "spanish")
        vm.toggleWord("El")
        vm.toggleWord("gato")
        vm.toggleWord("es")
        vm.removeWord(at: 1) // remove "gato"
        XCTAssertEqual(vm.answerWords, ["El", "es"])
    }

    // MARK: - Math Answer

    func testMathAnswerWhitespaceHandling() {
        vm.lessonQuestions = [
            Question(id: "test-math-1", type: .math, question: "5 + 7", answer: "12")
        ]
        vm.currentQuestionIndex = 0
        vm.typedAnswer = " 12 "
        vm.checkAnswer()
        XCTAssertTrue(vm.isCorrect)
    }

    func testMathAnswerCaseInsensitive() {
        vm.lessonQuestions = [
            Question(id: "test-math-2", type: .math, question: "Derivative of x^2", answer: "2x")
        ]
        vm.currentQuestionIndex = 0
        vm.typedAnswer = "2X"
        vm.checkAnswer()
        XCTAssertTrue(vm.isCorrect)
    }

    func testListeningAnswerCaseInsensitive() {
        vm.lessonQuestions = [
            Question(id: "test-listen-1", type: .listening, question: "Type what you hear", answer: "Buenos dias", audio: "Buenos dias")
        ]
        vm.currentQuestionIndex = 0
        vm.typedAnswer = "buenos dias"
        vm.checkAnswer()
        XCTAssertTrue(vm.isCorrect)
    }
}
