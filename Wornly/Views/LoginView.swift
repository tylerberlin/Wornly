import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            Text("Login to Wornly")
                .font(.largeTitle)
                .fontWeight(.bold)
            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            HStack {
                Group {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }
                }
                Button(action: { isPasswordVisible.toggle() }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            Button(action: handleLogin) {
                Text("Login")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            HStack {
                Text("Don't have an account?")
                    .foregroundColor(.secondary)
                Button("Sign up") {
                    // Placeholder: Show alert or handle sign up action
                    errorMessage = "Sign up flow is not implemented."
                }
                .fontWeight(.semibold)
            }
            .padding(.top, 8)
            Divider()
            SignInWithAppleButton(.signIn) { request in
                // Configure request (you can leave empty for demo)
            } onCompletion: { result in
                switch result {
                case .success(_):
                    isLoggedIn = true // Demo; should verify credentials in real usage
                case .failure(let error):
                    errorMessage = "Apple sign in failed: \(error.localizedDescription)"
                }
            }
            .signInWithAppleButtonStyle(.black)
            .frame(height: 45)
            .padding(.horizontal)
            Button(action: handleGoogleLogin) {
                HStack {
                    Image(systemName: "globe")
                    Text("Sign in with Google")
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.horizontal)
            }
            Spacer()
        }
    }
    
    private func handleLogin() {
        // Simple hardcoded credentials (for demo only)
        if email.lowercased() == "test@wornly.com" && password == "password" {
            isLoggedIn = true
            errorMessage = nil
        } else {
            errorMessage = "Invalid email or password."
        }
    }
    
    private func handleGoogleLogin() {
        // Placeholder for Google Sign-In integration
        isLoggedIn = true // Demo: just logs in for now
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(false))
}
