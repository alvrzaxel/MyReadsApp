//
//  GoogleApiData.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 22/7/24.
// https://www.googleapis.com/books/v1/volumes?q=flowers+inauthor:keyes&key=AIzaSyD_7weyDggQNRoWowmf27OsLmpjwuq4smc

// https://www.googleapis.com/books/v1/volumes/6P_jN6zUuMcC?key=AIzaSyD_7weyDggQNRoWowmf27OsLmpjwuq4smc

import Foundation

class GoogleApiDatasoruce {
    
    private let baseURL = "https://www.googleapis.com/books/v1/volumes"
    
    // Búsqueda genérica de libros
    func fetchBooks(query: String) async throws -> [UserBookModel] {
        let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)?q=\(escapedQuery)&key=\(Config.googleApiKey)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let booksResponse = try JSONDecoder().decode(GoogleBooksResponseModel.self, from: data)
        let googleBooks = booksResponse.items
        
        return convertBooksArray(from: googleBooks, with: .unkenow)
    }
    
    // Búsqueda por categoría
    func fetchBooks(byCategory category: String) async throws -> [UserBookModel] {
        let escapedCategory = category.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)?q=subject:\(escapedCategory)&orderBy=newest&key=\(Config.googleApiKey)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let booksResponse = try JSONDecoder().decode(GoogleBooksResponseModel.self, from: data)
        let googleBooks = booksResponse.items
        
        return convertBooksArray(from: googleBooks, with: .unkenow)
    }
    
    // Búsqueda por autor
    func fetchBooks(byAuthor author: String) async throws -> [UserBookModel] {
        let escapedAuthor = author.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)?q=inauthor:\(escapedAuthor)&key=\(Config.googleApiKey)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let booksResponse = try JSONDecoder().decode(GoogleBooksResponseModel.self, from: data)
        let googleBooks = booksResponse.items
        
        return convertBooksArray(from: googleBooks, with: .unkenow)
    }
    
    
    // Búsqueda por ID
    func fetchBook(byId id: String) async throws -> UserBookModel? {
        let urlString = "\(baseURL)/\(id)?key=\(Config.googleApiKey)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let bookResponse = try JSONDecoder().decode(GoogleBookModel.self, from: data)
        
        return convertToUserBookModel(from: bookResponse, with: .unkenow)
    }
    
    
    // Convierte un array de GoogleBookModel a un array de UserBookModel
    private func convertBooksArray(from googleBooks: [GoogleBookModel], with status: BookStatus) -> [UserBookModel] {
        return googleBooks.map { googleBook in
            convertToUserBookModel(from: googleBook, with: status)
        }
    }
    
    // Convierte GoogleBookModel a UserBookModel
    private func convertToUserBookModel(from googleBook: GoogleBookModel, with status: BookStatus) -> UserBookModel {
        return UserBookModel(
            id: googleBook.id,
            title: googleBook.volumeInfo.title,
            authors: googleBook.volumeInfo.authors,
            publishedDate: googleBook.volumeInfo.publishedDate,
            description: googleBook.volumeInfo.description,
            pagesRead: 0,
            pageCount: googleBook.volumeInfo.pageCount,
            categories: googleBook.volumeInfo.categories,
            averageRating: googleBook.volumeInfo.averageRating,
            myRating: 0.0,
            language: googleBook.volumeInfo.language,
            imageLinks: googleBook.volumeInfo.imageLinks,
            bookStatus: status,
            creationDate: Date()
        )
    }
    
    
}
