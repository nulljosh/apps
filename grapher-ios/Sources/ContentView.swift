import SwiftUI

struct ContentView: View {
    @State private var store = EquationStore()
    @State private var showShareSheet = false
    @State private var exportedImage: UIImage?

    var body: some View {
        Group {
            if UIDevice.current.userInterfaceIdiom == .pad {
                iPadLayout
            } else {
                iPhoneLayout
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showShareSheet) {
            if let img = exportedImage {
                ShareSheet(items: [img])
            }
        }
    }

    // MARK: - iPhone layout: graph top 60%, equations bottom 40%

    private var iPhoneLayout: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                GraphCanvasView(equations: store.equations)
                    .frame(height: geo.size.height * 0.60)

                EquationListView(store: store, onExport: exportGraph)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .frame(height: geo.size.height * 0.40)
            }
            .background(Color(hex: "0d0c0b"))
        }
        .ignoresSafeArea(edges: .top)
    }

    // MARK: - iPad layout: sidebar equations, detail graph

    private var iPadLayout: some View {
        NavigationSplitView {
            VStack(spacing: 0) {
                EquationListView(store: store, onExport: exportGraph)
                    .padding(16)
                Spacer()
            }
            .background(Color(hex: "0d0c0b"))
            .navigationTitle("Grapher")
            .navigationBarTitleDisplayMode(.inline)
        } detail: {
            GraphCanvasView(equations: store.equations)
                .ignoresSafeArea()
        }
    }

    // MARK: - Export

    private func exportGraph() {
        let renderer = ImageRenderer(content:
            GraphCanvasView(equations: store.equations)
                .frame(width: 1080, height: 1080)
        )
        renderer.scale = 2
        if let img = renderer.uiImage {
            exportedImage = img
            showShareSheet = true
        }
    }
}

// MARK: - UIActivityViewController wrapper

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}
