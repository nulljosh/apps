import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "globe")
                .font(.system(size: 64))
                .foregroundStyle(.blue)

            Text("Browser")
                .font(.largeTitle.bold())

            Text("Version 2.0.0")
                .font(.title3)
                .foregroundStyle(.secondary)

            Text("A native macOS web browser built with WebKit and SwiftUI.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .frame(maxWidth: 300)

            Divider()
                .frame(width: 200)

            VStack(spacing: 4) {
                Text("Built by Joshua Trommel")
                    .font(.callout)
                Text("MIT License 2026")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Link("View on GitHub", destination: URL(string: "https://github.com/nulljosh/browser")!)
                .font(.callout)
        }
        .padding(32)
        .frame(width: 380, height: 360)
    }
}
