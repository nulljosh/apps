import SwiftUI

struct TutorialView: View {
    @Bindable var gameState: GameState

    private var step: Int {
        gameState.tutorialStep ?? 0
    }

    private var stepData: (title: String, body: String, hint: String) {
        switch step {
        case 0:
            ("WELCOME", "Welcome to Times Square. You control a group of survivors.", "Tap to continue")
        case 1:
            ("NEEDS", "Your colonists have NEEDS -- hunger, oxygen, stress, sleep, health. Keep them alive.", "Tap to continue")
        case 2:
            ("STATS", "Each colonist has RPG STATS -- STR, INT, AGI, END, CHA. Tap one of the small figures walking around.", "Tap a colonist")
        case 3:
            ("CAMERA", "Drag to pan the camera. Pinch to zoom.", "Tap to continue")
        case 4:
            ("BUILD", "Tap BUILD to open the build menu. Buildings keep your colony running.", "Tap BUILD")
        case 5:
            ("SHELTER", "Place a SHELTER to reduce stress and let colonists sleep.", "Place a shelter")
        case 6:
            ("DIRECTIVES", "Set a DIRECTIVE to auto-assign colonists. Try GATHER to start collecting resources.", "Tap to continue")
        case 7:
            ("COMBAT", "Colonists carry weapons. Assign ATTACK jobs to fight enemies. STR boosts damage.", "Tap to continue")
        case 8:
            ("GOOD LUCK", "Tap PAUSE to pause. Tap SAVE to save. Good luck.", "Tap to dismiss")
        default:
            ("", "", "")
        }
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .allowsHitTesting(true)
                .onTapGesture { advanceIfClickable() }

            VStack(spacing: 16) {
                HStack {
                    Text("TUTORIAL \(step + 1)/9")
                        .font(.system(size: 11))
                        .foregroundStyle(Color.white.opacity(0.5))
                    Spacer()
                    Button(action: skip) {
                        Text("SKIP")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Color(red: 0.97, green: 0.15, blue: 0.52))
                    }
                    .buttonStyle(.plain)
                }

                Text(stepData.title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color(red: 0, green: 0.96, blue: 0.83))

                Text(stepData.body)
                    .font(.system(size: 14))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                if step == 4 {
                    Text("BUILD")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color(red: 1.0, green: 0.9, blue: 0.43))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.1))
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: hintPulse)
                }

                if step == 6 {
                    HStack(spacing: 8) {
                        ForEach(ColonyDirective.allCases, id: \.self) { d in
                            Text(d.displayName)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(d == .gather ? Color.black : Color.white.opacity(0.5))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(d == .gather ? Color(red: 1.0, green: 0.9, blue: 0.43) : Color.white.opacity(0.05))
                        }
                    }
                }

                Text(stepData.hint)
                    .font(.system(size: 11))
                    .foregroundStyle(Color(red: 1.0, green: 0.9, blue: 0.43))
                    .opacity(hintPulse ? 1.0 : 0.4)
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: hintPulse)
                    .onAppear { hintPulse = true; startAutoSkipTimer() }
                    .onChange(of: step) { startAutoSkipTimer() }

                HStack(spacing: 6) {
                    ForEach(0..<9, id: \.self) { i in
                        Circle()
                            .fill(i <= step ? Color(red: 0, green: 0.96, blue: 0.83) : Color.white.opacity(0.2))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 8)
            }
            .padding(24)
            .frame(maxWidth: 420)
            .background(Color(red: 0.05, green: 0.11, blue: 0.16).opacity(0.95))
            .overlay(
                Rectangle()
                    .stroke(Color(red: 0, green: 0.96, blue: 0.83).opacity(0.5), lineWidth: 2)
            )
        }
    }

    @State private var hintPulse = false
    @State private var autoSkipTask: Task<Void, Never>?

    private func startAutoSkipTimer() {
        autoSkipTask?.cancel()
        autoSkipTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 30_000_000_000)
            guard !Task.isCancelled else { return }
            if gameState.tutorialStep != nil {
                advance()
            }
        }
    }

    private func advanceIfClickable() {
        advance()
    }

    private func advance() {
        if step >= 8 {
            gameState.tutorialStep = nil
        } else {
            gameState.tutorialStep = step + 1
        }
    }

    private func skip() {
        gameState.tutorialStep = nil
    }

    static func checkAdvance(gameState: GameState, event: TutorialEvent) {
        guard let step = gameState.tutorialStep else { return }
        switch (step, event) {
        case (2, .colonistSelected): gameState.tutorialStep = 3
        case (3, .cameraPanned): gameState.tutorialStep = 4
        case (4, .buildMenuOpened): gameState.tutorialStep = 5
        case (5, .shelterPlaced): gameState.tutorialStep = 6
        case (6, .colonistSelected): gameState.tutorialStep = 7
        default: break
        }
    }
}

enum TutorialEvent {
    case colonistSelected
    case cameraPanned
    case buildMenuOpened
    case shelterPlaced
}
