//
//  UserProfileDatasource.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 23/7/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

enum UserProfileProperty {
    case displayName(String)
    case email(String)
    case photoURL(String?)
}

final class UserProfileDatasource {
    
    // Instancia de Firestore
    private let db = Firestore.firestore()
    // Referencia a la coleción de usuarios
    private let usersCollection: String = "UsersDetails"
    
    
    // Crea un nuevo documento para el usuario en la base de datos
    func createUserDocument(user: UserModel) async throws {
        
        // Referencia aL documento del usuario basado en su UID
        let userRef = db.collection(usersCollection).document(user.uid)
        
        // Codifica el array de books a JSON Data
        let booksData = try JSONEncoder().encode(user.books)
        let booksString = String(data: booksData, encoding: .utf8) ?? "[]"
        
        // Prepara los datos del usuario para almacenar
        let userData: [String : Any] = [
            "uid": user.uid,
            "displayName": user.displayName,
            "email": user.email,
            "emailVerified": user.emailVerified,
            "photoURL": user.photoURL ?? "",
            "providerID": user.providerID,
            "creationDate": Timestamp(date: user.creationDate),
            "books": booksString // Codifica el array de libros a JSON
        ]
        
        // Guarda el documento del usuario, si existe, lo sobreescribe
        try await userRef.setData(userData, merge: false)
    }
    
    
    // Obtiene los datos del usuario desde Firestore y los devuelve en un UserModel
    func getUserDocument(user: UserModel) async throws -> UserModel {
        
        // Referencia al documento del usuario
        let userRef = db.collection(usersCollection).document(user.uid)
        
        // Recupera el documento del usuario
        let documentSnapshot = try await userRef.getDocument()
        
        // Verifica si el documento existe
        if !documentSnapshot.exists {
            throw NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "User document does not exist."])
        }
        
        // Decodifica los datos del documento a un diccionario
        guard let data = documentSnapshot.data() else {
            throw NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve user data."])
        }
        
        // Recupera las demás propiedades
        let uid = data["uid"] as? String ?? user.uid
        let displayName = data["displayName"] as? String ?? "No User Name"
        let email = data["email"] as? String ?? "No email"
        let emailVerified = data["emailVerified"] as? Bool ?? false
        let photoURL = data["photoURL"] as? String
        let providerID = data["providerID"] as? String ?? "No Provider"
        let creationDateTimestamp = data["creationDate"] as? Timestamp
        let creationDate = creationDateTimestamp?.dateValue() ?? Date()
        
        let books: [UserBookModel] = try await getUserBooks(user: user)
        
        // Crea y devuelve un UserModel
        let userModel = UserModel(
            uid: uid,
            displayName: displayName,
            email: email,
            emailVerified: emailVerified,
            photoURL: photoURL,
            providerID: providerID,
            creationDate: creationDate,
            books: books
        )
        
        return userModel
    }
    
    
    // Obtiene los libros del usuario y devuelve una lista de UserBookModel
    func getUserBooks(user: UserModel) async throws -> [UserBookModel] {
        let userRef = db.collection(usersCollection).document(user.uid)
        let documentSnapshot = try await userRef.getDocument()
        
        if !documentSnapshot.exists {
            throw NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "User document does not exist."])
        }
        
        guard let data = documentSnapshot.data() else {
            throw NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve user data."])
        }
        
        let booksString = data["books"] as? String ?? "[]"
        let booksData = booksString.data(using: .utf8) ?? Data()
        let books: [UserBookModel] = try JSONDecoder().decode([UserBookModel].self, from: booksData)
        return books
    }
    
    
    // Actualiza una propiedad principal del usuario
    func updateUserProfileProperty(user: UserModel, property: UserProfileProperty) async throws {
        let userRef = db.collection(usersCollection).document(user.uid)
        
        var dataToUpdate: [String : Any] = [:]
        
        switch property {
        case .displayName(let newDisplayName):
            dataToUpdate["displayName"] = newDisplayName
        case .email(let newEmail):
            dataToUpdate["email"] = newEmail
        case .photoURL(let newPhotoURl):
            dataToUpdate["photoURL"] = newPhotoURl
        }
        
        try await userRef.updateData(dataToUpdate)
    }
    
    
    // Actualiza los libros en el documento del usuario
    func updateUserBooks(user: UserModel) async throws {
        let userRef = db.collection(usersCollection).document(user.uid)
        
        // Codifica la lista actualizada de libros a JSON
        let booksData = try JSONEncoder().encode(user.books)
        let booksString = String(data: booksData, encoding: .utf8) ?? "[]"
        
        // Actualiza el documento del usuario con la nueva lista de libros
        try await userRef.updateData(["books": booksString])
    }
    
    
    // Elimina el documento del usuario basado en su UID
    func deleteUserDocument(user: UserModel) async throws {
        try await db.collection(usersCollection).document(user.uid).delete()
    }
    
}
