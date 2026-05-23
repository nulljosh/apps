import SwiftUI
import SpriteKit

@main
struct TimesSquareSimApp: App {
    @State private var gameState = GameState()
    @State private var showMenu = true
    @State private var loadSlot: Int? = nil

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showMenu {
                    MenuSceneView(
                        onNewGame: {
                            gameState = GameState()
                            gameState.tutorialStep = 0
                            loadSlot = nil
                            showMenu = false
                        },
                        onLoadGame: { slot in
                            loadSlot = slot
                            gameState = GameState()
                            gameState.tutorialStep = nil
                            if let data = SaveManager.shared.load(slot: slot) {
                                gameState.lastSaveSlot = slot
                            }
                            showMenu = false
                        }
                    )
                } else {
                    GameView(gameState: gameState, loadSlot: loadSlot)
                }
            }
            .preferredColorScheme(.dark)
            .statusBarHidden()
        }
    }
}

struct MenuSceneView: UIViewRepresentable {
    var onNewGame: () -> Void
    var onLoadGame: (Int) -> Void

    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        let scene = MenuScene(size: CGSize(width: 1280, height: 800))
        scene.scaleMode = .aspectFill
        scene.onNewGame = onNewGame
        scene.onLoadGame = onLoadGame
        view.presentScene(scene)
        return view
    }

    func updateUIView(_ uiView: SKView, context: Context) {}
}

struct GameView: View {
    @Bindable var gameState: GameState
    var loadSlot: Int?

    var body: some View {
        ZStack {
            GameSceneView(gameState: gameState, loadSlot: loadSlot)
                .allowsHitTesting(true)
            HUDView(gameState: gameState)
                .allowsHitTesting(false)
        }
    }
}

struct GameSceneView: UIViewRepresentable {
    let gameState: GameState
    var loadSlot: Int?

    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        view.showsFPS = true
        view.showsNodeCount = true
        view.ignoresSiblingOrder = true
        let scene = GameScene(gameState: gameState)
        if let slot = loadSlot {
            scene.savedData = SaveManager.shared.load(slot: slot)
        }
        view.presentScene(scene)
        return view
    }

    func updateUIView(_ uiView: SKView, context: Context) {}
}
