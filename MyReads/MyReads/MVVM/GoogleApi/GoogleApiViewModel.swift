//
//  GoogleApiViewModel.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 22/7/24.
//

import Foundation

@MainActor
class GoogleApiViewModel: ObservableObject, Observable {
    @Published var booksResultSearch: [UserBookModel]? = nil
    @Published var selectedBook: UserBookModel?
    @Published var booksByCategory: [UserBookModel] = []
    
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let googleApiRepository: GoogleApiRepository
    
    init(googleApiRepository: GoogleApiRepository = GoogleApiRepository()) {
        self.googleApiRepository = googleApiRepository
        //        Task {
        //            await self.loadBooksForCategory(category: "Fiction")
        //        }
    }
    
    /// Busca libros usando una consulta genérica y almacena en booksResultSearch
    func searchBooks(query: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Llama al repositorio y actualiza booksResultSearch
            let fetchedBooks = try await googleApiRepository.searchBooks(query: query)
            self.booksResultSearch = fetchedBooks
        } catch {
            self.errorMessage = error.localizedDescription
            self.booksResultSearch = nil
        }
    }
    
    /// Busca libros por su categoría  y almacena en booksByCategory
    func searchBooks(byCategory category: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Llama al repositorio y actualiza booksByCategory
            let fetchedBooks = try await googleApiRepository.searchBooks(byCategory: category)
            self.booksByCategory = fetchedBooks
        } catch {
            self.errorMessage = error.localizedDescription
            self.booksByCategory = []
        }
    }
    
    /// Busca libros por su autor y almacena en booksResultSearch
    func searchBooks(byAuthor author: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Llama al repositorio y actualiza booksResultSearch
            let fetchedBooks = try await googleApiRepository.searchBooks(byAuthor: author)
            self.booksResultSearch = fetchedBooks
        } catch {
            self.errorMessage = error.localizedDescription
            self.booksResultSearch = nil
        }
    }
    
    /// Busca un libro por su ID y almacena en selectedBook
    func getBook(byID id: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            if let book = try await googleApiRepository.getBook(byID: id) {
                self.selectedBook = book
            } else {
                self.errorMessage = "Book not found"
                self.selectedBook = nil
            }
        } catch {
            self.errorMessage = error.localizedDescription
            self.selectedBook = nil
        }
    }
    
    /// Busca libros por su categoría y actualiza booksByCategory
    func loadBooksForCategory(category: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // Llama al repositorio y actualiza booksByCategory
            let fetchedBooks = try await googleApiRepository.searchBooks(byCategory: category)
            self.booksByCategory = fetchedBooks
        } catch {
            self.errorMessage = error.localizedDescription
            self.booksByCategory = []
        }
    }
    
    
}
