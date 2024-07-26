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
    let providerID: String
    let creationDate: Date
    var books: [UserBookModel]
    var bookCount: Int { return books.count }
    var readBookCount: Int { return books.filter { $0.bookStatus == .read }.count }
    
    
    init(
        uid: String,
        displayName: String? = "No User Name",
        email: String? = "No email",
        emailVerified: Bool = false,
        photoURL: String? = "No Photo URL",
        providerID: String? = "No Provider",
        creationDate: Date? = Date(),
        books: [UserBookModel] = []
    ) {
        self.uid = uid
        self.displayName = displayName ?? "No User Name"
        self.email = email ?? "No email"
        self.emailVerified = emailVerified
        self.photoURL = photoURL ?? "No Photo URL"
        self.providerID = providerID ?? "No Provider"
        self.creationDate  = creationDate ?? Date()
        self.books = books
    }
    
}


enum LinkedAccounts: String {
    case emailAndPassword = "password"
    case google = "google.com"
    case unknow
}


