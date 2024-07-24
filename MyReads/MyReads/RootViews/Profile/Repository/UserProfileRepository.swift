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
    
    // Crea la base de datos del usuario
    func createBDUser(authUser: User) async throws {
        try await userProfileDataSource.createBDUser(authUser: authUser)
    }
    
    // Obtiene los datos del usuario desde la base de datos
    func getBSUser(authUser: User) async throws  -> User? {
        try await userProfileDataSource.getBSUser(userID: authUser.uid)
    }
    
    // Elimina el documento completo del usuario de la base
    func deleteBSUser(authUser: User) async throws {
        try await userProfileDataSource.deleteBDUser(userID: authUser.uid)
    }
    
    // Actualiza un campo específico del usuario en la base de datos
    func updateUserField(authUser: User, field: UserField) async throws {
        try await userProfileDataSource.updateUserField(userID: authUser.uid, field: field)
    }
    
    // Actualiza la lista de libros en la base de datos
    func updateBookList(authUser: User, books: [String], listType: BookListType) async throws {
        try await userProfileDataSource.updateBookList(userID: authUser.uid, books: books, listType: listType)
    }
    
    
}




//    init(datasource: UserProfileDatasource = UserProfileDatasource()) {
//        self.datasource = datasource
//    }
//    
//    func createBDUser(auth: User) async throws {
//        try await datasource.createBDUser(auth: auth)
//    }
//    
//    func getBSUser(userId: String) async throws -> User? {
//        try await datasource.getBSUser(userId: userId)
//    }
//    
//    func updateUser(auth: User) async throws {
//        try await datasource.updateUser(auth: auth)
//    }

