import SwiftUI

struct ContentView: View {
    @Environment(ProgressManager.self) private var progressManager
    @State private var selectedCategory: Category?
    @State private var selectedSubject: Subject?
    @State private var showQuiz = false
    @State private var showTrophies = false
    @State private var quizViewModel = QuizViewModel()

    private let categories = QuestionBank.shared.categories

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    statsBar
                        .padding(.horizontal)
                        .padding(.top, 8)

                    categoryPicker
                        .padding(.top, 16)

                    if let category = selectedCategory {
                        subjectGrid(category)
                            .padding(.top, 16)
                    }
                }
                .padding(.bottom, 32)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Lingo")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showTrophies = true
                    } label: {
                        Image(systemName: "trophy.fill")
                            .foregroundStyle(.yellow)
                    }
                }
            }
            .sheet(isPresented: $showTrophies) {
                TrophyView()
            }
            .fullScreenCover(isPresented: $showQuiz) {
                QuizView(viewModel: quizViewModel) {
                    showQuiz = false
                }
            }
            .onAppear {
                if selectedCategory == nil {
                    selectedCategory = categories.first
                }
            }
        }
    }

    // MARK: - Stats Bar

    private var statsBar: some View {
        HStack(spacing: 20) {
            StatBadge(icon: "bolt.fill", value: "\(progressManager.progress.xp)", label: "XP", color: .orange)
            StatBadge(icon: "flame.fill", value: "\(progressManager.progress.streak)", label: "Streak", color: .red)
            StatBadge(icon: "heart.fill", value: "\(progressManager.progress.hearts)", label: "Lives", color: .pink)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Category Picker

    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories) { category in
                    Button {
                        withAnimation(.spring(duration: 0.3)) {
                            selectedCategory = category
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: category.icon)
                                .font(.subheadline)
                            Text(category.id.capitalized)
                                .font(.subheadline.weight(.medium))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            selectedCategory?.id == category.id
                            ? AnyShapeStyle(.tint)
                            : AnyShapeStyle(.ultraThinMaterial)
                        )
                        .foregroundStyle(
                            selectedCategory?.id == category.id
                            ? .white
                            : .primary
                        )
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Subject Grid

    private func subjectGrid(_ category: Category) -> some View {
        LazyVGrid(
            columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
            spacing: 12
        ) {
            ForEach(category.subjects) { subject in
                SubjectCard(
                    subject: subject,
                    isCompleted: progressManager.progress.completedSubjects.contains(subject.id)
                ) {
                    selectedSubject = subject
                    quizViewModel.startLesson(subjectId: subject.id)
                    showQuiz = true
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Stat Badge

struct StatBadge: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .font(.caption)
                Text(value)
                    .font(.headline.monospacedDigit())
            }
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Subject Card

struct SubjectCard: View {
    let subject: Subject
    let isCompleted: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 48, height: 48)
                    Image(systemName: subject.icon)
                        .font(.title3)
                        .foregroundStyle(.tint)
                }

                Text(subject.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)

                Text(subject.level)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.caption)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, 8)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
        .environment(ProgressManager())
}
