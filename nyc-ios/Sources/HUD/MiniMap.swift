import SwiftUI

struct MiniMap: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 0.05, green: 0.11, blue: 0.16).opacity(0.85))
                .frame(width: 150, height: 150)
            Text("MINIMAP")
                .font(.system(size: 10))
                .foregroundStyle(.white.opacity(0.3))
        }
        .overlay(
            Rectangle()
                .stroke(Color(red: 0, green: 0.96, blue: 0.83).opacity(0.4), lineWidth: 2)
        )
    }
}
