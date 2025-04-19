//
//  AuthManager.swift
//  ExpenseTracker
//
//  Created by Julio Varela on 3/14/25.
//
import Foundation
import FirebaseAuth

@Observable
class AuthManager {
    var user: User?
    var isSignedIn: Bool = false
    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        // Automatically listen for changes in auth state
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
            self?.isSignedIn = user != nil
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    /// Sign up with email and password
    func signUp(email: String, password: String) async throws {
        do {
            _ = try await Auth.auth().createUser(withEmail: email, password: password)
            // No need to manually set `user` — the listener will pick it up
        } catch {
            throw error
        }
    }

    /// Sign in with email and password
    func signIn(email: String, password: String) async throws {
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
            // No need to manually set `user` — the listener will pick it up
        } catch {
            throw error
        }
    }

    /// Sign out the current user
    func signOut() {
        do {
            try Auth.auth().signOut()
            // Listener will set user = nil and isSignedIn = false
        } catch {
            print("Sign out failed: \(error.localizedDescription)")
        }
    }

    /// Get the current user's email (optional)
    var userEmail: String? {
        return user?.email
    }
}

