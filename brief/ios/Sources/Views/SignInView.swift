import SwiftUI

struct SignInView: View {
    @Environment(Store.self) private var store
    @State private var email = ""

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(alignment: .leading, spacing: 4) {
                Text("Brief")
                    .font(.system(size: 28, weight: .black))
                    .tracking(-1.1)
                Text("Trommel v. AG Canada · private")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 28)

                if store.magicLinkSent {
                    Text("Link sent")
                        .font(.system(size: 18, weight: .bold))
                        .padding(.bottom, 4)
                    Text("Check your email and tap the link to sign in.")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(.secondary)
                } else {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .padding(13)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                        .padding(.bottom, 10)

                    Button {
                        Task { await store.signIn(email: email.trimmingCharacters(in: .whitespaces).lowercased()) }
                    } label: {
                        Text("Send sign-in link")
                            .font(.system(size: 15, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(14)
                            .background(Color.primary)
                            .foregroundStyle(Color(uiColor: .systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    if let err = store.signInError {
                        Text(err)
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundStyle(.red)
                            .padding(.top, 8)
                    }
                }
            }
            .padding(32)
            .frame(maxWidth: 360)
            Spacer()
            Text("not legal advice")
                .font(.system(size: 10, design: .monospaced))
                .foregroundStyle(.tertiary)
                .padding(.bottom, 24)
        }
    }
}
