//
//  GoogleApiRepository.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 22/7/24.
//

import Foundation

class GoogleApiRepository {
    private let googleApiDatasoruce: GoogleApiDatasoruce
    
    init(googleApiData: GoogleApiDatasoruce = GoogleApiDatasoruce()) {
        self.googleApiDatasoruce = googleApiData
    }
    
    // Busca libros usando una consulta genérica
    func searchBooks(query: String) async throws -> [Book] {
        return try await googleApiDatasoruce.fetchBooks(query: query)
    }
    
    // Busca libros por su cateogria
    func searchBooks(byCategory category: String) async throws -> [Book] {
        return try await googleApiDatasoruce.fetchBooks(byCategory: category)
    }
    
    // Busca libros por su autor
    func searchBooks(byAuthor author: String) async throws -> [Book] {
        try await googleApiDatasoruce.fetchBooks(byAuthor: author)
    }
    
    // Busca un libro por su ID
    func getBook(byID id: String) async throws -> Book? {
        try await googleApiDatasoruce.fetchBook(byId: id)
    }
}

