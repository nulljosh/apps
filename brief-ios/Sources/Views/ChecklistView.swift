import SwiftUI

struct ChecklistView: View {
    @Environment(Store.self) private var store

    private var completedCount: Int { store.completedItems.count }
    private var total: Int { caseChecklist.count }
    private var progress: Double { Double(completedCount) / Double(total) }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                Text("Before the appointment.")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(completedCount)/\(total)")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 10)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2).fill(Color.secondary.opacity(0.2)).frame(height: 3)
                    RoundedRectangle(cornerRadius: 2).fill(Color.briefGreen).frame(width: geo.size.width * progress, height: 3)
                }
            }
            .frame(height: 3)
            .padding(.bottom, 10)

            ForEach(caseChecklist) { item in
                let done = store.completedItems.contains(item.id)
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(done ? Color.briefGreen : Color.clear)
                            .frame(width: 18, height: 18)
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(done ? Color.briefGreen : Color.secondary.opacity(0.5), lineWidth: 1.5)
                            .frame(width: 18, height: 18)
                        if done {
                            Image(systemName: "checkmark")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    }
                    Text(item.label)
                        .font(.system(size: 13))
                        .foregroundStyle(done ? .secondary : .primary)
                        .strikethrough(done, color: .secondary)
                        .lineLimit(nil)
                    Spacer()
                    if !done {
                        switch item.priority {
                        case .now:
                            Text("now")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.briefDanger)
                        case .soon:
                            Text("soon")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.briefWarn)
                        case .none:
                            EmptyView()
                        }
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    @Observable class Hack {}
                    withAnimation(.easeInOut(duration: 0.15)) {
                        if store.completedItems.contains(item.id) {
                            store.completedItems.remove(item.id)
                        } else {
                            store.completedItems.insert(item.id)
                        }
                    }
                }
                .padding(.vertical, 10)
                if item.id < caseChecklist.count - 1 {
                    Divider()
                }
            }
        }
        .padding(18)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}
