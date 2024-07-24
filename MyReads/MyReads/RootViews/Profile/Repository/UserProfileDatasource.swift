//
//  UserProfileDatasource.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 23/7/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

enum UserField {
    case email(String)
    case photoURL(String)
    case wantToRead([String])
    case read([String])
    case currentlyReading([String])
}

enum BookListType: String {
    case wantToRead = "want_to_read"
    case read = "read"
    case currentlyReading = "currently_reading"
}

final class UserProfileDatasource {
    
    // Crea la base de datos del usuario
    func createBDUser(authUser: User) async throws {
        let userData: [String: Any] = [
            "user_id": authUser.uid,
            "date_created": Timestamp(),
            "email": authUser.email ?? "",
            "photo_url": authUser.photoURL ?? "",
            "want_to_read": authUser.wantToRead,
            "read": authUser.read,
            "currently_reading": authUser.currentlyReading
        ]
        
        // Guarda los datos del usuario en la colección "users" en Firestore
        try await Firestore.firestore().collection("users").document(authUser.uid).setData(userData, merge: false)
    }
    
    // Obtiene los datos de la base de datos del usuario
    func getBSUser(userID: String) async throws -> User? {
        let doc = try await Firestore.firestore().collection("users").document(userID).getDocument()
        guard let data = doc.data() else { return nil }
        return User(
            uid: data["user_id"] as? String ?? "",
            email: data["email"] as? String,
            photoURL: data["photo_url"] as? String,
            wantToRead: data["want_to_read"] as? [String] ?? [],
            read: data["read"] as? [String] ?? [],
            currentlyReading: data["currently_reading"] as? [String] ?? []
        )
    }
    
    // Elimina el documento de la base de datos del usuario
    func deleteBDUser(userID: String) async throws {
        try await Firestore.firestore().collection("users").document(userID).delete()
    }

    
    // Actualiza el campo específico del usuario
    func updateUserField(userID: String, field: UserField) async throws {
        var dataToUpdate: [String : Any] = [:]
        
        switch field {
        case .email(let email):
            dataToUpdate["email"] = email
            
        case .photoURL(let photoURL):
            dataToUpdate["photo_url"] = photoURL
            
        case .wantToRead(let wantToRead):
            dataToUpdate["want_to_read"] = wantToRead
            
        case .read(let read):
            dataToUpdate["read"] = read
            
        case .currentlyReading(let currentlyReading):
            dataToUpdate["currently_reading"] = currentlyReading
        }
        
        if !dataToUpdate.isEmpty {
            try await Firestore.firestore().collection("users").document(userID).setData(dataToUpdate, merge: true)
        }
    }
    
    // Actualiza la lista de libros de la base de datos para una lista específica
    func updateBookList(userID: String, books: [String], listType: BookListType) async throws {
        let userDocument = Firestore.firestore().collection("users").document(userID)
        
        try await userDocument.setData([
            listType.rawValue: books
        ], merge: false)
    }
    
//    func updateUser(auth: User) async throws {
//        var updatedFields: [String: Any] = [:]
//        
//        if let email = auth.email {
//            updatedFields["email"] = email
//        }
//        if let photoURL = auth.photoURL {
//            updatedFields["photo_url"] = photoURL
//        }
//        updatedFields["want_to_read"] = auth.wantToRead
//        updatedFields["read"] = auth.read
//        updatedFields["currently_reading"] = auth.currentlyReading
//        
//        if !updatedFields.isEmpty {
//            try await Firestore.firestore().collection("users").document(auth.uid).setData(updatedFields, merge: true)
//        }
//    }
    
    
    
    
    
    
    
}
