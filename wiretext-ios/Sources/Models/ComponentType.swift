import Foundation

enum ComponentType: String, CaseIterable, Identifiable {
    case button, input, select, checkbox, radio, toggle
    case table, modal, browser, card
    case navbar, tabs, progress, icon, image, divider
    case alert, breadcrumb, avatar, list, stepper, rating, skeleton

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .button: "Button"; case .input: "Input"; case .select: "Select"
        case .checkbox: "Checkbox"; case .radio: "Radio"; case .toggle: "Toggle"
        case .table: "Table"; case .modal: "Modal"; case .browser: "Browser"; case .card: "Card"
        case .navbar: "Navbar"; case .tabs: "Tabs"; case .progress: "Progress"
        case .icon: "Icon"; case .image: "Image"; case .divider: "Divider"
        case .alert: "Alert"; case .breadcrumb: "Breadcrumb"; case .avatar: "Avatar"
        case .list: "List"; case .stepper: "Stepper"; case .rating: "Rating"; case .skeleton: "Skeleton"
        }
    }

    var unicodeIcon: String {
        switch self {
        case .button: "[ ]"; case .input: "[__]"; case .select: "[▾]"
        case .checkbox: "[✓]"; case .radio: "(●)"; case .toggle: "[●]"
        case .table: "┌┬┐"; case .modal: "[×]"; case .browser: "◄►⟳"; case .card: "┌──┐"
        case .navbar: "≡──"; case .tabs: "┌┐┌"; case .progress: "▓░░"
        case .icon: "★"; case .image: "░░░"; case .divider: "───"
        case .alert: "⚠──"; case .breadcrumb: "a>b"; case .avatar: "╭╮"
        case .list: "•──"; case .stepper: "●─○"; case .rating: "★★☆"; case .skeleton: "░░░"
        }
    }

    var category: String {
        switch self {
        case .button, .input, .select, .checkbox, .radio, .toggle: "Input"
        case .table, .modal, .browser, .card: "Layout"
        default: "Display"
        }
    }

    var template: String {
        switch self {
        case .button: "[ OK ]"
        case .input: "[____________]"
        case .select: "[▾           ]"
        case .checkbox: "[✓] Label"
        case .radio: "(●) Option"
        case .toggle: "[●━━━━━━]"
        case .table:
            "┌──────────┬──────────┬──────────┐\n│ Column A │ Column B │ Column C │\n├──────────┼──────────┼──────────┤\n│ Cell 1   │ Cell 2   │ Cell 3   │\n└──────────┴──────────┴──────────┘"
        case .modal:
            "┌─────────────────────────[×]──┐\n│ Modal Title                  │\n│                              │\n│  Content here...             │\n│           [ Cancel ]  [ OK ] │\n└──────────────────────────────┘"
        case .browser:
            "┌────────────────────────────────────┐\n│ ◄ ► ⟳  [__________________________]│\n├────────────────────────────────────┤\n│                                    │\n└────────────────────────────────────┘"
        case .card:
            "┌──────────────────────────┐\n│ Card Title               │\n│                          │\n│ Card content goes here.  │\n│                          │\n└──────────────────────────┘"
        case .navbar:
            "┌────────────────────────────────────────┐\n│ ≡  Logo            Search...      ☆  │\n└────────────────────────────────────────┘"
        case .tabs:
            "┌────────┐  ─────────  ─────────\n│  Tab 1 │   Tab 2     Tab 3   \n└────────┴────────────────────"
        case .progress: "▓▓▓▓▓▓░░░░░░░░░░░░░░"
        case .icon: "★"
        case .image:
            "╔══════════════════╗\n║ ░░░░░░░░░░░░░░░░ ║\n║ ░░░░░░░░░░░░░░░░ ║\n╚══════════════════╝"
        case .divider: "────────────────────────────────────────"
        case .alert:
            "┌────────────────────────────────┐\n│ ⚠  Warning: Alert message here │\n└────────────────────────────────┘"
        case .breadcrumb: "Home > Section > Page"
        case .avatar:
            "╭──────╮\n│  DH  │\n╰──────╯"
        case .list:
            "• List item one\n• List item two\n• List item three"
        case .stepper: "● ─────── ○ ─────── ○ ─────── ○"
        case .rating: "★★★☆☆"
        case .skeleton:
            "░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░\n░░░░░░░░░░░░░░░░\n░░░░░░░░░░░░░░░░░░░░░░░"
        }
    }

    /// Number of rows the template spans
    var templateRows: Int { template.components(separatedBy: "\n").count }
    /// Number of cols the template spans (widest line)
    var templateCols: Int { template.components(separatedBy: "\n").map(\.count).max() ?? 0 }
}
