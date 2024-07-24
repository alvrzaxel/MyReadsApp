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
    private let authenticationRepository: AuthenticationRepository
    private let googleApiViewRepository: GoogleApiRepository
    
    init(
        userProfileRepository: UserProfileRepository = UserProfileRepository(),
        authenticationRepository: AuthenticationRepository = AuthenticationRepository(),
        googleApiViewRepository: GoogleApiRepository = GoogleApiRepository()
    ) {
        self.userProfileRepository = userProfileRepository
        self.authenticationRepository = authenticationRepository
        self.googleApiViewRepository = googleApiViewRepository
        
    }
    
    
    // Carga la información del usuario actual
    func loadCurrentUser() {
        Task {
            guard let currentUser = authenticationRepository.getCurrentUser() else {
                return
            }
            // Si el usuario está autenticado, actualiza la información del usuario
            self.user = currentUser
            
            // Intenta cargar más detalles desde la base de datos
            await getUserDetails()
        }
    }
    
    // Carga detalles adicionales del usuario desde la base de datos
    func getUserDetails() async {
        guard let currentUser = user else {
            print("No user information available")
            return
        }
        do {
            if let userFromBD = try await userProfileRepository.getBSUser(authUser: currentUser) {
                self.user = userFromBD
            } else {
                // Si el usuario no existe en la base de datos, créalo
                try await userProfileRepository.createBDUser(authUser: currentUser)
                let newUserFromBD = try await userProfileRepository.getBSUser(authUser: currentUser)
                self.user = newUserFromBD
                print("Created new user in database.")
            }
        } catch {
            self.errorMessage = error.localizedDescription
            self.showAlert = true
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

