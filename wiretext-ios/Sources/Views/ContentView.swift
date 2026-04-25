import SwiftUI

struct ContentView: View {
    @Environment(CanvasModel.self) private var canvas
    @State private var showPicker = false
    @State private var shareText: String? = nil
    @State private var showClearConfirm = false

    var body: some View {
        NavigationStack {
            CanvasScrollView()
                .ignoresSafeArea(edges: .bottom)
                .navigationTitle("wiretext")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        HStack(spacing: 2) {
                            Button {
                                canvas.undo()
                            } label: {
                                Image(systemName: "arrow.uturn.backward")
                            }
                            .disabled(!canvas.canUndo)

                            Button {
                                canvas.redo()
                            } label: {
                                Image(systemName: "arrow.uturn.forward")
                            }
                            .disabled(!canvas.canRedo)
                        }
                    }
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        if canvas.activeTool != nil {
                            Button {
                                canvas.activeTool = nil
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "xmark.circle.fill")
                                    Text(canvas.activeTool?.displayName ?? "")
                                        .font(.system(size: 12))
                                }
                                .foregroundStyle(Color(hex: "#3d9e6a"))
                            }
                        }

                        Menu {
                            Button(role: .destructive) {
                                showClearConfirm = true
                            } label: {
                                Label("Clear Canvas", systemImage: "trash")
                            }
                            Button {
                                shareText = canvas.render()
                            } label: {
                                Label("Export Text", systemImage: "square.and.arrow.up")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }

                        Button {
                            showPicker = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(Color(hex: "#3d9e6a"))
                        }
                    }
                }
        }
        .sheet(isPresented: $showPicker) {
            ComponentPickerView()
                .environment(canvas)
        }
        .sheet(
            item: Binding(
                get: { shareText.map { ShareItem(text: $0) } },
                set: { shareText = $0?.text }
            )
        ) { item in
            ShareSheet(text: item.text)
        }
        .confirmationDialog("Clear Canvas", isPresented: $showClearConfirm, titleVisibility: .visible) {
            Button("Clear", role: .destructive) { canvas.clear() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will erase everything on the canvas.")
        }
    }
}

struct ShareItem: Identifiable {
    let id = UUID()
    let text: String
}

struct ShareSheet: UIViewControllerRepresentable {
    let text: String
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [text], applicationActivities: nil)
    }
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}
