import SwiftUI

struct ResultsView: View {
    let viewModel: QuizViewModel
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Score circle
            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 8)
                    .frame(width: 140, height: 140)
                Circle()
                    .trim(from: 0, to: scoreFraction)
                    .stroke(scoreColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(duration: 0.8), value: scoreFraction)

                VStack(spacing: 4) {
                    Text("\(viewModel.correctAnswers)")
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                    Text("of \(viewModel.lessonQuestions.count)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            // Title
            Text(titleText)
                .font(.title2.weight(.bold))

            // Stats row
            HStack(spacing: 32) {
                VStack(spacing: 4) {
                    Text("+\(viewModel.xpEarned)")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.primary)
                    Text("XP earned")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                VStack(spacing: 4) {
                    Text("\(viewModel.hearts)")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.primary)
                    Text("Hearts left")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Button {
                onDismiss()
            } label: {
                Text("Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
    }

    private var scoreFraction: Double {
        guard viewModel.lessonQuestions.count > 0 else { return 0 }
        return Double(viewModel.correctAnswers) / Double(viewModel.lessonQuestions.count)
    }

    private var scoreColor: Color {
        if scoreFraction >= 0.8 { return Theme.success }
        if scoreFraction >= 0.5 { return Color(.secondaryLabel) }
        return Theme.error
    }

    private var titleText: String {
        if scoreFraction == 1.0 { return "Perfect score!" }
        if scoreFraction >= 0.8 { return "Great work!" }
        if scoreFraction >= 0.5 { return "Good effort!" }
        return "Keep practicing!"
    }
}
