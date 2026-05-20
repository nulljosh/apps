import SwiftUI

struct SignInView: View {
    @Environment(Store.self) private var store
    @State private var email = ""
    @State private var password = ""
    @FocusState private var focused: Field?

    private enum Field { case email, password }

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

                if store.authStep == .email {
                    TextField("Email", text: $email)
                        .autocorrectionDisabled()
                        .focused($focused, equals: .email)
                        .padding(13)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                        .padding(.bottom, 10)
                        .onSubmit { submitEmail() }

                    Button(action: submitEmail) {
                        Text("Continue")
                            .font(.system(size: 15, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(14)
                            .background(Color.primary)
                            .foregroundStyle(Color(nsColor: .windowBackgroundColor))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(email.trimmingCharacters(in: .whitespaces).isEmpty)
                } else {
                    HStack(spacing: 12) {
                        Text(email.prefix(1).uppercased())
                            .font(.system(size: 15, weight: .bold))
                            .frame(width: 36, height: 36)
                            .background(Color.primary)
                            .foregroundStyle(Color(nsColor: .windowBackgroundColor))
                            .clipShape(Circle())
                        Text(email.trimmingCharacters(in: .whitespaces).lowercased())
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                    .padding(12)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                    .padding(.bottom, 10)

                    SecureField("Password", text: $password)
                        .focused($focused, equals: .password)
                        .padding(13)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                        .padding(.bottom, 10)
                        .onSubmit { submitPassword() }

                    Button(action: submitPassword) {
                        Text("Sign in")
                            .font(.system(size: 15, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(14)
                            .background(Color.primary)
                            .foregroundStyle(Color(nsColor: .windowBackgroundColor))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(password.isEmpty)

                    Button {
                        store.resetAuthStep()
                        password = ""
                        focused = .email
                    } label: {
                        Text("Back")
                            .font(.system(size: 11, design: .monospaced))
                            .foregroundStyle(.tertiary)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 8)
                }

                if let err = store.signInError {
                    Text(err)
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundStyle(.red)
                        .padding(.top, 8)
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
        .onAppear { focused = .email }
    }

    private func submitEmail() {
        let e = email.trimmingCharacters(in: .whitespaces).lowercased()
        store.confirmEmail(email: e)
        if store.authStep == .password { focused = .password }
    }

    private func submitPassword() {
        let e = email.trimmingCharacters(in: .whitespaces).lowercased()
        Task { await store.signIn(email: e, password: password) }
    }
}
