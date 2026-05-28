import SwiftUI

struct AuthView: View {
    var authService: AuthService

    @State private var tab: Tab = .signIn
    @State private var email = ""
    @State private var password = ""
    @State private var loading = false
    @State private var errorMessage: String?
    @State private var successMessage: String?

    enum Tab { case signIn, register }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 28) {
                VStack(spacing: 8) {
                    Image(systemName: "cross.vial.fill")
                        .font(.system(size: 36, weight: .medium))
                        .foregroundStyle(.tint)

                    Text("Dose")
                        .font(.title2.weight(.semibold))

                    Text("Health tracker")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Picker("", selection: $tab) {
                    Text("Sign in").tag(Tab.signIn)
                    Text("Register").tag(Tab.register)
                }
                .pickerStyle(.segmented)
                .onChange(of: tab) { _, _ in
                    errorMessage = nil
                    successMessage = nil
                }

                VStack(spacing: 12) {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .textFieldStyle(.roundedBorder)

                    SecureField("Password", text: $password)
                        .textContentType(tab == .signIn ? .password : .newPassword)
                        .textFieldStyle(.roundedBorder)
                }

                if let error = errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }

                if let success = successMessage {
                    Text(success)
                        .font(.caption)
                        .foregroundStyle(.green)
                        .multilineTextAlignment(.center)
                }

                Button {
                    Task { await submit() }
                } label: {
                    HStack {
                        if loading { ProgressView() }
                        Text(tab == .signIn ? "Sign in" : "Create account")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .disabled(loading || email.isEmpty || password.isEmpty)
            }
            .padding(28)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 20)

            Spacer()
        }
    }

    private func submit() async {
        guard !loading else { return }
        errorMessage = nil
        successMessage = nil
        loading = true
        defer { loading = false }

        do {
            if tab == .signIn {
                try await authService.signIn(email: email, password: password)
            } else {
                try await authService.signUp(email: email, password: password)
                successMessage = "Check your email to confirm your account, then sign in."
                tab = .signIn
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
