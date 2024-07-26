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
    let authors: [String]
    let publishedDate: String
    let description: String
    let pagesRead: Int
    let pageCount: Int?
    let categories: [String]
    let averageRating: Double?
    let myRating: Double
    let imageLinks: ImageLinks?
    var bookStatus: BookStatus
    let creationDate: Date
    
    init(
        id: String,
        title: String,
        authors: [String] = ["No Author found"],
        publishedDate: String,
        description: String = "No Description available",
        pagesRead: Int = 0,
        pageCount: Int? = nil,
        categories: [String] = ["No Category"],
        averageRating: Double? = nil,
        myRating: Double = 0.0,
        imageLinks: ImageLinks? = nil,
        bookStatus: BookStatus,
        creationDate: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.authors = authors
        self.publishedDate = publishedDate
        self.description = description
        self.pagesRead = pagesRead
        self.pageCount = pageCount
        self.categories = categories
        self.averageRating = averageRating
        self.myRating = myRating
        self.imageLinks = imageLinks
        self.bookStatus = bookStatus
        self.creationDate = creationDate
    }
}

enum BookStatus: String, Codable {
    case wantToRead = "wantToRead"
    case read = "read"
    case currentlyReading = "currentlyReading"
}
