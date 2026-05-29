import SwiftUI
import WebKit
#if canImport(UIKit)
import UIKit
#endif

private struct Resource: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let filename: String
}

private let resources: [Resource] = [
    Resource(name: "PC12 Masterclass", description: "Units 1–7 full reference", filename: "masterclass"),
    Resource(name: "Module 1 Cram Sheet", description: "Sequences, Transformations, Polynomials", filename: "cram-m1"),
]

struct ResourcesView: View {
    var body: some View {
        NavigationStack {
            List(resources) { resource in
                NavigationLink {
                    StudyPage(resource: resource)
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(resource.name).fontWeight(.medium)
                        Text(resource.description).font(.caption).foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 2)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Study")
        }
    }
}

private struct StudyPage: View {
    let resource: Resource
    @State private var webView = WKWebView()

    var body: some View {
        HTMLView(filename: resource.filename, webView: webView)
            .ignoresSafeArea()
            .navigationTitle(resource.name)
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { printPage() } label: {
                        Image(systemName: "printer")
                    }
                    .accessibilityLabel("Print")
                }
            }
    }

    // Low-ink print: page @media print CSS drops color; iOS adds grayscale output.
    private func printPage() {
        #if os(iOS)
        let info = UIPrintInfo(dictionary: nil)
        info.outputType = .grayscale
        info.jobName = resource.name
        let controller = UIPrintInteractionController.shared
        controller.printInfo = info
        controller.printFormatter = webView.viewPrintFormatter()
        controller.present(animated: true, completionHandler: nil)
        #else
        let op = webView.printOperation(with: NSPrintInfo.shared)
        op.view?.frame = webView.bounds
        op.run()
        #endif
    }
}

#if os(iOS)
struct HTMLView: UIViewRepresentable {
    let filename: String
    let webView: WKWebView
    func makeUIView(context: Context) -> WKWebView { webView }
    func updateUIView(_ v: WKWebView, context: Context) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "html") else { return }
        v.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
    }
}
#else
struct HTMLView: NSViewRepresentable {
    let filename: String
    let webView: WKWebView
    func makeNSView(context: Context) -> WKWebView { webView }
    func updateNSView(_ v: WKWebView, context: Context) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "html") else { return }
        v.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
    }
}
#endif
