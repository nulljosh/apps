import SwiftUI
import WebKit

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
                    HTMLView(filename: resource.filename)
                        .ignoresSafeArea()
                        .navigationTitle(resource.name)
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(resource.name).fontWeight(.medium)
                        Text(resource.description).font(.caption).foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 2)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .navigationTitle("Study")
            .background(Color.black)
        }
    }
}

#if os(iOS)
struct HTMLView: UIViewRepresentable {
    let filename: String
    func makeUIView(context: Context) -> WKWebView { WKWebView() }
    func updateUIView(_ v: WKWebView, context: Context) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "html") else { return }
        v.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
    }
}
#else
struct HTMLView: NSViewRepresentable {
    let filename: String
    func makeNSView(context: Context) -> WKWebView { WKWebView() }
    func updateNSView(_ v: WKWebView, context: Context) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "html") else { return }
        v.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
    }
}
#endif
