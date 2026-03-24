import SpriteKit

@MainActor
final class MenuScene: SKScene {
    var onNewGame: (() -> Void)?
    var onLoadGame: ((Int) -> Void)?

    private var showingLoadMenu = false
    private var loadMenuNodes: [SKNode] = []

    override func didMove(to view: SKView) {
        backgroundColor = NSColor(red: 0.05, green: 0.11, blue: 0.16, alpha: 1)

        let title = SKLabelNode(fontNamed: NSFont.systemFont(ofSize: 14, weight: .bold).fontName)
        title.text = "TIMES SQUARE"
        title.fontSize = 48
        title.fontColor = NSColor(red: 0, green: 0.96, blue: 0.83, alpha: 1)
        title.position = CGPoint(x: size.width / 2, y: size.height * 0.65)
        title.horizontalAlignmentMode = .center
        addChild(title)

        let subtitle = SKLabelNode(fontNamed: NSFont.systemFont(ofSize: 14).fontName)
        subtitle.text = "SURVIVAL SIMULATOR"
        subtitle.fontSize = 20
        subtitle.fontColor = NSColor(red: 0.97, green: 0.15, blue: 0.52, alpha: 1)
        subtitle.position = CGPoint(x: size.width / 2, y: size.height * 0.55)
        subtitle.horizontalAlignmentMode = .center
        addChild(subtitle)

        let newGame = SKLabelNode(fontNamed: NSFont.systemFont(ofSize: 14, weight: .bold).fontName)
        newGame.text = "> NEW GAME"
        newGame.fontSize = 24
        newGame.fontColor = NSColor(red: 1.0, green: 0.9, blue: 0.43, alpha: 1)
        newGame.position = CGPoint(x: size.width / 2, y: size.height * 0.38)
        newGame.horizontalAlignmentMode = .center
        newGame.name = "newGame"
        addChild(newGame)

        let loadGame = SKLabelNode(fontNamed: NSFont.systemFont(ofSize: 14, weight: .bold).fontName)
        loadGame.text = "> LOAD GAME"
        loadGame.fontSize = 24
        loadGame.fontColor = NSColor(red: 0, green: 0.96, blue: 0.83, alpha: 1)
        loadGame.position = CGPoint(x: size.width / 2, y: size.height * 0.30)
        loadGame.horizontalAlignmentMode = .center
        loadGame.name = "loadGame"
        addChild(loadGame)

        let quit = SKLabelNode(fontNamed: NSFont.systemFont(ofSize: 14, weight: .bold).fontName)
        quit.text = "> QUIT"
        quit.fontSize = 24
        quit.fontColor = NSColor(red: 0.6, green: 0.6, blue: 0.65, alpha: 1)
        quit.position = CGPoint(x: size.width / 2, y: size.height * 0.22)
        quit.horizontalAlignmentMode = .center
        quit.name = "quit"
        addChild(quit)

        let blink = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.3, duration: 0.5),
            SKAction.fadeAlpha(to: 1.0, duration: 0.5)
        ])
        newGame.run(SKAction.repeatForever(blink))
    }

    private func showLoadMenu() {
        guard !showingLoadMenu else { return }
        showingLoadMenu = true

        // Dim overlay
        let overlay = SKShapeNode(rect: CGRect(origin: .zero, size: size))
        overlay.fillColor = NSColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        overlay.strokeColor = .clear
        overlay.name = "loadOverlay"
        overlay.zPosition = 10
        addChild(overlay)
        loadMenuNodes.append(overlay)

        let header = SKLabelNode(fontNamed: NSFont.systemFont(ofSize: 14, weight: .bold).fontName)
        header.text = "LOAD GAME"
        header.fontSize = 28
        header.fontColor = NSColor(red: 0, green: 0.96, blue: 0.83, alpha: 1)
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
            bg.fillColor = NSColor(red: 0.1, green: 0.15, blue: 0.2, alpha: 0.9)
            bg.strokeColor = NSColor(red: 0, green: 0.96, blue: 0.83, alpha: 0.3)
            bg.lineWidth = 1
            bg.name = "loadSlot\(i + 1)"
            bg.zPosition = 11
            addChild(bg)
            loadMenuNodes.append(bg)

            let label = SKLabelNode(fontNamed: NSFont.systemFont(ofSize: 14, weight: .bold).fontName)
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
                label.fontColor = NSColor(red: 1.0, green: 0.9, blue: 0.43, alpha: 1)
            } else {
                label.text = "SLOT \(i + 1) -- EMPTY --"
                label.fontColor = NSColor(red: 0.4, green: 0.4, blue: 0.45, alpha: 1)
            }

            addChild(label)
            loadMenuNodes.append(label)
        }

        let back = SKLabelNode(fontNamed: NSFont.systemFont(ofSize: 14, weight: .bold).fontName)
        back.text = "[ ESC TO GO BACK ]"
        back.fontSize = 14
        back.fontColor = NSColor(red: 0.5, green: 0.5, blue: 0.55, alpha: 1)
        back.position = CGPoint(x: size.width / 2, y: size.height * 0.18)
        back.horizontalAlignmentMode = .center
        back.zPosition = 11
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

    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let nodes = self.nodes(at: location)

        if showingLoadMenu {
            let slots = SaveManager.shared.listSlots()
            for node in nodes {
                guard let name = node.name else { continue }
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
            } else if node.name == "quit" {
                NSApplication.shared.terminate(nil)
            }
        }
    }

    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53 && showingLoadMenu {
            hideLoadMenu()
        }
    }
}
