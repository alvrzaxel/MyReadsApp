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
    @Published var user: User? {
        didSet {
            // Cargar datos cuando se establece el usuario
            Task {
                await loadCurrentUser()
            }
        }
    }
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    @Published var wantToReadBooks: [Book] = []
    @Published var readBooks: [Book] = []
    @Published var currentlyReadingBooks: [Book] = []
    
    private let userProfileRepository: UserProfileRepository
    private let googleApiViewModel = GoogleApiViewModel()
    
    // Nuevo inicializador que recibe un usuario opcional
    init(repository: UserProfileRepository = UserProfileRepository()) {
        self.userProfileRepository = repository
    }
    
    func initialize() async {
        await loadCurrentUser()
    }
    
    func loadCurrentUser() async {
        guard let currentUser = user else {
            errorMessage = "No user is logged in"
            return
        }
        
        do {
            if let fetchedUser = try await userProfileRepository.getBSUser(userId: currentUser.uid) {
                self.user = fetchedUser
                await fetchBooks()
            } else {
                await createBDUser(auth: User(uid: currentUser.uid, email: currentUser.email, photoURL: currentUser.photoURL))
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func createBDUser(auth: User) async {
        do {
            try await userProfileRepository.createBDUser(auth: auth)
            self.user = auth
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func updateUser(auth: User) async {
        do {
            try await userProfileRepository.updateUser(auth: auth)
            self.user = auth
            await fetchBooks()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func refreshUserData() async {
        guard let currentUser = user else {
            errorMessage = "No user is logged in"
            return
        }
        
        do {
            if let updatedUser = try await userProfileRepository.getBSUser(userId: currentUser.uid) {
                self.user = updatedUser
                await fetchBooks()
            } else {
                errorMessage = "Failed to fetch user data"
                showAlert = true
            }
        } catch {
            errorMessage = error.localizedDescription
            showAlert = true
        }
    }
    
    // Métodos para añadir y remover libros
    func addBookToWantToRead(bookId: String) async {
        guard var user = user else { return }
        user.wantToRead.append(bookId)
        await updateUser(auth: user)
        await fetchWantToReadBooks()
    }
    
    func removeBookFromWantToRead(bookId: String) async {
        guard var user = user else { return }
        user.wantToRead.removeAll { $0 == bookId }
        await updateUser(auth: user)
        await fetchWantToReadBooks()
    }
    
    func addBookToRead(bookId: String) async {
        guard var user = user else { return }
        user.read.append(bookId)
        await updateUser(auth: user)
        await fetchReadBooks()
    }
    
    func removeBookFromRead(bookId: String) async {
        guard var user = user else { return }
        user.read.removeAll { $0 == bookId }
        await updateUser(auth: user)
        await fetchReadBooks()
    }
    
    func addBookToCurrentlyReading(bookId: String) async {
        guard var user = user else { return }
        user.currentlyReading.append(bookId)
        await updateUser(auth: user)
        await fetchCurrentlyReadingBooks()
    }
    
    func removeBookFromCurrentlyReading(bookId: String) async {
        guard var user = user else { return }
        user.currentlyReading.removeAll { $0 == bookId }
        await updateUser(auth: user)
        await fetchCurrentlyReadingBooks()
    }
    
    // Métodos para obtener listas de libros
    func getWantToReadBooks() async -> [Book] {
        await fetchWantToReadBooks()
        return wantToReadBooks
    }
    
    func getReadBooks() async -> [Book] {
        await fetchReadBooks()
        return readBooks
    }
    
    func getCurrentlyReadingBooks() async -> [Book] {
        await fetchCurrentlyReadingBooks()
        return currentlyReadingBooks
    }
    
    // Métodos para buscar libros por sus IDs
    func fetchWantToReadBooks() async {
        guard let user = user else { return }
        do {
            let books = try await googleApiViewModel.fetchBooksByIds(ids: user.wantToRead)
            self.wantToReadBooks = books
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func fetchReadBooks() async {
        guard let user = user else { return }
        do {
            let books = try await googleApiViewModel.fetchBooksByIds(ids: user.read)
            self.readBooks = books
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func fetchCurrentlyReadingBooks() async {
        guard let user = user else { return }
        do {
            let books = try await googleApiViewModel.fetchBooksByIds(ids: user.currentlyReading)
            self.currentlyReadingBooks = books
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func fetchBooks() async {
        await fetchWantToReadBooks()
        await fetchReadBooks()
        await fetchCurrentlyReadingBooks()
    }
}
