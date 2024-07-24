//
//  UserProfileViewModel.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 23/7/24.
//

import SwiftUI
import FirebaseAuth

@MainActor
final class UserProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    @Published var wantToReadBooks: [Book] = []
    @Published var readBooks: [Book] = []
    @Published var currentlyReadingBooks: [Book] = []
    
    private let userProfileRepository: UserProfileRepository
    
    private let googleApiViewRepository: GoogleApiRepository
    
    init(
        userProfileRepository: UserProfileRepository = UserProfileRepository(),
        googleApiViewRepository: GoogleApiRepository = GoogleApiRepository()
    ) {
        self.userProfileRepository = userProfileRepository
        self.googleApiViewRepository = googleApiViewRepository
    }
    
    // Carga el usuario y actualiza la vista
    func getCurrentUser() async {
        Task {
            do {
                guard let currentUser = user else { return }
                
                // Si el usuario tiene documento en la base de datos, lo volcamos en user
                if let userFromBD = try await userProfileRepository.getBSUser(authUser: currentUser) {
                    self.user = userFromBD
                } else {
                    
                    // Si el usuario no tiene documento, le creamos la base de datos y lo volcamos en user
                    try await userProfileRepository.createBDUser(authUser: currentUser)
                    let newUserFromBD = try await userProfileRepository.getBSUser(authUser: currentUser)
                    self.user = newUserFromBD
                }
                
            } catch {
                self.errorMessage = error.localizedDescription
                self.showAlert = true
            }
        }
    }
    
    // Añade un libro a una lista específica
    func addBook(book: Book, to listType: BookListType) {
        Task {
            do {
                guard var currentUser = user else { return }
                var updateBooks = getBooks(for: listType, from: currentUser)
                updateBooks.append(book.id)
                
                try await userProfileRepository.updateBookList(authUser: currentUser, books: updateBooks, listType: listType)
                updateLocalUserBookList(updateBooks, for: listType, in: &currentUser)
                self.user = currentUser
                
            } catch {
                self.errorMessage = error.localizedDescription
                self.showAlert = true
            }
        }
    }
    
    // Elimina un libro de una lista específica
    func removeBook(book: Book, from listType: BookListType) {
        Task {
            do {
                guard var currentUser = user else { return }
                var updateBooks = getBooks(for: listType, from: currentUser)
                updateBooks.removeAll { $0 == book.id }
                
                try await userProfileRepository.updateBookList(authUser: currentUser, books: updateBooks, listType: listType)
                updateLocalUserBookList(updateBooks, for: listType, in: &currentUser)
                self.user = currentUser
                
            } catch {
                self.errorMessage = error.localizedDescription
                self.showAlert = true
            }
        }
    }
    
    // Obtiene la lista de libros actual para un tipo de lista dado
    private func getBooks(for listType: BookListType, from user: User) -> [String] {
        switch listType {
        case .wantToRead:
            return user.wantToRead
        case .read:
            return user.read
        case .currentlyReading:
            return user.currentlyReading
        }
    }
    
    // Actualiza el estado local del usuario con la lista de libros modificada
    private func updateLocalUserBookList(_ books: [String], for listType: BookListType, in user: inout User) {
        switch listType {
        case .wantToRead:
            user.wantToRead = books
        case .read:
            user.read = books
        case .currentlyReading:
            user.currentlyReading = books
        }
    }
}
