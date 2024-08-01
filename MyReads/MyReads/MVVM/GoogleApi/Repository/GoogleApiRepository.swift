//
//  GoogleApiRepository.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 22/7/24.
//

import Foundation

class GoogleApiRepository {
    private let googleApiDatasource: GoogleApiDatasoruce
    
    init(googleApiDatasource: GoogleApiDatasoruce = GoogleApiDatasoruce()) {
        self.googleApiDatasource = googleApiDatasource
    }
    
    /// Busca libros usando una consulta genérica
    func searchBooks(query: String) async throws -> [UserBookModel] {
        let googleBooks = try await googleApiDatasource.fetchBooks(query: query)
        return googleBooks
    }
    
    /// Busca libros por su categoría
    func searchBooks(byCategory category: String) async throws -> [UserBookModel] {
        let googleBooks = try await googleApiDatasource.fetchBooks(byCategory: category)
        return googleBooks
    }
    
    /// Busca libros por su autor
    func searchBooks(byAuthor author: String) async throws -> [UserBookModel] {
        let googleBooks = try await googleApiDatasource.fetchBooks(byAuthor: author)
        return googleBooks
    }
    
    /// Busca un libro por su ID
    func getBook(byID id: String) async throws -> UserBookModel? {
        let googleBook = try await googleApiDatasource.fetchBook(byId: id)
        return googleBook
    }
}

