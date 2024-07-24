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
    
    private let googleAuthentication = GoogleAuthentication()
    
    
    // Obtenemos el usuario actualmente autenticado
    func getCurrentUser() -> User? {
        guard let user = Auth.auth().currentUser else {
            return nil
        }
        
        return User(uid: user.uid, email: user.email ?? "No Email", photoURL: user.photoURL?.absoluteString)
    }
    
    // Crea un nuevo usuario con correo electronico y contraseña
    func createNewUser(email: String, password: String) async throws -> User {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        
        let user = User(uid: authDataResult.user.uid, email: authDataResult.user.email ?? "No email", photoURL: authDataResult.user.photoURL?.absoluteString)
        
        
        
        return user
    }
    
    
    // Inicia sesión con correo electronico y contraseña
    func login(email: String, password: String) async throws -> User {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        
        return User(uid: authDataResult.user.uid, email: authDataResult.user.email ?? "No Email", photoURL: authDataResult.user.photoURL?.absoluteString)
    }
    
    
    func loginWithGoogle() async throws -> User {
        let credential = try await googleAuthentication.signInWithGoogle()
        let authDataResutl = try await Auth.auth().signIn(with: credential)
        let autUser = authDataResutl.user
        
        return User(uid: autUser.uid, email: autUser.email ?? "No Email", photoURL: autUser.photoURL?.absoluteString)
        
    }
    
    
    func updatePassword(newPassword: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "No current user found"])
        }
        try await user.updatePassword(to: newPassword)
    }
    
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    
    func logout() throws {
        try Auth.auth().signOut()
    }
    
    
    func currentProvider() -> [LinkedAccounts] {
        guard let currenUser = Auth.auth().currentUser else {
            return []
        }
        return currenUser.providerData.compactMap { LinkedAccounts(rawValue: $0.providerID) }
    }
    
}
