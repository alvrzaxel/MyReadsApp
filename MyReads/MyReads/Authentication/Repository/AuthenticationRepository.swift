//
//  AuthenticationRepository.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 20/7/24.
//

import Foundation
import UIKit

final class AuthenticationRepository {
    
    // Instancia para manejar la autenticación con Firebase
    private let authenticationFirebaseDatasource: AuthenticationFirebaseDatasource
    
    // Inicializador que permite inyectar una instantia AuthenticationFirebaseDatasource
    init(authenticationFirebaseDatasource: AuthenticationFirebaseDatasource = AuthenticationFirebaseDatasource()) {
        self.authenticationFirebaseDatasource = authenticationFirebaseDatasource
    }
    
    // Obtiene el usuario actualmente autenticado
    func getCurrentUser() -> User? {
        authenticationFirebaseDatasource.getCurrentUser()
    }
    
    // Crea un nuevo usuario con correo electronico y contraseña
    func createNewUser(email: String, password: String) async throws -> User {
        try await authenticationFirebaseDatasource.createNewUser(email: email, password: password)
    }
    
    // Inicia sesion con correo electronico y contrasena
    func login(email: String, password: String) async throws -> User {
        try await authenticationFirebaseDatasource.login(email: email, password: password)
    }
    
    // Inicia sesion con Google
    func loginWithGoogle() async throws -> User {
        return try await authenticationFirebaseDatasource.loginWithGoogle()
    }
    
    // Actualiza la contraseña del usuario actual
    func updatePassword(newPassword: String) async throws {
        try await authenticationFirebaseDatasource.updatePassword(newPassword: newPassword)
    }
    
    // Envia un correo electronico para restablecer la contraseña
    func resetPassword(email: String) async throws {
        try await authenticationFirebaseDatasource.resetPassword(email: email)
    }
    
    // Cierra la sesion del usuario actualmente autenticado
    func logout() throws {
        try authenticationFirebaseDatasource.logout()
    }
    
    // Elimina la cuenta del usuario actualmente autenticado
    func deleteAcount() async throws {
        try await authenticationFirebaseDatasource.deleteAccount()
    }
    
    // Obtiene los proveedores de autenticacion del usuario actualmente autenticado
    func getCurrentProvider() -> [LinkedAccounts] {
        authenticationFirebaseDatasource.currentProvider()
    }
}
