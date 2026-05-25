import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var auth: AuthManager
    @EnvironmentObject var cases: CaseStore
    @Binding var selectedCountry: Country?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    if let user = auth.currentUser {
                        Text(user.name)
                            .font(.system(size: 22, weight: .bold, design: .serif))
                            .foregroundColor(Color(hex: "e8e4da"))
                        Text("MY CASES")
                            .font(.system(size: 10, weight: .medium))
                            .tracking(1.5)
                            .foregroundColor(Color(hex: "4a6070"))
                            .padding(.top, 4)
                        if cases.cases.isEmpty {
                            Text("No cases yet.")
                                .font(.system(size: 13))
                                .foregroundColor(Color(hex: "4a6070"))
                                .padding(.vertical, 8)
                        } else {
                            ForEach(cases.cases) { c in
                                CaseCardView(legalCase: c, selectedCountry: $selectedCountry)
                            }
                            .onDelete { cases.delete(at: $0) }
                        }
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color(hex: "0c1220"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color(hex: "7a8e9e"))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sign Out") {
                        auth.logout()
                        cases.clear()
                        dismiss()
                    }
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "4a6070"))
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct CaseCardView: View {
    let legalCase: LegalCase
    @Binding var selectedCountry: Country?
    @Environment(\.dismiss) var dismiss

    var typeColor: Color { legalCase.type == "charter" ? Color(hex: "4e9cd7") : Color(hex: "c4956a") }
    var typeLabel: String { legalCase.type == "charter" ? "Charter Claim" : "Civil Claim" }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(typeLabel.uppercased())
                .font(.system(size: 9, weight: .semibold))
                .tracking(1.2)
                .foregroundColor(typeColor)
                .padding(.horizontal, 8).padding(.vertical, 3)
                .background(typeColor.opacity(0.08))
                .overlay(RoundedRectangle(cornerRadius: 100).stroke(typeColor.opacity(0.3), lineWidth: 1))
                .clipShape(Capsule())
            Text(legalCase.title)
                .font(.system(size: 15, weight: .semibold, design: .serif))
                .foregroundColor(Color(hex: "e8e4da"))
            if !legalCase.verdict.isEmpty {
                Text(legalCase.verdict)
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "7a8e9e"))
                    .lineSpacing(3)
            }
            if !legalCase.sections.isEmpty {
                Text("RELEVANT SECTIONS")
                    .font(.system(size: 9, weight: .medium)).tracking(1.2)
                    .foregroundColor(Color(hex: "4a6070"))
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(legalCase.sections, id: \.self) { sec in
                            Button(sec) {
                                if let canada = chartersData.first(where: { $0.id == legalCase.country }) {
                                    selectedCountry = canada
                                }
                                dismiss()
                            }
                            .font(.system(size: 11))
                            .foregroundColor(Color(hex: "4e9cd7"))
                            .padding(.horizontal, 8).padding(.vertical, 3)
                            .background(Color(hex: "4e9cd7").opacity(0.07))
                            .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color(hex: "4e9cd7").opacity(0.25), lineWidth: 1))
                            .clipShape(Capsule())
                        }
                    }
                }
            }
            ForEach(legalCase.claims) { cl in
                VStack(alignment: .leading, spacing: 3) {
                    Text(cl.ref.uppercased())
                        .font(.system(size: 9, weight: .medium)).tracking(1)
                        .foregroundColor(Color(hex: "4a6070"))
                    Text(cl.title)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(hex: "c8c4bc"))
                    if !cl.note.isEmpty {
                        Text(cl.note)
                            .font(.system(size: 11))
                            .foregroundColor(Color(hex: "7a8e9e"))
                            .lineSpacing(2)
                    }
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(hex: "080f18"))
                .clipShape(RoundedRectangle(cornerRadius: 7))
                .overlay(RoundedRectangle(cornerRadius: 7).stroke(Color(hex: "1f3050"), lineWidth: 1))
            }
            if !legalCase.bottomLine.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("BOTTOM LINE")
                        .font(.system(size: 9, weight: .semibold)).tracking(1.2)
                        .foregroundColor(Color(hex: "4a6070"))
                    Text(legalCase.bottomLine)
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "7a8e9e"))
                        .lineSpacing(3)
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(hex: "080f18").opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: 7))
                .overlay(RoundedRectangle(cornerRadius: 7).stroke(Color(hex: "1f3050"), lineWidth: 1))
            }
        }
        .padding(14)
        .background(Color(hex: "111c2e"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "1f3050"), lineWidth: 1))
    }
}
