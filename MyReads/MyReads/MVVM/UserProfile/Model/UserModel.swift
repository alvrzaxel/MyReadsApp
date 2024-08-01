//
//  User.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 21/7/24.
//

import Foundation

struct UserModel: Decodable  {
    let uid: String
    let displayName: String
    let email: String
    let emailVerified: Bool
    let photoURL: String?
    let providerID: ProviderID
    let creationDate: Date
    var books: [UserBookModel]
    var bookCount: Int { return books.count }
    var readBookCount: Int { return books.filter { $0.bookStatus == .read }.count }
    var wantBookCount: Int { return books.filter { $0.bookStatus == .wantToRead}.count }
    var yearlyReadingGoal: Int
    
    
    init(
        uid: String = "unknown",
        displayName: String? = "No User Name",
        email: String? = "No email",
        emailVerified: Bool = false,
        photoURL: String? = "No Photo URL",
        providerID: String? = "unknown",
        creationDate: Date? = Date(),
        books: [UserBookModel] = [],
        yearlyReadingGoal: Int = 1
    ) {
        self.uid = uid
        self.displayName = displayName ?? "No User Name"
        self.email = email ?? "No email"
        self.emailVerified = emailVerified
        self.photoURL = photoURL ?? "No Photo URL"
        self.providerID = ProviderID(rawValue: providerID ?? "unknown") ?? .unknown
        self.creationDate  = creationDate ?? Date()
        self.books = books
        self.yearlyReadingGoal = yearlyReadingGoal
    }
    
}

// Enum para los posibles valores de providerID
enum ProviderID: String, Decodable {
    case emailAndPassword = "password"
    case google = "google.com"
    case apple = "apple.com"
    case unknown = "unknown"
}

