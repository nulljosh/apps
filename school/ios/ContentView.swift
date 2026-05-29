import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            GradesView()
                .tabItem { Label("Grades", systemImage: "chart.bar") }
            QuizView()
                .tabItem { Label("Quiz", systemImage: "checkmark.circle") }
            ResourcesView()
                .tabItem { Label("Study", systemImage: "book") }
            PlanView()
                .tabItem { Label("Plan", systemImage: "map") }
        }
        .tint(.primary)
    }
}
