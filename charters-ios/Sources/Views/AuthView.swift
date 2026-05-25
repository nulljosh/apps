import SwiftUI

enum AuthMode { case login, register }

struct AuthView: View {
    @EnvironmentObject var auth: AuthManager
    @EnvironmentObject var cases: CaseStore
    @Environment(\.dismiss) var dismiss

    @State private var mode: AuthMode = .login
    @State private var username = ""
    @State private var password = ""
    @State private var name = ""
    @State private var error = ""

    var body: some View {
        ZStack {
            Color(hex: "0c1220").ignoresSafeArea()
            VStack(spacing: 16) {
                Text(mode == .login ? "Sign In" : "Create Account")
                    .font(.system(size: 20, weight: .semibold, design: .serif))
                    .foregroundColor(Color(hex: "e8e4da"))
                if mode == .register {
                    TextField("Display name", text: $name)
                        .charterFieldStyle()
                }
                TextField("Username", text: $username)
                    .charterFieldStyle()
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                SecureField("Password", text: $password)
                    .charterFieldStyle()
                if !error.isEmpty {
                    Text(error)
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "c77040"))
                        .multilineTextAlignment(.center)
                }
                Button(mode == .login ? "Sign In" : "Create Account") { submit() }
                    .font(.system(size: 14, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color(hex: "1a5a96"))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                Button(mode == .login ? "No account? Register" : "Have an account? Sign in") {
                    withAnimation { mode = mode == .login ? .register : .login }
                    error = ""
                }
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "4a6070"))
            }
            .padding(28)
            .background(Color(hex: "111c2e"))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "1f3050"), lineWidth: 1))
            .padding(.horizontal, 32)
        }
        .preferredColorScheme(.dark)
    }

    func submit() {
        do {
            if mode == .login {
                try auth.login(username: username, password: password)
            } else {
                try auth.register(username: username, name: name, password: password)
            }
            cases.load(for: auth.currentUser!.username)
            dismiss()
        } catch {
            self.error = error.localizedDescription
        }
    }
}

private extension View {
    func charterFieldStyle() -> some View {
        self
            .padding(10)
            .background(Color(hex: "0c1220"))
            .foregroundColor(Color(hex: "e8e4da"))
            .font(.system(size: 14))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "1f3050"), lineWidth: 1))
    }
}
