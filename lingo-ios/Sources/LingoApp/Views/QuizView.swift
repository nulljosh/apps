import SwiftUI

struct QuizView: View {
    @Bindable var viewModel: QuizViewModel
    @Environment(ProgressManager.self) private var progressManager
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if viewModel.isFinished {
                    ResultsView(viewModel: viewModel, onDismiss: {
                        viewModel.finishLesson(progressManager: progressManager)
                        onDismiss()
                    })
                } else if let question = viewModel.currentQuestion {
                    quizContent(question)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        onDismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.body.weight(.medium))
                    }
                }
                ToolbarItem(placement: .principal) {
                    quizStatsBar
                }
            }
        }
    }

    // MARK: - Quiz Stats

    private var quizStatsBar: some View {
        HStack(spacing: 16) {
            HStack(spacing: 4) {
                Image(systemName: "heart.fill")
                    .foregroundStyle(.pink)
                    .font(.caption)
                Text("\(viewModel.hearts)")
                    .font(.subheadline.weight(.semibold).monospacedDigit())
            }
            Text("\(viewModel.currentQuestionIndex + 1)/\(viewModel.lessonQuestions.count)")
                .font(.subheadline.weight(.medium).monospacedDigit())
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Quiz Content

    @ViewBuilder
    private func quizContent(_ question: Question) -> some View {
        VStack(spacing: 0) {
            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.systemGray5))
                        .frame(height: 6)
                    Capsule()
                        .fill(.tint)
                        .frame(width: geo.size.width * viewModel.progressFraction, height: 6)
                        .animation(.spring(duration: 0.3), value: viewModel.progressFraction)
                }
            }
            .frame(height: 6)
            .padding(.horizontal)
            .padding(.top, 8)

            ScrollView {
                VStack(spacing: 24) {
                    questionTypeLabel(question)
                    questionPrompt(question)
                    answerArea(question)
                }
                .padding(.horizontal)
                .padding(.top, 24)
            }

            Spacer()

            feedbackArea

            actionButton
                .padding(.horizontal)
                .padding(.bottom, 16)
        }
    }

    // MARK: - Question Type Label

    private func questionTypeLabel(_ question: Question) -> some View {
        Text(questionTypeText(question.type))
            .font(.caption.weight(.semibold))
            .textCase(.uppercase)
            .tracking(0.8)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func questionTypeText(_ type: QuestionType) -> String {
        switch type {
        case .translation: return "Select the correct translation"
        case .sentence: return "Translate this sentence"
        case .listening: return "Type what you hear"
        case .math: return "Solve the problem"
        case .mathChoice: return "Choose the correct answer"
        }
    }

    // MARK: - Question Prompt

    private func questionPrompt(_ question: Question) -> some View {
        Group {
            if question.type == .listening {
                VStack(spacing: 12) {
                    Image(systemName: "speaker.wave.3.fill")
                        .font(.title)
                        .foregroundStyle(.tint)
                    Text(question.audio ?? question.question)
                        .font(.title2.weight(.bold))
                        .multilineTextAlignment(.center)
                }
            } else if question.type == .math {
                Text(question.question)
                    .font(.system(.title, design: .monospaced).weight(.bold))
                    .multilineTextAlignment(.center)
            } else {
                Text(question.question)
                    .font(.title2.weight(.bold))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Answer Area

    @ViewBuilder
    private func answerArea(_ question: Question) -> some View {
        switch question.type {
        case .translation, .mathChoice:
            choiceGrid(question)
        case .sentence:
            sentenceBuilder(question)
        case .listening, .math:
            typingInput(question)
        }
    }

    // MARK: - Multiple Choice

    private func choiceGrid(_ question: Question) -> some View {
        VStack(spacing: 10) {
            ForEach(question.choices ?? [], id: \.self) { choice in
                Button {
                    viewModel.selectChoice(choice)
                } label: {
                    HStack {
                        Text(choice)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        if viewModel.hasChecked {
                            if choice == question.answer {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            } else if choice == viewModel.selectedAnswer && !viewModel.isCorrect {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(choiceBackground(choice, question: question))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(choiceBorder(choice, question: question), lineWidth: 2)
                    )
                }
                .buttonStyle(.plain)
                .disabled(viewModel.hasChecked)
            }
        }
    }

    private func choiceBackground(_ choice: String, question: Question) -> some ShapeStyle {
        if viewModel.hasChecked {
            if choice == question.answer {
                return AnyShapeStyle(Color.green.opacity(0.15))
            } else if choice == viewModel.selectedAnswer && !viewModel.isCorrect {
                return AnyShapeStyle(Color.red.opacity(0.15))
            }
        }
        if choice == viewModel.selectedAnswer {
            return AnyShapeStyle(Color.accentColor.opacity(0.1))
        }
        return AnyShapeStyle(.ultraThinMaterial)
    }

    private func choiceBorder(_ choice: String, question: Question) -> some ShapeStyle {
        if viewModel.hasChecked {
            if choice == question.answer {
                return AnyShapeStyle(Color.green)
            } else if choice == viewModel.selectedAnswer && !viewModel.isCorrect {
                return AnyShapeStyle(Color.red)
            }
        }
        if choice == viewModel.selectedAnswer {
            return AnyShapeStyle(Color.accentColor)
        }
        return AnyShapeStyle(Color.clear)
    }

    // MARK: - Sentence Builder

    private func sentenceBuilder(_ question: Question) -> some View {
        VStack(spacing: 16) {
            // Answer area
            FlowLayout(spacing: 8) {
                ForEach(Array(viewModel.answerWords.enumerated()), id: \.offset) { index, word in
                    Button {
                        viewModel.removeWord(at: index)
                    } label: {
                        Text(word)
                            .font(.body.weight(.medium))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(.tint.opacity(0.15))
                            .foregroundStyle(.tint)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.hasChecked)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
            .padding(12)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))

            // Word bank
            wordBankView(words: question.words ?? [])
        }
    }

    // MARK: - Word Bank

    private func wordBankView(words: [String]) -> some View {
        FlowLayout(spacing: 8) {
            ForEach(Array(words.enumerated()), id: \.offset) { _, word in
                Button {
                    viewModel.toggleWord(word)
                } label: {
                    Text(word)
                        .font(.body.weight(.medium))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(viewModel.answerWords.contains(word) ? AnyShapeStyle(Color(.systemGray5)) : AnyShapeStyle(.ultraThinMaterial))
                        .foregroundStyle(viewModel.answerWords.contains(word) ? AnyShapeStyle(.secondary) : AnyShapeStyle(.primary))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
                .disabled(viewModel.hasChecked)
            }
        }
    }

    // MARK: - Typing Input

    private func typingInput(_ question: Question) -> some View {
        TextField("Type your answer...", text: $viewModel.typedAnswer)
            .font(.body)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .disabled(viewModel.hasChecked)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .onSubmit {
                if !viewModel.hasChecked {
                    viewModel.checkAnswer()
                }
            }
    }

    // MARK: - Feedback

    @ViewBuilder
    private var feedbackArea: some View {
        if viewModel.hasChecked {
            HStack(spacing: 8) {
                Image(systemName: viewModel.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(viewModel.isCorrect ? .green : .red)
                if viewModel.isCorrect {
                    Text("Correct!")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.green)
                } else {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Incorrect")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.red)
                        Text("Answer: \(viewModel.currentQuestion?.answer ?? "")")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(
                (viewModel.isCorrect ? Color.green : Color.red).opacity(0.1)
            )
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .animation(.spring(duration: 0.3), value: viewModel.hasChecked)
        }
    }

    // MARK: - Action Button

    private var actionButton: some View {
        Button {
            if viewModel.hasChecked {
                withAnimation(.spring(duration: 0.3)) {
                    viewModel.nextQuestion()
                }
            } else {
                withAnimation(.spring(duration: 0.3)) {
                    viewModel.checkAnswer()
                }
            }
        } label: {
            Text(viewModel.hasChecked ? "Continue" : "Check")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(!viewModel.hasChecked && !hasAnswer)
    }

    private var hasAnswer: Bool {
        guard let question = viewModel.currentQuestion else { return false }
        switch question.type {
        case .translation, .mathChoice:
            return viewModel.selectedAnswer != nil
        case .sentence:
            return !viewModel.answerWords.isEmpty
        case .listening, .math:
            return !viewModel.typedAnswer.trimmingCharacters(in: .whitespaces).isEmpty
        }
    }
}

// MARK: - Flow Layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = computeLayout(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = computeLayout(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: .unspecified
            )
        }
    }

    private struct LayoutResult {
        var size: CGSize
        var positions: [CGPoint]
    }

    private func computeLayout(proposal: ProposedViewSize, subviews: Subviews) -> LayoutResult {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var rowHeight: CGFloat = 0
        var totalHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth && currentX > 0 {
                currentX = 0
                currentY += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: currentX, y: currentY))
            rowHeight = max(rowHeight, size.height)
            currentX += size.width + spacing
            totalHeight = currentY + rowHeight
        }

        return LayoutResult(
            size: CGSize(width: maxWidth, height: totalHeight),
            positions: positions
        )
    }
}
