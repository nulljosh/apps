import SwiftUI

struct LoginView: View {
    @EnvironmentObject var session: BeepSession
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?

    private var canSubmit: Bool { !email.isEmpty && !password.isEmpty && !isLoading }

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                VStack(spacing: 10) {
                    Image(systemName: "tram.circle.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(Color(red: 0, green: 0.44, blue: 0.89))
                    Text("Beep")
                        .font(.largeTitle.bold())
                    Text("Sign in to your Compass Card account")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 48)

                VStack(spacing: 12) {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .padding(14)
                        .background(Color(UIColor.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .padding(14)
                        .background(Color(UIColor.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                if let error = errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Button {
                    Task { await signIn() }
                } label: {
                    Group {
                        if isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Sign In").font(.subheadline.weight(.semibold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(canSubmit ? Color(red: 0, green: 0.44, blue: 0.89) : Color.secondary.opacity(0.4))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(!canSubmit)
                .buttonStyle(.plain)

                if BiometricAuth.isAvailable && KeychainManager.hasCredentials {
                    Button {
                        Task { await signInWithBiometrics() }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: BiometricAuth.isFaceID ? "faceid" : "touchid")
                            Text("Sign in with \(BiometricAuth.isFaceID ? "Face ID" : "Touch ID")")
                        }
                        .font(.subheadline)
                        .foregroundStyle(Color(red: 0, green: 0.44, blue: 0.89))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 32)
        }
        .onAppear {
            if let (storedEmail, _) = try? KeychainManager.loadCredentials() {
                email = storedEmail
            }
            if BiometricAuth.isAvailable && KeychainManager.hasCredentials {
                Task { await signInWithBiometrics() }
            }
        }
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
        await signIn()
    }
}
