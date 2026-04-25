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
        Color(nsColor: NSColor(name: nil) { appearance in
            appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
                ? NSColor(dark)
                : NSColor(light)
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

// MARK: - Content View

struct ContentView: View {
    @Environment(ProgressManager.self) private var progressManager
    @State private var selectedCategory: Category?
    @State private var selectedSubject: Subject?
    @State private var quizViewModel = QuizViewModel()
    @State private var showTrophies = false
    @State private var hoveredSubjectId: String?
    @State private var hoveredCategoryId: String?

    private let categories = QuestionBank.shared.categories

    var body: some View {
        NavigationSplitView {
            sidebar
                .navigationSplitViewColumnWidth(min: 200, ideal: 220, max: 280)
        } detail: {
            detailView
        }
        .background(Theme.adaptiveBg)
        .onAppear {
            if selectedCategory == nil {
                selectedCategory = categories.first
            }
        }
    }

    // MARK: - Sidebar

    private var sidebar: some View {
        VStack(spacing: 0) {
            sidebarContent
        }
        .sheet(isPresented: $showTrophies) {
            TrophyView()
                .frame(minWidth: 400, minHeight: 500)
        }
    }

    private var sidebarContent: some View {
        List {
            Section("Stats") {
                statsRow
            }

            Section("Categories") {
                ForEach(categories) { category in
                    sidebarCategoryRow(category)
                }
            }

            Section {
                trophyButton
            }
        }
        .listStyle(.sidebar)
    }

    private func sidebarCategoryRow(_ category: Category) -> some View {
        let isSelected = selectedCategory?.id == category.id
        let isHovered = hoveredCategoryId == category.id
        return Button {
            withAnimation(.spring(duration: 0.3)) {
                selectedCategory = category
                selectedSubject = nil
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.body)
                    .foregroundStyle(isSelected ? .primary : .secondary)
                    .frame(width: 20)
                Text(category.title)
                    .font(.body.weight(isSelected ? .semibold : .regular))
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            hoveredCategoryId = hovering ? category.id : nil
        }
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.spring(duration: 0.2, bounce: 0.4), value: hoveredCategoryId)
    }

    private var trophyButton: some View {
        Button {
            showTrophies = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "trophy.fill")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .frame(width: 20)
                Text("Trophies")
                    .font(.body)
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Stats Row

    private var statsRow: some View {
        HStack(spacing: 16) {
            StatBadge(icon: "bolt.fill", value: "\(progressManager.progress.xp)", label: "XP", color: .secondary)
            StatBadge(icon: "flame.fill", value: "\(progressManager.progress.streak)", label: "Streak", color: .secondary)
            StatBadge(icon: "heart.fill", value: "\(progressManager.progress.hearts)", label: "Lives", color: .secondary)
        }
        .padding(.vertical, 4)
    }

    // MARK: - Detail View

    @ViewBuilder
    private var detailView: some View {
        if let subject = selectedSubject {
            QuizView(viewModel: quizViewModel) {
                selectedSubject = nil
            }
            .background(Theme.adaptiveBg)
        } else if let category = selectedCategory {
            subjectGridView(category)
        } else {
            Text("Select a category")
                .font(.title3)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Theme.adaptiveBg)
        }
    }

    // MARK: - Subject Grid

    private func subjectGridView(_ category: Category) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text(category.title)
                    .font(.largeTitle.weight(.bold))
                    .padding(.horizontal, 32)
                    .padding(.top, 24)

                Text("\(category.subjects.count) subjects")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 32)

                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ],
                    spacing: 16
                ) {
                    ForEach(category.subjects) { subject in
                        SubjectCard(
                            subject: subject,
                            isCompleted: progressManager.progress.completedSubjects.contains(subject.id),
                            isHovered: hoveredSubjectId == subject.id
                        ) {
                            quizViewModel.startLesson(subjectId: subject.id)
                            selectedSubject = subject
                        }
                        .onHover { hovering in
                            hoveredSubjectId = hovering ? subject.id : nil
                        }
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        }
        .background(Theme.adaptiveBg)
    }
}

// MARK: - Stat Badge

struct StatBadge: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .font(.caption2)
                Text(value)
                    .font(.caption.weight(.semibold).monospacedDigit())
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
    let isHovered: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Theme.adaptiveBgTertiary)
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
            .padding(.vertical, 20)
            .padding(.horizontal, 12)
            .background(Theme.adaptiveCardBg, in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Theme.adaptiveBorder, lineWidth: 1)
            )
            .scaleEffect(isHovered ? 1.03 : 1.0)
            .animation(.spring(duration: 0.2, bounce: 0.4), value: isHovered)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
        .environment(ProgressManager())
}
