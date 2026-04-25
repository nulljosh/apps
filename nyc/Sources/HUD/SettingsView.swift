import SwiftUI

struct SettingsView: View {
    @Bindable var gameState: GameState

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .allowsHitTesting(true)
                .onTapGesture { close() }

            VStack(spacing: 20) {
                Text("SETTINGS")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(Color(red: 0.39, green: 0.82, blue: 1.0))

                Divider().background(Color.white.opacity(0.2))

                // Controls reference
                VStack(alignment: .leading, spacing: 10) {
                    Text("CONTROLS")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Color(red: 1.0, green: 0.84, blue: 0.04))

                    controlRow(key: "WASD / Arrows", action: "Pan camera")
                    controlRow(key: "Scroll", action: "Zoom in/out")
                    controlRow(key: "B", action: "Toggle build menu")
                    controlRow(key: "1-6", action: "Select building type")
                    controlRow(key: "X", action: "Toggle demolish mode")
                    controlRow(key: "Space", action: "Pause/resume")
                    controlRow(key: "Cmd+S", action: "Save game")
                    controlRow(key: "Esc", action: "Settings / cancel")
                    controlRow(key: "Click", action: "Select / place / demolish")
                }

                Divider().background(Color.white.opacity(0.2))

                // Game options
                VStack(alignment: .leading, spacing: 10) {
                    Text("OPTIONS")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Color(red: 1.0, green: 0.84, blue: 0.04))

                    Toggle(isOn: Binding(
                        get: { gameState.autoSaveEnabled },
                        set: { gameState.autoSaveEnabled = $0 }
                    )) {
                        Text("Auto-save")
                            .font(.system(size: 13))
                            .foregroundStyle(.white)
                    }
                    .toggleStyle(.switch)
                    .tint(Color(red: 0.39, green: 0.82, blue: 1.0))
                }

                Divider().background(Color.white.opacity(0.2))

                // Save slots
                VStack(alignment: .leading, spacing: 8) {
                    Text("SAVE / LOAD")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Color(red: 1.0, green: 0.84, blue: 0.04))

                    let slots = SaveManager.shared.listSlots()
                    ForEach(0..<3, id: \.self) { i in
                        HStack {
                            if let slot = slots[i] {
                                Text("Slot \(i + 1) -- Day \(slot.dayCount)")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.white)
                            } else {
                                Text("Slot \(i + 1) -- Empty")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.white.opacity(0.4))
                            }
                            Spacer()
                            Button("SAVE") {
                                NotificationCenter.default.post(
                                    name: .performSaveToSlot,
                                    object: nil,
                                    userInfo: ["slot": i + 1]
                                )
                            }
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(Color(red: 0.39, green: 0.82, blue: 1.0))
                            .buttonStyle(.plain)
                        }
                    }
                }

                Spacer()

                Text("Press ESC to close")
                    .font(.system(size: 11))
                    .foregroundStyle(.white.opacity(0.4))
            }
            .padding(24)
            .frame(width: 360, height: 480)
            .background(Color(red: 0.04, green: 0.04, blue: 0.05).opacity(0.95))
            .overlay(
                Rectangle()
                    .stroke(Color(red: 0.39, green: 0.82, blue: 1.0).opacity(0.5), lineWidth: 2)
            )
        }
    }

    private func controlRow(key: String, action: String) -> some View {
        HStack {
            Text(key)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(Color(red: 1.0, green: 0.22, blue: 0.37))
                .frame(width: 120, alignment: .leading)
            Text(action)
                .font(.system(size: 12))
                .foregroundStyle(.white.opacity(0.8))
        }
    }

    private func close() {
        gameState.showSettings = false
        gameState.isPaused = false
    }
}

extension Notification.Name {
    static let performSaveToSlot = Notification.Name("performSaveToSlot")
}
