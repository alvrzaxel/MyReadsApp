//
//  UserProfileRepository.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 23/7/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserProfileRepository {
    
    // Instancia para manejar la base de datos del usuario en Firestore
    private let userProfileDataSource: UserProfileDatasource
    
    // Inicializa el repositorio con una instancia de UserProfileDatasource
    init(userProfileDataSource: UserProfileDatasource = UserProfileDatasource()) {
        self.userProfileDataSource = userProfileDataSource
    }
    
    // Crea un nuevo documento para el usuario en la base de datos
    func createUserDocument(user: UserModel) async throws {
        try await userProfileDataSource.createUserDocument(user: user)
    }
    
    // Obtiene los datos del usuario desde Firestore y los devuelve en un UserModel
    func getUserDocument(user: UserModel) async throws -> UserModel {
        try await userProfileDataSource.getUserDocument(user: user)
    }
    
    // Obtiene los libros del usuario y devuelve una lista de UserBookModel
    func getUserBooks(user: UserModel) async throws -> [UserBookModel] {
        try await userProfileDataSource.getUserBooks(user: user)
    }
    
    // Actualiza una propiedad principal del usuario
    func updateUserProfileProperty(user: UserModel, property: UserProfileProperty) async throws {
        try await userProfileDataSource.updateUserProfileProperty(user: user, property: property)
    }
    
    // Actualiza los libros en el documento del usuario
    func updateUserBooks(user: UserModel) async throws {
        try await userProfileDataSource.updateUserBooks(user: user)
    }
    
    // Elimina el documento del usuario basado en su UID
    func deleteUserDocument(user: UserModel) async throws {
        try await userProfileDataSource.deleteUserDocument(user: user)
    }
}
