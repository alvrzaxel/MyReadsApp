//
//  AuthenticationViewModel.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 20/7/24.
//

import Foundation
import UIKit

import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published var user: User?
    @Published var messageError: String?
    @Published var linkedAccounts: [LinkedAccounts] = []
    @Published var showAlert: Bool = false
    @Published var alertMessage: String?
    @Published var shouldDismiss: Bool = false
    
    private let authenticationRepository: AuthenticationRepository
    private let userProfileRepository = UserProfileRepository()
    
    init(authenticationRepository: AuthenticationRepository = AuthenticationRepository()) {
        self.authenticationRepository = authenticationRepository
        getCurrentUser()
    }
    
    func getCurrentUser() {
        self.user = authenticationRepository.getCurrentUser()
    }
    
    func createNewUser(email: String, password: String) {
        Task {
            do {
                let user = try await authenticationRepository.createNewUser(email: email, password: password)
                try await userProfileRepository.createBDUser(auth: user)
                self.user = user
            } catch {
                self.messageError = error.localizedDescription
            }
        }
    }
    
    
    
    func login(email: String, password: String) {
        Task {
            do {
                let user = try await authenticationRepository.login(email: email, password: password)
                self.user = user
            } catch {
                self.messageError = error.localizedDescription
            }
        }
    }
    
    
    func loginWithGoogle() {
        Task {
            do {
                // Inicia sesión con Google
                let user = try await authenticationRepository.loginWithGoogle()
                
                // Verifica si el usuario ya existe en la base de datos
                let existingUser = try await userProfileRepository.getBSUser(userId: user.uid)
                
                if existingUser == nil {
                    // Si el usuario no existe, crea un nuevo registro
                    try await userProfileRepository.createBDUser(auth: user)
                } else {
                    // Si el usuario ya existe, solo actualiza los campos necesarios si corresponde
                    try await userProfileRepository.updateUser(auth: user)
                }
                
                // Actualiza el estado del usuario en el ViewModel
                self.user = user
                
            } catch {
                self.messageError = error.localizedDescription
            }
        }
    }
    
    
    func cleanErrorMessage() {
        self.messageError = nil
    }
    
    func updatePassword(newPassword: String) {
        Task {
            do {
                try await authenticationRepository.updatePassword(newPassword: newPassword)
                self.alertMessage = "Password update"
            } catch {
                self.alertMessage = "Error updating password: \(error.localizedDescription)"
            }
            self.showAlert = true
        }
    }
    
    
    func resetPassword(email: String) {
        Task {
            do {
                try await authenticationRepository.resetPassword(email: email)
                self.alertMessage = "Password reset email sent successfully"
            } catch {
                self.alertMessage = "Error sending password reset email: \(error.localizedDescription)"
            }
            self.showAlert = true
        }
    }
    
    
    func logout() {
        do {
            try authenticationRepository.logout()
            self.user = nil
            self.shouldDismiss = true
        } catch {
            print("Error logout")
        }
    }
    
    
    func getCurrentProvider() {
        linkedAccounts = authenticationRepository.getCurrentProvider()
    }
    
    
    func isEmailAndPasswordLinked() -> Bool {
        linkedAccounts.contains(where: { $0.rawValue == "password"})
    }
    
    
    func isGoogleLinked() -> Bool {
        linkedAccounts.contains(where: { $0.rawValue == "google.com"})
    }
    
}
