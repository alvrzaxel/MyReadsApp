//
//  LinkedAccounts.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 21/7/24.
//

import Foundation

struct GoogleBooksResponseModel: Codable {
    let items: [GoogleBookModel]
}

struct GoogleBookModel: Codable, Identifiable {
    let id: String
    let volumeInfo: VolumeInfo
    let saleInfo: SaleInfo
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let publishedDate: String?
    let description: String?
    let industryIdentifiers: [IndustryIdentifiers]?
    let pageCount: Int?
    let categories: [String]?
    let averageRating: Double?
    let imageLinks: ImageLinks?
    let language: String?
}

struct IndustryIdentifiers: Codable {
    let type: String
    let identifier: String
}

struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
}

struct SaleInfo: Codable {
    let isEbook: Bool
}
