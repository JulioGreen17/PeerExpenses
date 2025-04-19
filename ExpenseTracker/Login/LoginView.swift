//
//  LoginView.swift
//  ExpenseTracker
//
//  Created by Julio Varela on 1/31/25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @Environment(AuthManager.self) var authManager

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var alertMessage: String = ""
    @State private var showingAlert: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            content
                .padding()
                .withTopToolbar(title: "")
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
    }

    @ViewBuilder
    private var content: some View {
        NavigationStack {
            VStack {
                Spacer()

                VStack(spacing: 20) {
                    Image(systemName: "lock.circle.fill")
                        .resizable()
                        .frame(width: 75, height: 75)
                        .foregroundColor(Color("lightBlue"))

                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .padding(.horizontal)

                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .padding(.horizontal)

                    Button("Login") {
                        if email.isEmpty || password.isEmpty {
                            alertMessage = "Please enter all fields"
                            showingAlert = true
                        } else {
                            Task {
                                print("Attempting login with email: \(email), password: \(password)")

                                do {
                                    try await authManager.signIn(email: email, password: password)
                                } catch {
                                    alertMessage = "Your username/password is invalid. Please try again."
                                    showingAlert = true
                                }
                            }
                        }
                    }
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("lightBlue"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)

                    Button("Sign Up") {
                        if email.isEmpty || password.isEmpty {
                            alertMessage = "Please enter all fields"
                            showingAlert = true
                        } else {
                            Task {
                                print("Attempting signup with email: \(email), password: \(password)")

                                do {
                                    try await authManager.signUp(email: email, password: password)
                                } catch {
                                    let errorCode = (error as NSError).code
                                    switch errorCode {
                                    case AuthErrorCode.emailAlreadyInUse.rawValue:
                                        alertMessage = "This email is already registered. Please log in or use a different email."
                                    case AuthErrorCode.invalidEmail.rawValue:
                                        alertMessage = "Invalid email address. Please try again."
                                    case AuthErrorCode.weakPassword.rawValue:
                                        alertMessage = "Password is too weak. It must be at least 6 characters."
                                    default:
                                        alertMessage = "Sign up failed. Please try again."
                                    }
                                    showingAlert = true
                                }
                            }
                        }
                    }

                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("lightBlue"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }

                Spacer()
            }
        }
    }
}

#Preview {
    LoginView()
        .environment(AuthManager())
}
