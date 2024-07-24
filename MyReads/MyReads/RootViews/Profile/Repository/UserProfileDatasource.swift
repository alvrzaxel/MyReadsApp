//
//  UserProfileDatasource.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 23/7/24.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserProfileDatasource {
    
    func createBDUser(auth: User) async throws {
        let userData: [String: Any] = [
            "user_id": auth.uid,
            "date_created": Timestamp(),
            "email": auth.email ?? "",
            "photo_url": auth.photoURL ?? "",
            "want_to_read": auth.wantToRead,
            "read": auth.read,
            "currently_reading": auth.currentlyReading
        ]
        
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
    }
    
    func updateUser(auth: User) async throws {
        var updatedFields: [String: Any] = [:]
        
        if let email = auth.email {
            updatedFields["email"] = email
        }
        if let photoURL = auth.photoURL {
            updatedFields["photo_url"] = photoURL
        }
        updatedFields["want_to_read"] = auth.wantToRead
        updatedFields["read"] = auth.read
        updatedFields["currently_reading"] = auth.currentlyReading
        
        if !updatedFields.isEmpty {
            try await Firestore.firestore().collection("users").document(auth.uid).setData(updatedFields, merge: true)
        }
    }
    
    func getBSUser(userId: String) async throws -> User? {
        let doc = try await Firestore.firestore().collection("users").document(userId).getDocument()
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
}
