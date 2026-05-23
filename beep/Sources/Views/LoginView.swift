import SwiftUI

struct LoginView: View {
    @EnvironmentObject var session: BeepSession
    @State private var email = ""
    @State private var password = ""
    @State private var step = 0
    @State private var isLoading = false
    @State private var errorMessage: String?

    private let blue = Color(red: 0, green: 0.44, blue: 0.89)
    private var emailValid: Bool { email.contains("@") && email.contains(".") }

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                header
                    .padding(.top, 48)

                ZStack {
                    emailStep
                        .offset(x: step == 0 ? 0 : -UIScreen.main.bounds.width)
                        .opacity(step == 0 ? 1 : 0)

                    passwordStep
                        .offset(x: step == 1 ? 0 : UIScreen.main.bounds.width)
                        .opacity(step == 1 ? 1 : 0)
                }
                .animation(.easeInOut(duration: 0.28), value: step)
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 32)
        }
        .onAppear {
            if let (stored, _) = try? KeychainManager.loadCredentials() {
                email = stored
            }
            if BiometricAuth.isAvailable && KeychainManager.hasCredentials {
                Task { await signInWithBiometrics() }
            }
        }
    }

    private var header: some View {
        VStack(spacing: 10) {
            Image(systemName: "tram.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(blue)
            Text("Beep")
                .font(.largeTitle.bold())
            Text(step == 0 ? "Sign in to your Compass Card account" : "Enter your password")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .animation(.easeInOut(duration: 0.2), value: step)
        }
    }

    private var emailStep: some View {
        VStack(spacing: 12) {
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .padding(14)
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .onSubmit { if emailValid { advance() } }

            actionButton(title: "Continue", enabled: emailValid && !isLoading) {
                advance()
            }

            if BiometricAuth.isAvailable && KeychainManager.hasCredentials {
                biometricButton
            }
        }
    }

    private var passwordStep: some View {
        VStack(spacing: 12) {
            // Email chip with back tap
            Button { retreat() } label: {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.caption.weight(.semibold))
                    Text(email)
                        .font(.subheadline)
                    Spacer()
                }
                .foregroundStyle(blue)
                .padding(14)
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)

            SecureField("Password", text: $password)
                .textContentType(.password)
                .padding(14)
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .onSubmit { if !password.isEmpty { Task { await signIn() } } }

            if let error = errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            actionButton(title: "Sign In", enabled: !password.isEmpty && !isLoading) {
                Task { await signIn() }
            }
        }
    }

    private var biometricButton: some View {
        Button { Task { await signInWithBiometrics() } } label: {
            HStack(spacing: 8) {
                Image(systemName: BiometricAuth.isFaceID ? "faceid" : "touchid")
                Text("Sign in with \(BiometricAuth.isFaceID ? "Face ID" : "Touch ID")")
            }
            .font(.subheadline)
            .foregroundStyle(blue)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func actionButton(title: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Group {
                if isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text(title).font(.subheadline.weight(.semibold))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(enabled ? blue : Color.secondary.opacity(0.4))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .disabled(!enabled)
        .buttonStyle(.plain)
    }

    private func advance() {
        errorMessage = nil
        withAnimation { step = 1 }
    }

    private func retreat() {
        errorMessage = nil
        password = ""
        withAnimation { step = 0 }
    }

    private func signIn() async {
        isLoading = true
        errorMessage = nil
        let result = await session.submitLogin(email: email, password: password)
        isLoading = false
        switch result {
        case .success:
            try? KeychainManager.saveCredentials(email: email, password: password)
        case .failure(let err):
            errorMessage = err.message
        }
    }

    private func signInWithBiometrics() async {
        guard let (storedEmail, storedPassword) = try? KeychainManager.loadCredentials() else { return }
        guard await BiometricAuth.authenticate() else { return }
        email = storedEmail
        password = storedPassword
        if step == 0 { withAnimation { step = 1 } }
        await signIn()
    }
}
