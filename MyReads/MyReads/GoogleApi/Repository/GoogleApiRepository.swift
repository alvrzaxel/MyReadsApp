//
//  GoogleApiRepository.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 22/7/24.
//

import Foundation

class GoogleApiRepository {
    private let googleApiData: GoogleApiData
    
    init(googleApiData: GoogleApiData = GoogleApiData()) {
        self.googleApiData = googleApiData
    }
    
    // Método para obtener libros basados en la consulta de búsqueda
    func fetchBooks(query: String) async throws -> [Book] {
        return try await googleApiData.fetchBooks(query: query)
    }
    
    // Método para obtener un libro por ID
    func fetchBook(byId id: String) async throws -> Book? {
        return try await googleApiData.fetchBook(byId: id)
    }
    
    // Método para obtener libros por categoría
    func fetchBooks(byCategory category: String) async throws -> [Book] {
        return try await googleApiData.fetchBooks(byCategory: category)
    }
    
    // Método para obtener libros por múltiples IDs
    func fetchBooksByIds(ids: [String]) async throws -> [Book] {
        return try await googleApiData.fetchBooksByIds(ids: ids)
    }
}

