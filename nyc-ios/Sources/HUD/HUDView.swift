import SwiftUI

struct HUDView: View {
    @Bindable var gameState: GameState

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.clear
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                ResourceBar(gameState: gameState)
                    .padding(8)
                Spacer()
            }

            if gameState.showBuildMenu {
                HStack {
                    BuildMenu(gameState: gameState)
                        .padding(8)
                        .allowsHitTesting(true)
                    Spacer()
                }
                .padding(.top, 50)
            }

            if gameState.selectedColonist != nil {
                HStack {
                    Spacer()
                    ColonistPanel(gameState: gameState)
                        .padding(8)
                        .allowsHitTesting(true)
                }
                .padding(.top, 50)
            }

            VStack {
                Spacer()
                HStack {
                    GameLogView(gameState: gameState)
                        .padding(8)
                    Spacer()
                    MiniMap()
                        .padding(8)
                }
                .padding(.bottom, 110)
            }

            if gameState.isPaused {
                Color.black.opacity(0.5)
                    .allowsHitTesting(false)
                Text("PAUSED")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(Color(red: 1.0, green: 0.9, blue: 0.43))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .allowsHitTesting(false)
            }

            // Time display
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("Tick \(gameState.currentTick) | \(gameState.currentHour):00 | \(gameState.isNight ? "NIGHT" : "DAY")")
                        .font(.system(size: 11))
                        .foregroundStyle(Color.white.opacity(0.6))
                        .padding(6)
                }
                .padding(.bottom, 110)
            }

            // Save indicator
            if gameState.showSaveIndicator {
                VStack {
                    HStack {
                        Spacer()
                        Text("SAVED")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color(red: 0.48, green: 0.95, blue: 0.47))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(red: 0.05, green: 0.11, blue: 0.16).opacity(0.9))
                            .overlay(
                                Rectangle()
                                    .stroke(Color(red: 0.48, green: 0.95, blue: 0.47).opacity(0.4), lineWidth: 1)
                            )
                            .transition(.opacity)
                            .padding(8)
                    }
                    Spacer()
                }
            }

            // Auto-save dot
            if gameState.autoSaveEnabled && gameState.lastSaveSlot != nil {
                VStack {
                    HStack {
                        Spacer()
                        Circle()
                            .fill(Color(red: 0.48, green: 0.95, blue: 0.47))
                            .frame(width: 6, height: 6)
                            .padding(.trailing, 12)
                            .padding(.top, gameState.showSaveIndicator ? 44 : 12)
                    }
                    Spacer()
                }
            }

            // Bottom toolbar
            VStack {
                Spacer()

                // Directive row
                HStack(spacing: 8) {
                    Text("DIRECTIVE:")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white.opacity(0.6))
                    ForEach(ColonyDirective.allCases, id: \.self) { directive in
                        directiveButton(directive: directive)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
                .allowsHitTesting(true)

                // Main toolbar
                HStack(spacing: 12) {
                    toolbarButton(label: gameState.isPaused ? "PLAY" : "PAUSE") {
                        gameState.isPaused.toggle()
                    }
                    toolbarButton(label: "SAVE") {
                        NotificationCenter.default.post(name: .performSave, object: nil)
                    }
                    toolbarButton(label: "BUILD", isActive: gameState.showBuildMenu) {
                        gameState.showBuildMenu.toggle()
                        if !gameState.showBuildMenu { gameState.inputMode = .normal }
                        TutorialView.checkAdvance(gameState: gameState, event: .buildMenuOpened)
                    }
                    toolbarButton(label: "DEMOLISH", isActive: gameState.inputMode == .demolish) {
                        if gameState.inputMode == .demolish {
                            gameState.inputMode = .normal
                        } else {
                            gameState.inputMode = .demolish
                        }
                    }
                    toolbarButton(label: "CANCEL", isActive: false) {
                        gameState.inputMode = .normal
                        gameState.selectedBuildingType = nil
                        gameState.showBuildMenu = false
                    }
                    toolbarButton(label: "SETTINGS", isActive: gameState.showSettings) {
                        gameState.showSettings.toggle()
                        if gameState.showSettings { gameState.isPaused = true }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color(red: 0.05, green: 0.11, blue: 0.16).opacity(0.9))
                .overlay(
                    Rectangle()
                        .stroke(Color(red: 0, green: 0.96, blue: 0.83).opacity(0.4), lineWidth: 2)
                )
                .allowsHitTesting(true)
            }

            // Settings overlay
            if gameState.showSettings {
                SettingsView(gameState: gameState)
                    .allowsHitTesting(true)
            }

            // Tutorial overlay
            if gameState.tutorialStep != nil {
                TutorialView(gameState: gameState)
                    .allowsHitTesting(true)
            }
        }
    }

    private func toolbarButton(label: String, isActive: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(isActive ? Color.black : Color.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .frame(minHeight: 44)
                .background(isActive ? Color(red: 0, green: 0.96, blue: 0.83) : Color.white.opacity(0.1))
        }
        .buttonStyle(.plain)
    }

    private func directiveButton(directive: ColonyDirective) -> some View {
        Button(action: {
            gameState.currentDirective = directive
            gameState.log("Directive: \(directive.displayName)")
        }) {
            Text(directive.displayName)
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(gameState.currentDirective == directive ? Color.black : Color.white.opacity(0.7))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .frame(minHeight: 32)
                .background(gameState.currentDirective == directive ? Color(red: 1.0, green: 0.9, blue: 0.43) : Color.white.opacity(0.1))
        }
        .buttonStyle(.plain)
    }
}

extension Notification.Name {
    static let performSave = Notification.Name("performSave")
}

struct GameLogView: View {
    let gameState: GameState

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            ForEach(Array(gameState.gameLog.suffix(5).enumerated()), id: \.offset) { _, msg in
                Text(msg)
                    .font(.system(size: 10))
                    .foregroundStyle(Color(red: 0, green: 0.96, blue: 0.83))
            }
        }
        .padding(6)
        .background(Color(red: 0.05, green: 0.11, blue: 0.16).opacity(0.85))
        .overlay(
            Rectangle()
                .stroke(Color(red: 0, green: 0.96, blue: 0.83).opacity(0.4), lineWidth: 2)
        )
        .frame(maxWidth: 300, alignment: .leading)
    }
}
