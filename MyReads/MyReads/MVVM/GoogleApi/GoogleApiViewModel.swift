//
//  GoogleApiViewModel.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 22/7/24.
//

import Foundation

@MainActor
class GoogleApiViewModel: ObservableObject, Observable {
    @Published var books: [GoogleBookModel] = []
    @Published var selectedBook: GoogleBookModel?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let googleApiRepository: GoogleApiRepository
    
    init(googleApiRepository: GoogleApiRepository = GoogleApiRepository()) {
        self.googleApiRepository = googleApiRepository
    }
    
    // Busca libros usando una consulta generica
    func searchBooks(query: String) async {
        isLoading = true
        Task {
            do {
                let fetchedBooks = try await googleApiRepository.searchBooks(query: query)
                self.books = fetchedBooks
                self.errorMessage = nil
            } catch {
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    // Busca libros por su categoria
    func searchBooks(ByCategory category: String) async {
        isLoading = true
        Task {
            do {
                let fetchedBooks = try await googleApiRepository.searchBooks(byCategory: category)
                self.books = fetchedBooks
                self.errorMessage = nil
            } catch {
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    // Busca libros por su autor
    func searchBooks(byAuthor author: String) async {
        isLoading = true
        Task {
            do {
                let fetchedBooks = try await googleApiRepository.searchBooks(byAuthor: author)
                self.books = fetchedBooks
                self.errorMessage = nil
            } catch {
                self.errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
    
    // busca un libro por su ID
    func getBook(byID id: String) async {
        isLoading = true
        Task {
            do {
                if let book = try await googleApiRepository.getBook(byID: id) {
                    self.selectedBook = book
                    self.errorMessage = nil
                } else {
                    self.errorMessage = "Book not found"
                }
            } catch {
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
    
    
    
    
    
    
    
    
    

//    // Búsqueda genérica
//    func searchBooks(query: String) async {
//        do {
//            let books = try await googleApiRepository.fetchBooks(query: query)
//            self.books = books
//        } catch {
//            self.errorMessage = error.localizedDescription
//        }
//    }
//    
//    // Búsqueda de libro por ID
//    func searchBookId(byId id: String) async {
//        do {
//            let book = try await googleApiRepository.fetchBook(byId: id)
//            self.selectedBook = book
//        } catch {
//            self.errorMessage = error.localizedDescription
//        }
//    }
//    
//    // Búsqueda de libros por categoría
//    func searchBooksCategory(byCategory category: String) async {
//        do {
//            let books = try await googleApiRepository.fetchBooks(byCategory: category)
//            self.books = books
//        } catch {
//            self.errorMessage = error.localizedDescription
//        }
//    }
//    
//    // Obtener libros basados en una lista de IDs
//    func fetchBooksByIds(ids: [String]) async throws -> [Book] {
//        return try await googleApiRepository.fetchBooksByIds(ids: ids)
//    }

