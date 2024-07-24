//
//  User.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 21/7/24.
//

import Foundation

struct User: Decodable  {
    let uid: String
    let email: String?
    let photoURL: String?
    
    // Campos adicionales para Firestore
    var wantToRead: [String] // IDs de los libros que el usuario quiere leer
    var read: [String] // IDs de los libros que el usuario ha leído
    var currentlyReading: [String] // IDs de los libros que el usuario está leyendo actualmente
    
    init(uid: String, email: String?, photoURL: String?, wantToRead: [String] = [], read: [String] = [], currentlyReading: [String] = []) {
        self.uid = uid
        self.email = email
        self.photoURL = photoURL
        self.wantToRead = wantToRead
        self.read = read
        self.currentlyReading = currentlyReading
    }
}


enum LinkedAccounts: String {
    case emailAndPassword = "password"
    case google = "google.com"
    case unknow
}


