//
//  AuthenticationFirebaseDatasource.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 20/7/24.
//

import Foundation
import FirebaseAuth
import UIKit

final class AuthenticationFirebaseDatasource {
    
    // Instancia para manejar la autenticación de Google
    private let googleAuthentication = GoogleAuthentication()
    
    // Obtiene el usuario actualmente autenticado
    func getCurrentUser() -> UserModel? {
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        
        return UserModel(
            uid: user.uid,
            displayName: user.displayName,
            email: user.email,
            emailVerified: user.isEmailVerified,
            photoURL: user.photoURL?.absoluteString,
            providerID: user.providerData.first?.providerID,
            creationDate: user.metadata.creationDate
        )
    }
    
    // Crea y retorna un objeto `UserModel` con la información del usuario autenticado
    func createNewUser(email: String, password: String) async throws -> UserModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        
        let user = authDataResult.user
        return UserModel(
            uid: user.uid,
            displayName: user.displayName,
            email: user.email,
            emailVerified: user.isEmailVerified,
            photoURL: user.photoURL?.absoluteString,
            providerID: user.providerData.first?.providerID,
            creationDate: user.metadata.creationDate
        )
    }
    
    // Inicia sesión con correo electrónico y contraseña
    func login(email: String, password: String) async throws -> UserModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        
        let user = authDataResult.user
        return UserModel(
            uid: user.uid,
            displayName: user.displayName,
            email: user.email,
            emailVerified: user.isEmailVerified,
            photoURL: user.photoURL?.absoluteString,
            providerID: user.providerData.first?.providerID,
            creationDate: user.metadata.creationDate
        )
    }
    
    // Inicia sesión con Google
    func loginWithGoogle() async throws -> UserModel {
        let credential = try await googleAuthentication.signInWithGoogle()
        let authDataResult = try await Auth.auth().signIn(with: credential)
        let user = authDataResult.user
        
        return UserModel(
            uid: user.uid,
            displayName: user.displayName,
            email: user.email,
            emailVerified: user.isEmailVerified,
            photoURL: user.photoURL?.absoluteString,
            providerID: user.providerData.first?.providerID,
            creationDate: user.metadata.creationDate
        )
    }
    
    // Actualiza la contraseña del usuario actual
    func updatePassword(newPassword: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "No current user found"])
        }
        
        try await user.updatePassword(to: newPassword)
    }
    
    // Envía un correo electrónico para restablecer la contraseña
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    // Cierra sesión del usuario actual
    func logout() throws {
        try Auth.auth().signOut()
    }
    
    // Elimina la cuenta del usuario actual
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedFailureErrorKey: "No current user found"])
        }
        
        try await user.delete()
    }
    
}
