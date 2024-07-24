//
//  AuthenticationRepository.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 20/7/24.
//

import Foundation
import UIKit

final class AuthenticationRepository {
    private let authenticationFirebaseDatasource: AuthenticationFirebaseDatasource
    
    init(authenticationFirebaseDatasource: AuthenticationFirebaseDatasource = AuthenticationFirebaseDatasource()) {
        self.authenticationFirebaseDatasource = authenticationFirebaseDatasource
    }
    
    func getCurrentUser() -> User? {
        authenticationFirebaseDatasource.getCurrentUser()
    }
    
    func createNewUser(email: String, password: String) async throws -> User {
        try await authenticationFirebaseDatasource.createNewUser(email: email, password: password)
    }
    
    
    func login(email: String, password: String) async throws -> User {
        try await authenticationFirebaseDatasource.login(email: email, password: password)
    }
    
    func loginWithGoogle() async throws -> User {
        return try await authenticationFirebaseDatasource.loginWithGoogle()
    }
    
    //    func loginWithGoogle(presentingViewController: UIViewController) async throws -> User {
    //        try await authenticationFirebaseDatasource.loginWithGoogle(presentingViewController: presentingViewController)
    //    }
    
    
    func updatePassword(newPassword: String) async throws {
        try await authenticationFirebaseDatasource.updatePassword(newPassword: newPassword)
    }
    
    
    func resetPassword(email: String) async throws {
        try await authenticationFirebaseDatasource.resetPassword(email: email)
    }
    
    
    func logout() throws {
        try authenticationFirebaseDatasource.logout()
    }
    
    func getCurrentProvider() -> [LinkedAccounts] {
        authenticationFirebaseDatasource.currentProvider()
    }
}
