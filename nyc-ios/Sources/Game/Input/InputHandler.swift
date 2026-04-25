import SpriteKit
import UIKit

@MainActor
final class InputHandler {
    weak var gameState: GameState?
    weak var cameraController: CameraController?
    weak var skView: SKView?

    var onPlaceBuilding: ((Int, Int) -> Void)?
    var onDemolish: ((CGPoint) -> Void)?
    var onSelectEntity: ((CGPoint) -> Void)?
    var onSave: (() -> Void)?
    var onGetTileMap: (() -> TileMap?)?

    private var panRecognizer: UIPanGestureRecognizer?
    private var pinchRecognizer: UIPinchGestureRecognizer?
    private var tapRecognizer: UITapGestureRecognizer?
    private var longPressRecognizer: UILongPressGestureRecognizer?

    private var lastPanTranslation: CGPoint = .zero
    private var hasPanned = false

    func setup(view: SKView) {
        self.skView = view

        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.minimumNumberOfTouches = 1
        pan.maximumNumberOfTouches = 1
        view.addGestureRecognizer(pan)
        panRecognizer = pan

        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        view.addGestureRecognizer(pinch)
        pinchRecognizer = pinch

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tap)
        tapRecognizer = tap

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPress.minimumPressDuration = 0.5
        view.addGestureRecognizer(longPress)
        longPressRecognizer = longPress
    }

    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard let view = skView else { return }

        switch recognizer.state {
        case .began:
            lastPanTranslation = .zero
            hasPanned = false
        case .changed:
            let translation = recognizer.translation(in: view)
            let delta = CGPoint(
                x: translation.x - lastPanTranslation.x,
                y: translation.y - lastPanTranslation.y
            )
            lastPanTranslation = translation
            cameraController?.pan(by: delta)

            if !hasPanned {
                hasPanned = true
                if let gs = gameState {
                    TutorialView.checkAdvance(gameState: gs, event: .cameraPanned)
                }
            }
        default:
            break
        }
    }

    @objc private func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .changed {
            let zoomDelta = (recognizer.scale - 1.0) * 0.5
            cameraController?.zoom(by: zoomDelta)
            recognizer.scale = 1.0
        }
    }

    @objc private func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard let gameState, let view = skView, let scene = view.scene else { return }

        let viewPoint = recognizer.location(in: view)
        let scenePoint = scene.convertPoint(fromView: viewPoint)

        guard let tileMap = onGetTileMap?() else { return }
        let tilePos = tileMap.tilePosition(worldX: scenePoint.x, worldY: scenePoint.y)

        switch gameState.inputMode {
        case .normal:
            onSelectEntity?(scenePoint)
        case .build:
            onPlaceBuilding?(tilePos.col, tilePos.row)
        case .demolish:
            onDemolish?(scenePoint)
        }
    }

    @objc private func handleLongPress(_ recognizer: UILongPressGestureRecognizer) {
        guard recognizer.state == .began else { return }
        guard let view = skView, let scene = view.scene else { return }

        let viewPoint = recognizer.location(in: view)
        let scenePoint = scene.convertPoint(fromView: viewPoint)
        onDemolish?(scenePoint)
    }
}
