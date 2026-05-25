import Foundation
import Observation

@Observable
final class EquationStore {
    var equations: [Equation] = []

    private let defaultsKey = "grapher.equations"

    static let colors = [
        "#FF851B", "#ff453a", "#30d158", "#ffd60a",
        "#bf5af2", "#0071e3", "#64d2ff", "#ff375f",
    ]

    init() {
        load()
        if equations.isEmpty {
            equations = [Equation(expression: "sin(x)", color: Self.colors[0])]
        }
    }

    func add() {
        let color = Self.colors[equations.count % Self.colors.count]
        equations.append(Equation(expression: "", color: color))
        save()
    }

    func remove(at offsets: IndexSet) {
        equations.remove(atOffsets: offsets)
        save()
    }

    func remove(id: UUID) {
        equations.removeAll { $0.id == id }
        save()
    }

    func save() {
        if let data = try? JSONEncoder().encode(equations) {
            UserDefaults.standard.set(data, forKey: defaultsKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: defaultsKey),
              let decoded = try? JSONDecoder().decode([Equation].self, from: data)
        else { return }
        equations = decoded
    }
}
