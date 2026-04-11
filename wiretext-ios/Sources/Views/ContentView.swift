import SwiftUI

struct ContentView: View {
    @Environment(CanvasModel.self) private var canvas
    @State private var showPicker = false
    @State private var shareText: String? = nil

    var body: some View {
        NavigationStack {
            CanvasScrollView()
                .navigationTitle("Wiretext")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button { canvas.undo() } label: { Image(systemName: "arrow.uturn.backward") }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button { canvas.clear() } label: { Image(systemName: "trash") }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button { shareText = canvas.render() } label: { Image(systemName: "square.and.arrow.up") }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button { showPicker = true } label: { Image(systemName: "plus.circle.fill") }
                    }
                }
        }
        .sheet(isPresented: $showPicker) {
            ComponentPickerView().environment(canvas)
        }
        .sheet(item: Binding(get: { shareText.map { ShareItem(text: $0) } }, set: { shareText = $0?.text })) { item in
            ShareSheet(text: item.text)
        }
    }
}

struct ShareItem: Identifiable { let id = UUID(); let text: String }

struct ShareSheet: UIViewControllerRepresentable {
    let text: String
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [text], applicationActivities: nil)
    }
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}
