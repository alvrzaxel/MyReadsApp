//
//  LinkedAccounts.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 21/7/24.
//

import Foundation

struct GoogleBooksResponse: Codable {
    let items: [Book]
}

struct Book: Codable, Identifiable {
    let id: String
    let etag: String
    let selfLink: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let publishedDate: String?
    let description: String?
    let pageCount: Int?
    let categories: [String]?
    let averageRating: Double?
    let imageLinks: ImageLinks?
    let language: String?
}

struct ImageLinks: Codable {
    let thumbnail: String?
}
