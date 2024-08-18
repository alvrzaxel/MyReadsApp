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
    
    
    // Carga la información del usuario actual
    func loadCurrentUser() {
        Task {
            guard let currentUser = authenticationRepository.getCurrentUser() else { return }
            // Si el usuario está autenticado, actualiza la información del usuario
            self.user = currentUser
            
            // Intenta cargar más detalles desde la base de datos
            await getUserDetails()
        }
    }
    
    
    // Obtiene los datos del usuario desde Firestore y los carga en el usuario
    func getUserDetails() async {
        
        do {
            let userModel = try await userProfileRepository.getUserDocument(user: user)
            self.user = userModel
            await loadProfileImage()
            
        } catch {
            
            do {
                try await userProfileRepository.createUserDocument(user: user)
                let userModel = try await userProfileRepository.getUserDocument(user: user)
                self.user = userModel
                await loadProfileImage()
                
            } catch {
                self.errorMessage = "Failed to load or create user details."
                self.showAlert = true
            }
        }
    }
    
    
    // Actualiza una propiedad del perfil del usuario en la base de datos y actualiza los datos del usuario
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
    
    
    // Carga la imagen del usuariio
    func loadProfileImage() async {
        guard let imageUrlString = user.photoURL else {
            return
        }
        
        let highResolutionUrlString = imageUrlString.replacingOccurrences(of: "s96-c", with: "s256-c")
        
        guard let imageUrl = URL(string: highResolutionUrlString) else {
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: imageUrl)
            if let uiImage = UIImage(data: data) {
                self.profileImage = uiImage
            }
        } catch {
            self.errorMessage = "Failed to download profile image \(error.localizedDescription)"
            self.showAlert = true
            print("Error al descargar la imagen: \(error)")
        }
    }
    
    
    // Actualiza la imagen de perfil
    func updateProfileImage(imageData: Data) async {
        do {
            try await userProfileRepository.uploadProfileImage(user: user, imageData: imageData)
            await loadProfileImage()  // Recargar la imagen para reflejar los cambios
            await getUserDetails()
        } catch {
            self.errorMessage = "Failed to update profile image \(error.localizedDescription)"
            self.showAlert = true
            print("Error al actualizar la imagen de perfil: \(error)")
        }
    }
    
    
    // Añade o actualiza un libro en la lista del usuario y actualiza la base de datos
    func addBook(userBook: UserBookModel, status: BookStatus) {
        Task {
            if let index = self.user.books.firstIndex(where: { $0.id == userBook.id }) {
                self.user.books[index].bookStatus = status
            } else {
                var bookWithStatus = userBook
                bookWithStatus.bookStatus = status
                self.user.books.append(bookWithStatus)
            }
            
            do {
                try await userProfileRepository.updateUserBooks(user: self.user)
            } catch {
                self.errorMessage = "Failed to update user books: \(error.localizedDescription)"
                self.showAlert = true
            }
        }
    }
    
    
    // Elimina un libro de la lista del usuario y actualiza la base de datos
    func removeBook(bookID: String) {
        Task {
            
            guard let index = self.user.books.firstIndex(where: { $0.id == bookID }) else {
                self.errorMessage = "Book not found in user's collection."
                self.showAlert = true
                return
            }
            
            self.user.books.remove(at: index)
            
            do {
                try await userProfileRepository.updateUserBooks(user: self.user)
            } catch {
                self.errorMessage = "Failed to remove book \(error.localizedDescription)"
                self.showAlert = true
            }
        }
    }
    
    
    // Obtiene el estado de un libro específico en la lista del usuario
    func getBookStatus(for googleBook: UserBookModel) -> BookStatus {
        if let book = user.books.first(where: { $0.id == googleBook.id }) {
            return book.bookStatus
        }
        return .unkenow
    }
    
    // Determina si se debe mostrar CurrentlyReadingView
    func shouldShowCurrentlyReadingView() -> Bool {
        return user.books.contains(where: { $0.bookStatus == .currentlyReading })
    }
    
    // Determina si se debe mostrar WantToRead
    func shouldShowWantToRead() -> Bool {
        return user.books.contains(where: { $0.bookStatus == .wantToRead })
    }
    
    // Determina si se debe mostrar Read
    func shouldShowRead() -> Bool {
        return user.books.contains(where: { $0.bookStatus == .read })
    }
    
    // Actualiza el progreso de páginas leidas de un libro
    func updateReadingProgress(for book: UserBookModel, pagesRead: Int) {
        if let index = user.self.books.firstIndex(where: { $0.id == book.id }) {
            user.books[index].pagesRead = pagesRead
            
            Task {
                do {
                    try await userProfileRepository.updateUserBooks(user: self.user)
                } catch {
                    self.errorMessage = "Failed to update Reading progress \(error.localizedDescription)"
                    self.showAlert = true
                }
            }
        }
    }
    
    // Busca libros y actualiza la lista de libros convertidos
    func searchBooks(query: String) async {
        do {
            let userBooks = try await googleApiViewRepository.searchBooks(query: query)
            self.convertedBooks = userBooks
        } catch {
            self.errorMessage = "Error al buscar libros: \(error.localizedDescription)"
            self.showAlert = true
        }
    }
    
    
    // Elimina el perfil del usuario
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
    
    
    // Actualiza la contraseña del usuario
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
    
    
    // Cierra la sesión del usuario
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
