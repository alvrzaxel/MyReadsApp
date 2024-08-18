//
//  GoogleAuthentication.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 20/7/24.
//


import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

// Maneja errores específicos de Google Sign-In
enum GoogleSignInError: Error {
    case missingClientID
    case noRootViewController
    case missingIDToken
}

// Gestiona la autenticación con Google
final class GoogleAuthentication {
    
    // Inicia sesión con Google de manera asíncrona
    @MainActor
    func signInWithGoogle() async throws -> AuthCredential {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw GoogleSignInError.missingClientID
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            throw GoogleSignInError.noRootViewController
        }
        
        let userAuth = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        let user = userAuth.user
        guard let idToken = user.idToken else {
            throw GoogleSignInError.missingIDToken
        }
        
        let accessToken = user.accessToken
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
        
        return credential
    }
}
