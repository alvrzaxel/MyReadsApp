//
//  UserBookModel.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 25/7/24.
//

import Foundation

struct UserBookModel: Codable {
    let id: String
    let title: String
    let authors: [String]?
    let publishedDate: String?
    let description: String?
    let pagesRead: Int
    let pageCount: Int?
    let categories: [String]?
    let averageRating: Double?
    let myRating: Double
    let language: String?
    let imageLinks: ImageLinks?
    var bookStatus: BookStatus
    var creationDate: Date = Date()
    

    
}

enum BookStatus: String, Codable {
    case wantToRead = "wantToRead"
    case read = "read"
    case currentlyReading = "currentlyReading"
    case unkenow = "unkenow"
}
