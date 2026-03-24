import SpriteKit
import UIKit

@MainActor
final class MenuScene: SKScene {
    var onNewGame: (() -> Void)?
    var onLoadGame: ((Int) -> Void)?

    private var showingLoadMenu = false
    private var loadMenuNodes: [SKNode] = []

    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 0.05, green: 0.11, blue: 0.16, alpha: 1)

        let title = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 14, weight: .bold).fontName)
        title.text = "TIMES SQUARE"
        title.fontSize = 48
        title.fontColor = UIColor(red: 0, green: 0.96, blue: 0.83, alpha: 1)
        title.position = CGPoint(x: size.width / 2, y: size.height * 0.65)
        title.horizontalAlignmentMode = .center
        addChild(title)

        let subtitle = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 14).fontName)
        subtitle.text = "SURVIVAL SIMULATOR"
        subtitle.fontSize = 20
        subtitle.fontColor = UIColor(red: 0.97, green: 0.15, blue: 0.52, alpha: 1)
        subtitle.position = CGPoint(x: size.width / 2, y: size.height * 0.55)
        subtitle.horizontalAlignmentMode = .center
        addChild(subtitle)

        let newGame = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 14, weight: .bold).fontName)
        newGame.text = "> NEW GAME"
        newGame.fontSize = 24
        newGame.fontColor = UIColor(red: 1.0, green: 0.9, blue: 0.43, alpha: 1)
        newGame.position = CGPoint(x: size.width / 2, y: size.height * 0.38)
        newGame.horizontalAlignmentMode = .center
        newGame.name = "newGame"
        addChild(newGame)

        let loadGame = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 14, weight: .bold).fontName)
        loadGame.text = "> LOAD GAME"
        loadGame.fontSize = 24
        loadGame.fontColor = UIColor(red: 0, green: 0.96, blue: 0.83, alpha: 1)
        loadGame.position = CGPoint(x: size.width / 2, y: size.height * 0.30)
        loadGame.horizontalAlignmentMode = .center
        loadGame.name = "loadGame"
        addChild(loadGame)

        let blink = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.3, duration: 0.5),
            SKAction.fadeAlpha(to: 1.0, duration: 0.5)
        ])
        newGame.run(SKAction.repeatForever(blink))
    }

    private func showLoadMenu() {
        guard !showingLoadMenu else { return }
        showingLoadMenu = true

        let overlay = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        overlay.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        overlay.strokeColor = .clear
        overlay.name = "loadOverlay"
        overlay.zPosition = 10
        addChild(overlay)
        loadMenuNodes.append(overlay)

        let header = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 14, weight: .bold).fontName)
        header.text = "LOAD GAME"
        header.fontSize = 28
        header.fontColor = UIColor(red: 0, green: 0.96, blue: 0.83, alpha: 1)
        header.position = CGPoint(x: size.width / 2, y: size.height * 0.72)
        header.horizontalAlignmentMode = .center
        header.zPosition = 11
        addChild(header)
        loadMenuNodes.append(header)

        let slots = SaveManager.shared.listSlots()

        for i in 0..<3 {
            let slotY = size.height * (0.58 - CGFloat(i) * 0.14)
            let slotData = slots[i]

            let bg = SKShapeNode(rect: CGRect(x: size.width / 2 - 200, y: slotY - 20, width: 400, height: 50), cornerRadius: 0)
            bg.fillColor = UIColor(red: 0.1, green: 0.15, blue: 0.2, alpha: 0.9)
            bg.strokeColor = UIColor(red: 0, green: 0.96, blue: 0.83, alpha: 0.3)
            bg.lineWidth = 1
            bg.name = "loadSlot\(i + 1)"
            bg.zPosition = 11
            addChild(bg)
            loadMenuNodes.append(bg)

            let label = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 14, weight: .bold).fontName)
            label.fontSize = 16
            label.horizontalAlignmentMode = .center
            label.verticalAlignmentMode = .center
            label.position = CGPoint(x: size.width / 2, y: slotY + 5)
            label.zPosition = 12
            label.name = "loadSlot\(i + 1)"

            if let slot = slotData {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM d, HH:mm"
                let dateStr = formatter.string(from: slot.timestamp)
                label.text = "SLOT \(i + 1) -- Day \(slot.dayCount) | \(slot.colonistCount) alive | \(dateStr)"
                label.fontColor = UIColor(red: 1.0, green: 0.9, blue: 0.43, alpha: 1)
            } else {
                label.text = "SLOT \(i + 1) -- EMPTY --"
                label.fontColor = UIColor(red: 0.4, green: 0.4, blue: 0.45, alpha: 1)
            }

            addChild(label)
            loadMenuNodes.append(label)
        }

        let back = SKLabelNode(fontNamed: UIFont.systemFont(ofSize: 14, weight: .bold).fontName)
        back.text = "[ TAP HERE TO GO BACK ]"
        back.fontSize = 14
        back.fontColor = UIColor(red: 0.5, green: 0.5, blue: 0.55, alpha: 1)
        back.position = CGPoint(x: size.width / 2, y: size.height * 0.18)
        back.horizontalAlignmentMode = .center
        back.zPosition = 11
        back.name = "backButton"
        addChild(back)
        loadMenuNodes.append(back)
    }

    private func hideLoadMenu() {
        for node in loadMenuNodes {
            node.removeFromParent()
        }
        loadMenuNodes.removeAll()
        showingLoadMenu = false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = self.nodes(at: location)

        if showingLoadMenu {
            let slots = SaveManager.shared.listSlots()
            for node in nodes {
                guard let name = node.name else { continue }
                if name == "backButton" {
                    hideLoadMenu()
                    return
                }
                for i in 1...3 {
                    if name == "loadSlot\(i)" && slots[i - 1] != nil {
                        onLoadGame?(i)
                        return
                    }
                }
            }
            return
        }

        for node in nodes {
            if node.name == "newGame" {
                onNewGame?()
            } else if node.name == "loadGame" {
                showLoadMenu()
            }
        }
    }
}
