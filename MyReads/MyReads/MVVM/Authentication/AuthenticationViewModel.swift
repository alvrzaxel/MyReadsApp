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
    @Published var showAlert: Bool = false
    @Published var messageAlert: String?
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
                
            } catch {
                self.messageError = error.localizedDescription
                self.showAlert = true
            }
        }
    }
    
    
    // Limpia cualquier mensaje
    func cleanAnyMessage() {
        cleanMessageError()
        cleanMessageAlert()
        self.messageAlert = nil
    }
    
    // Limpia el mensaje de error
    func cleanMessageError() {
        self.messageError = nil
    }
    
    // Limpia el mensaje de alerta
    func cleanMessageAlert() {
        self.messageAlert = nil
    }
    
    
    // Actualiza la contraseña del usuario
    func updatePassword(newPassword: String) {
        Task {
            do {
                try await authenticationRepository.updatePassword(newPassword: newPassword)
                self.messageAlert = "Password update"
            } catch {
                self.messageAlert = "Error updating password: \(error.localizedDescription)"
            }
            self.showAlert = true
        }
    }
    
    
    // Restablece la contraseña del usuario enviando un mail
    func resetPassword(email: String) {
        Task {
            do {
                try await authenticationRepository.resetPassword(email: email)
                self.messageAlert = "Password reset email sent successfully"
            } catch {
                self.messageError = "Error sending password reset email: \(error.localizedDescription)"
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
                self.messageAlert = "Error deleting user account"
            }
        }
        
    }

    
}
