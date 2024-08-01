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
    @Published var user: UserModel
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    @Published var profileImage: UIImage?
    
    @Published var convertedBooks: [UserBookModel] = []
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
        self.user = UserModel()
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
        
        do {
            let userModel = try await userProfileRepository.getUserDocument(user: user)
            self.user = userModel
            await loadProfileImage()
            categorizeBooks(books: userModel.books)
            
        } catch {
            
            do {
                try await userProfileRepository.createUserDocument(user: user)
                let userModel = try await userProfileRepository.getUserDocument(user: user)
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
            do {
                try await userProfileRepository.updateUserProfileProperty(user: user, property: property)
                await getUserDetails()
            } catch {
                self.errorMessage = "Failed to update profile property"
                self.showAlert = true
            }
        }
    }
    
    
    /// Carga la imagen del usuariio
    func loadProfileImage() async {
        guard let imageUrlString = user.photoURL else {
            return
        }
        print(imageUrlString)
        let highResolutionUrlString = imageUrlString.replacingOccurrences(of: "s96-c", with: "s256-c")
        
        guard let imageUrl = URL(string: highResolutionUrlString) else {
            return
        }
        print(highResolutionUrlString)
        do {
            let (data, _) = try await URLSession.shared.data(from: imageUrl)
            if let uiImage = UIImage(data: data) {
                self.profileImage = uiImage
            }
        } catch {
            print("Error al descargar la imagen: \(error)")
        }
    }
    
    
    /// Añade un libro a su base de datos
    func addBook(userBook: UserBookModel, status: BookStatus) {
        Task {
            var currentUser = user
            
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
            var currentUser = user
            
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
    
    /// Método para comprobar el estado de un libro
    func getBookStatus(for googleBook: UserBookModel) -> BookStatus {
        // Buscar en los libros que el usuario quiere leer
        if let book = wantToReadBooks.first(where: { $0.id == googleBook.id }) {
            return book.bookStatus
        }
        
        // Buscar en los libros que el usuario ha leído
        if let book = readBooks.first(where: { $0.id == googleBook.id }) {
            return book.bookStatus
        }
        
        // Buscar en los libros que el usuario está leyendo actualmente
        if let book = currentlyReadingBooks.first(where: { $0.id == googleBook.id }) {
            return book.bookStatus
        }
        
        // Si el libro no se encuentra, devolver .unkenow
        return .unkenow
    }
    
    /// Método para buscar libros por consulta y actualizar convertedBooks
        func searchBooks(query: String) async {
            do {
                // Llamar al método de búsqueda en GoogleApiViewModel
                let userBooks = try await googleApiViewRepository.searchBooks(query: query)
                // Actualizar convertedBooks con los resultados convertidos
                self.convertedBooks = userBooks
            } catch {
                self.errorMessage = "Error al buscar libros: \(error.localizedDescription)"
                self.showAlert = true
            }
        }
    
    /// Convierte un array de GoogleBookModel a un array de UserBookModel
    func convertBooksArray(from googleBooks: [GoogleBookModel], with status: BookStatus) -> [UserBookModel] {
        return googleBooks.map { googleBook in
            convertToUserBookModel(from: googleBook, with: status)
        }
    }
    
    
    /// Convierte GoogleBookModel a UserBookModel
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
            
            do {
                try await userProfileRepository.deleteUserDocument(user: user)
                try authenticationRepository.logout()
                self.user = UserModel()
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
                self.user = UserModel()
                shouldDismiss = true
            } catch {
                self.errorMessage = "Error sign out: \(error.localizedDescription)"
            }
        }
    }
    
    
    
}
