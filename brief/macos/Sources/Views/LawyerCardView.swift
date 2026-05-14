import SwiftUI

struct LawyerCardView: View {
    let lawyer: Lawyer
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 9)
                        .fill(Color.secondary.opacity(0.12))
                        .overlay(RoundedRectangle(cornerRadius: 9).stroke(Color.secondary.opacity(0.2)))
                        .frame(width: 46, height: 46)
                    Text(lawyer.initials)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.primary)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(lawyer.name)
                        .font(.system(size: 15, weight: .semibold))
                    Text(lawyer.subtitle)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 5) {
                            ForEach(lawyer.tags, id: \.label) { tag in
                                Text(tag.label)
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundStyle(tagColor(tag.style))
                                    .padding(.horizontal, 7)
                                    .padding(.vertical, 3)
                                    .background(tagColor(tag.style).opacity(0.12), in: Capsule())
                            }
                        }
                    }
                    .padding(.top, 4)
                }
            }
            .padding([.horizontal, .top], 16)
            .padding(.bottom, 12)

            HStack(spacing: 8) {
                if let phone = lawyer.phone {
                    Button {
                        openURL(URL(string: "tel://\(phone)")!)
                    } label: {
                        HStack(spacing: 6) {
                            Text(formatPhone(phone))
                                .font(.system(size: 13, weight: .bold))
                            if let note = lawyer.phoneNote {
                                Text(note)
                                    .font(.system(size: 10, design: .monospaced))
                                    .opacity(0.6)
                            }
                            Image(systemName: "phone.fill")
                                .font(.system(size: 12))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.briefAccent, in: RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                }
                if let email = lawyer.email {
                    Button {
                        openURL(URL(string: "mailto:\(email)")!)
                    } label: {
                        HStack(spacing: 6) {
                            Text(email)
                                .font(.system(size: 12, weight: .semibold))
                            Image(systemName: "envelope")
                                .font(.system(size: 12))
                        }
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                }
                if let website = lawyer.website {
                    Button {
                        openURL(URL(string: "https://\(website)")!)
                    } label: {
                        HStack(spacing: 6) {
                            Text(website)
                                .font(.system(size: 12, weight: .semibold))
                            Image(systemName: "safari")
                                .font(.system(size: 12))
                        }
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding([.horizontal, .bottom], 16)
        }
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private func tagColor(_ style: TagStyle) -> Color {
        switch style {
        case .good: return .briefGreen
        case .urgent: return .briefWarn
        case .fail: return .briefDanger
        case .neutral: return .secondary
        }
    }

    private func formatPhone(_ raw: String) -> String {
        guard raw.count == 10 else { return raw }
        let a = raw.prefix(3), b = raw.dropFirst(3).prefix(3), c = raw.suffix(4)
        return "\(a)-\(b)-\(c)"
    }
}
