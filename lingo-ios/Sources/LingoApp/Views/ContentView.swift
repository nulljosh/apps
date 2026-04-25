import SwiftUI

// MARK: - Theme

enum Theme {
    static let bg = Color(hex: "#fafafa")
    static let bgSecondary = Color(hex: "#f0f0f0")
    static let bgTertiary = Color(hex: "#e8e8e8")
    static let cardBg = Color.white
    static let border = Color.black.opacity(0.1)
    static let textPrimary = Color.black
    static let textMuted = Color.black.opacity(0.3)
    static let success = Color(hex: "#2d7a50")
    static let error = Color(hex: "#c44040")

    static let bgDark = Color(hex: "#111111")
    static let bgSecondaryDark = Color(hex: "#1a1a1a")
    static let bgTertiaryDark = Color(hex: "#222222")
    static let cardBgDark = Color(hex: "#1a1a1a")
    static let borderDark = Color.white.opacity(0.1)
    static let textPrimaryDark = Color(hex: "#e8e8e8")
    static let textMutedDark = Color.white.opacity(0.3)

    static func adaptive(light: Color, dark: Color) -> Color {
        // Use UIKit to resolve color scheme at runtime
        Color(UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
        })
    }

    static let adaptiveBg = adaptive(light: bg, dark: bgDark)
    static let adaptiveBgSecondary = adaptive(light: bgSecondary, dark: bgSecondaryDark)
    static let adaptiveBgTertiary = adaptive(light: bgTertiary, dark: bgTertiaryDark)
    static let adaptiveCardBg = adaptive(light: cardBg, dark: cardBgDark)
    static let adaptiveBorder = adaptive(light: border, dark: borderDark)
    static let adaptiveTextMuted = adaptive(light: textMuted, dark: textMutedDark)
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        self.init(
            red: Double((rgb >> 16) & 0xFF) / 255,
            green: Double((rgb >> 8) & 0xFF) / 255,
            blue: Double(rgb & 0xFF) / 255
        )
    }
}

struct ContentView: View {
    @Environment(ProgressManager.self) private var progressManager
    @State private var selectedCategory: Category?
    @State private var selectedSubject: Subject?
    @State private var showQuiz = false
    @State private var showTrophies = false
    @State private var showGame: GameType? = nil
    @State private var quizViewModel = QuizViewModel()

    private let categories = QuestionBank.shared.categories

    enum GameType: String, CaseIterable, Identifiable {
        case chess, game2048, memory, minesweeper, snake
        var id: String { rawValue }
        var name: String {
            switch self {
            case .chess: return "Chess"
            case .game2048: return "2048"
            case .memory: return "Memory"
            case .minesweeper: return "Minesweeper"
            case .snake: return "Snake"
            }
        }
        var icon: String {
            switch self {
            case .chess: return "checkerboard.rectangle"
            case .game2048: return "square.grid.2x2.fill"
            case .memory: return "rectangle.on.rectangle"
            case .minesweeper: return "circle.grid.3x3.fill"
            case .snake: return "arrow.right.arrow.left"
            }
        }
    }

    private let gamesCategory = Category(id: "games", title: "Choose a game", icon: "gamecontroller.fill", subjects: [])

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
                        if category.id == "games" {
                            gamesGrid
                                .padding(.top, 16)
                        } else {
                            subjectGrid(category)
                                .padding(.top, 16)
                        }
                    }
                }
                .padding(.bottom, 32)
            }
            .background(Theme.adaptiveBg)
            .navigationTitle("Lingo")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showTrophies = true
                    } label: {
                        Image(systemName: "trophy.fill")
                            .foregroundStyle(.primary)
                    }
                }
            }
            .sheet(isPresented: $showTrophies) {
                TrophyView()
            }
            .sheet(item: $showGame) { game in
                NavigationStack {
                    gameView(for: game)
                        .navigationTitle(game.name)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button { showGame = nil } label: {
                                    Image(systemName: "xmark").font(.body.weight(.medium))
                                }
                            }
                        }
                }
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
            StatBadge(icon: "bolt.fill", value: "\(progressManager.progress.xp)", label: "XP", color: Color(.secondaryLabel))
            StatBadge(icon: "flame.fill", value: "\(progressManager.progress.streak)", label: "Streak", color: Color(.secondaryLabel))
            StatBadge(icon: "heart.fill", value: "\(progressManager.progress.hearts)", label: "Lives", color: Color(.secondaryLabel))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Theme.adaptiveCardBg, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Theme.adaptiveBorder, lineWidth: 1))
    }

    // MARK: - Category Picker

    private var allCategories: [Category] {
        categories + [gamesCategory]
    }

    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(allCategories) { category in
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
                            ? AnyShapeStyle(Color.primary)
                            : AnyShapeStyle(Theme.adaptiveCardBg)
                        )
                        .foregroundStyle(
                            selectedCategory?.id == category.id
                            ? Color(UIColor.systemBackground)
                            : .primary
                        )
                        .overlay(
                            Capsule().strokeBorder(
                                selectedCategory?.id == category.id
                                ? Color.clear
                                : Theme.adaptiveBorder, lineWidth: 1
                            )
                        )
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Games Grid

    private var gamesGrid: some View {
        LazyVGrid(
            columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
            spacing: 12
        ) {
            ForEach(GameType.allCases) { game in
                Button {
                    showGame = game
                } label: {
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Theme.adaptiveBgSecondary)
                                .frame(width: 48, height: 48)
                            Image(systemName: game.icon)
                                .font(.title3)
                                .foregroundStyle(.primary)
                        }
                        Text(game.name)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.primary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 8)
                    .background(Theme.adaptiveCardBg, in: RoundedRectangle(cornerRadius: 16))
                    .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Theme.adaptiveBorder, lineWidth: 1))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private func gameView(for game: GameType) -> some View {
        switch game {
        case .chess: ChessGameView()
        case .game2048: Game2048View()
        case .memory: MemoryGameView()
        case .minesweeper: MinesweeperView()
        case .snake: SnakeGameView()
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
                        .fill(Theme.adaptiveBgSecondary)
                        .frame(width: 48, height: 48)
                    Image(systemName: subject.icon)
                        .font(.title3)
                        .foregroundStyle(.primary)
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
                        .foregroundStyle(Theme.success)
                        .font(.caption)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, 8)
            .background(Theme.adaptiveCardBg, in: RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(Theme.adaptiveBorder, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
        .environment(ProgressManager())
}
