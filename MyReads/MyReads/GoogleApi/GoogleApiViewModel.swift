//
//  GoogleApiViewModel.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 22/7/24.
//

import Foundation

@MainActor
class GoogleApiViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var selectedBook: Book?
    @Published var errorMessage: String?
    
    private let googleApiRepository: GoogleApiRepository
    
    init(googleApiRepository: GoogleApiRepository = GoogleApiRepository()) {
        self.googleApiRepository = googleApiRepository
    }
    
    // Búsqueda genérica
    func searchBooks(query: String) async {
        do {
            let books = try await googleApiRepository.fetchBooks(query: query)
            self.books = books
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    // Búsqueda de libro por ID
    func searchBookId(byId id: String) async {
        do {
            let book = try await googleApiRepository.fetchBook(byId: id)
            self.selectedBook = book
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    // Búsqueda de libros por categoría
    func searchBooksCategory(byCategory category: String) async {
        do {
            let books = try await googleApiRepository.fetchBooks(byCategory: category)
            self.books = books
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    // Obtener libros basados en una lista de IDs
    func fetchBooksByIds(ids: [String]) async throws -> [Book] {
        return try await googleApiRepository.fetchBooksByIds(ids: ids)
    }
}
