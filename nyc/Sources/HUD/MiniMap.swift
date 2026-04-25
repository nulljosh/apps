import SwiftUI

struct MiniMap: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 0.04, green: 0.04, blue: 0.05).opacity(0.85))
                .frame(width: 150, height: 150)
            Text("MINIMAP")
                .font(.system(size: 10))
                .foregroundStyle(.white.opacity(0.3))
        }
        .overlay(
            Rectangle()
                .stroke(Color(red: 0.39, green: 0.82, blue: 1.0).opacity(0.4), lineWidth: 2)
        )
    }
}
