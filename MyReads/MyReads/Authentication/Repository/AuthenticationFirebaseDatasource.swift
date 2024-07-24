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
    func getCurrentUser() -> User? {
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        
        return User(uid: user.uid, email: user.email ?? "No Email", photoURL: user.photoURL?.absoluteString)
    }
    
    // Crea y retorna un objeto `User` con la información del usuario autenticado
    func createNewUser(email: String, password: String) async throws -> User {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        
        let user = User(uid: authDataResult.user.uid, email: authDataResult.user.email ?? "No email", photoURL: authDataResult.user.photoURL?.absoluteString)
        
        return user
    }
    
    // Inicia sesión con correo electrónico y contraseña
    func login(email: String, password: String) async throws -> User {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        
        return User(uid: authDataResult.user.uid, email: authDataResult.user.email ?? "No Email", photoURL: authDataResult.user.photoURL?.absoluteString)
    }
    
    // Inicia sesión con Google
    func loginWithGoogle() async throws -> User {
        let credential = try await googleAuthentication.signInWithGoogle()
        let authDataResutl = try await Auth.auth().signIn(with: credential)
        let autUser = authDataResutl.user
        
        return User(uid: autUser.uid, email: autUser.email ?? "No Email", photoURL: autUser.photoURL?.absoluteString)
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
    
    // Obtiene los proveedores de autenticación del usuario actual
    func currentProvider() -> [LinkedAccounts] {
        guard let currenUser = Auth.auth().currentUser else {
            return []
        }
        
        return currenUser.providerData.compactMap { LinkedAccounts(rawValue: $0.providerID) }
    }
    
}
