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
    
    // Búsqueda genérica de libro
    func fetchBooks(query: String) async throws -> [GoogleBookModel] {
        // Escapamos el query para evistar probelmas con caracteres especiales
        let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)?q=\(escapedQuery)&key=\(Config.googleApiKey)"
        print(urlString)
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let booksResponse = try JSONDecoder().decode(GoogleBooksResponseModel.self, from: data)
        return booksResponse.items
    }
    
    // Búsqueda por categoría
    func fetchBooks(byCategory category: String) async throws -> [GoogleBookModel] {
        let escapedCategory = category.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)?q=subject:\(escapedCategory)&key=\(Config.googleApiKey)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let booksResponse = try JSONDecoder().decode(GoogleBooksResponseModel.self, from: data)
        return booksResponse.items
    }
    
    // Búsqueda por autor
    func fetchBooks(byAuthor author: String) async throws -> [GoogleBookModel] {
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
        return booksResponse.items
    }
    
    
    // Búsqueda por id de libro
    func fetchBook(byId id: String) async throws -> GoogleBookModel? {
        let urlString = "\(baseURL)/\(id)?key=\(Config.googleApiKey)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let bookResponse = try JSONDecoder().decode(GoogleBookModel.self, from: data)
        return bookResponse
    }
    
}
