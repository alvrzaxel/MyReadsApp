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
    @Published var user: UserModel?
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    
    @Published var wantToReadBooks: [UserBookModel] = []
    @Published var readBooks: [UserBookModel] = []
    @Published var currentlyReadingBooks: [UserBookModel] = []
    
    @Published var shouldDismiss: Bool = false
    
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
    
    
    /// Carga la información del usuario actual
    func loadCurrentUser() {
        Task {
            guard let currentUser = authenticationRepository.getCurrentUser() else { return }
            // Si el usuario está autenticado, actualiza la información del usuario
            self.user = currentUser
            
            // Intenta cargar más detalles desde la base de datos
            await getUserDetails()
        }
    }
    
    /// Obtiene los datos del usuario desde Firestore y los carga en el usuario
    func getUserDetails() async {
        guard let currentUser = user else { return }
        
        do {
            let userModel = try await userProfileRepository.getUserDocument(user: currentUser)
            self.user = userModel
            categorizeBooks(books: userModel.books)
            
        } catch {
            
            do {
                try await userProfileRepository.createUserDocument(user: currentUser)
                let userModel = try await userProfileRepository.getUserDocument(user: currentUser)
                self.user = userModel
                categorizeBooks(books: userModel.books)
                
            } catch {
                self.errorMessage = "Failed to load or create user details."
                self.showAlert = true
            }
        }
    }
    
    
    /// Actualiza una propiedad del perfil del usuario en la base de datos y actualiza los datos del usuario
    func updateUserProfileProperty(property: UserProfileProperty) {
        Task {
            guard let currentUser = user else { return }
            
            do {
                try await userProfileRepository.updateUserProfileProperty(user: currentUser, property: property)
                await getUserDetails()
            } catch {
                self.errorMessage = "Failed to update profile property"
                self.showAlert = true
            }
        }
    }
    
    
    /// Añade un libro a su base de datos
    func addBook(googleBook: GoogleBookModel, status: BookStatus) {
        Task {
            guard var currentUser = user else { return }
            
            let userBook = convertToUserBookModel(from: googleBook, with: status)
            
            if let index = currentUser.books.firstIndex(where: { $0.id == userBook.id }) {
                currentUser.books[index].bookStatus = status
            } else {
                currentUser.books.append(userBook)
            }
            
            do {
                try await userProfileRepository.updateUserBooks(user: currentUser)
                self.user = currentUser
                
                categorizeBooks(books: currentUser.books)
            } catch {
                self.errorMessage = "Failed to update user books: \(error.localizedDescription)"
                self.showAlert = true
            }
        }
    }
    
    /// Elimina un libro de su base de datos
    func removeBook(bookID: String) {
        Task {
            guard var currentUser = user else {
                self.errorMessage = "User not logged in"
                self.showAlert = true
                return
            }
            
            guard let index = currentUser.books.firstIndex(where: { $0.id == bookID}) else {
                self.errorMessage = "Book not found in user's collection."
                self.showAlert = true
                return
            }
            
            currentUser.books.remove(at: index)
            
            do {
                try await userProfileRepository.updateUserBooks(user: currentUser)
                self.user = currentUser
                
                categorizeBooks(books: currentUser.books)
                
            } catch {
                self.errorMessage = "Failed to remove book \(error.localizedDescription)"
                self.showAlert = true
            }
        }
    }
    
    
    /// Convierte GoogleBookModel a UserBookModel
    private func convertToUserBookModel(from googleBook: GoogleBookModel, with status: BookStatus) -> UserBookModel {
        return UserBookModel(
            id: googleBook.id,
            title: googleBook.volumeInfo.title,
            authors: googleBook.volumeInfo.authors ?? ["No Author found"],
            publishedDate: googleBook.volumeInfo.publishedDate ?? "No Date",
            description: googleBook.volumeInfo.description ?? "No Description available",
            pagesRead: 0,  // Inicialmente 0, puedes ajustar esto según sea necesario
            pageCount: googleBook.volumeInfo.pageCount,
            categories: googleBook.volumeInfo.categories ?? ["No Category"],
            averageRating: googleBook.volumeInfo.averageRating,
            myRating: 0.0,  // Inicialmente 0.0, puedes ajustar esto según sea necesario
            imageLinks: googleBook.volumeInfo.imageLinks,
            bookStatus: status,
            creationDate: Date()
        )
    }
    
    
    /// Categoriza los libros en diferentes listas
    private func categorizeBooks(books: [UserBookModel]) {
        self.wantToReadBooks = books
            .filter { $0.bookStatus == .wantToRead }
            .sorted { $0.creationDate > $1.creationDate }
        
        self.readBooks = books
            .filter { $0.bookStatus == .read }
            .sorted { $0.creationDate > $1.creationDate }
        
        self.currentlyReadingBooks = books
            .filter { $0.bookStatus == .currentlyReading }
            .sorted { $0.creationDate > $1.creationDate }
    }
    
    /// Elimina el perfil del usuario
    func deleteUserProfile() {
        Task {
            guard let currentUser = user else { return }
            
            do {
                try await userProfileRepository.deleteUserDocument(user: currentUser)
                try authenticationRepository.logout()
                self.user = nil
                self.errorMessage = "User profile deleted."
                self.showAlert = true
            } catch {
                self.errorMessage = "Failed to delete profile."
                self.showAlert = true
            }
        }
    }
    
    
    /// Actualiza la contraseña del usuario
    func updatePassword(newPassword: String) {
        Task {
            
            do {
                try await authenticationRepository.updatePassword(newPassword: newPassword)
                self.errorMessage = "Password update"
                self.showAlert = true
                
            } catch {
                self.errorMessage = "Error updating password: \(error.localizedDescription)"
                self.showAlert = true
            }
        }
    }
    
    
    /// Cierra la sesión del usuario
    func signOut() {
        Task {
            do {
                try authenticationRepository.logout()
                self.user = nil
                shouldDismiss = true
            } catch {
                self.errorMessage = "Error sign out: \(error.localizedDescription)"
            }
        }
    }
    
    
    
}

////    // Carga detalles adicionales del usuario desde la base de datos
////    func getUserDetails() async {
////        guard let currentUser = user else {
////            print("No user information available")
////            return
////        }
////        do {
////            if let userFromBD = try await userProfileRepository.getBSUser(authUser: currentUser) {
////                self.user = userFromBD
////            } else {
////                // Si el usuario no existe en la base de datos, créalo
////                try await userProfileRepository.createBDUser(authUser: currentUser)
////                let newUserFromBD = try await userProfileRepository.getBSUser(authUser: currentUser)
////                self.user = newUserFromBD
////                print("Created new user in database.")
////            }
////        } catch {
////            self.errorMessage = error.localizedDescription
////            self.showAlert = true
////        }
////    }
//
//
//    // Añade un libro a una lista específica
//    func addBook(book: GoogleBookModel, to listType: BookListType) {
//        Task {
//            do {
//                guard var currentUser = user else { return }
//                var updateBooks = getBooks(for: listType, from: currentUser)
//                updateBooks.append(book.id)
//
//                try await userProfileRepository.updateBookList(authUser: currentUser, books: updateBooks, listType: listType)
//                updateLocalUserBookList(updateBooks, for: listType, in: &currentUser)
//                self.user = currentUser
//
//            } catch {
//                self.errorMessage = error.localizedDescription
//                self.showAlert = true
//            }
//        }
//    }
//
//    // Elimina un libro de una lista específica
//    func removeBook(book: GoogleBookModel, from listType: BookListType) {
//        Task {
//            do {
//                guard var currentUser = user else { return }
//                var updateBooks = getBooks(for: listType, from: currentUser)
//                updateBooks.removeAll { $0 == book.id }
//
//                try await userProfileRepository.updateBookList(authUser: currentUser, books: updateBooks, listType: listType)
//                updateLocalUserBookList(updateBooks, for: listType, in: &currentUser)
//                self.user = currentUser
//
//            } catch {
//                self.errorMessage = error.localizedDescription
//                self.showAlert = true
//            }
//        }
//    }
//
////    // Obtiene la lista de libros actual para un tipo de lista dado
////    private func getBooks(for listType: BookListType, from user: UserModel) -> [String] {
////        switch listType {
////        case .wantToRead:
////            return user.wantToRead
////        case .read:
////            return user.read
////        case .currentlyReading:
////            return user.currentlyReading
////        }
////    }
//
//    // Actualiza el estado local del usuario con la lista de libros modificada
//    private func updateLocalUserBookList(_ books: [String], for listType: BookListType, in user: inout UserModel) {
//        switch listType {
//        case .wantToRead:
//            user.wantToRead = books
//        case .read:
//            user.read = books
//        case .currentlyReading:
//            user.currentlyReading = books
//        }
//    }
//}

