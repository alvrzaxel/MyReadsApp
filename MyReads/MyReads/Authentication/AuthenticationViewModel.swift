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

// Anotacion para indicar que este viewmodel se ejecutara en el actor principal
@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published var user: UserModel?
    @Published var messageError: String?
    @Published var linkedAccounts: [LinkedAccounts] = []
    @Published var showAlert: Bool = false
    @Published var alertMessage: String?
    @Published var shouldDismiss: Bool = false
    
    // Repositorio para manejar la autenticación y sus opciones
    private let authenticationRepository: AuthenticationRepository
    // Repositorio para manejar el perfil del usuario
    private let userProfileRepository: UserProfileRepository
    
    // Inicializador que toma un repositorio de autenticación opcional
    init(
        authenticationRepository: AuthenticationRepository = AuthenticationRepository(),
        userProfileRepository: UserProfileRepository = UserProfileRepository()
    ) {
        self.authenticationRepository = authenticationRepository
        self.userProfileRepository = userProfileRepository
        
        
    }
    
    // Obtiene el usuario actual al iniciarse
    func getCurrentUser() {
        self.user = authenticationRepository.getCurrentUser()
    }
    
    
    // Crea un nuevo usuario con correo y contraseña
    func createNewUser(email: String, password: String) {
        Task {
            do {
                let newUser = try await authenticationRepository.createNewUser(email: email, password: password)
                self.user = newUser
            } catch {
                self.messageError = error.localizedDescription
                self.showAlert = true
            }
        }
    }
    
    
    // Inicia sesión con correo y contraseña
    func login(email: String, password: String) {
        Task {
            do {
                let loggedInUser = try await authenticationRepository.login(email: email, password: password)
                self.user = loggedInUser
            } catch {
                self.messageError = error.localizedDescription
                self.showAlert = true
            }
        }
    }
    
    func loginWithGoogle() {
        Task {
            do {
                let googleUser = try await authenticationRepository.loginWithGoogle()

                let existingUser = try? await userProfileRepository.getUserDocument(user: googleUser)
                
                if let existingUser = existingUser {
                    self.user = existingUser
                } else {
                    try await userProfileRepository.createUserDocument(user: googleUser)
                    self.user = googleUser
                }
                
               
                
                // Actualiza el perfil del usuario, si es necesario
                
            } catch {
                self.messageError = error.localizedDescription
                self.showAlert = true
            }
        }
    }
    
    
    // Limpia el mensaje de error
    func cleanErrorMessage() {
        self.messageError = nil
    }
    
    
    // Actualiza la contraseña del usuario
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
    
    
    // Restablece la contraseña del usuario
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
    
    
    // Cierra la sesión del usuario
    func logout() {
        do {
            try authenticationRepository.logout()
            self.user = nil
            self.shouldDismiss = true
        } catch {
            print("Error logout")
        }
    }
    
    
    // Elimina la cuenta del usuario
    func deleteAccount()  {
        Task {
            do {
                try await authenticationRepository.deleteAcount()
                self.user = nil
                self.shouldDismiss = true
                
            } catch {
                self.alertMessage = "Error deleting user account"
            }
        }
        
    }
    
    
    // Obtiene los proveedores de autenticacion vinculados al usuario actual
    func getCurrentProvider() {
        linkedAccounts = authenticationRepository.getCurrentProvider()
    }
    
    
    // Verifica si la cuenta de correo y contraseña esta vinculada
    func isEmailAndPasswordLinked() -> Bool {
        linkedAccounts.contains(where: { $0.rawValue == "password"})
    }
    
    
    // Verifica si la cuenta de Google esta vinculada
    func isGoogleLinked() -> Bool {
        linkedAccounts.contains(where: { $0.rawValue == "google.com"})
    }
    
}
