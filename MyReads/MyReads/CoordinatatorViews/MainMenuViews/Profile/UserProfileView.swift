//
//  UserProfile.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 21/7/24.
//

import SwiftUI

struct UserProfileView: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @State var showSettings: Bool = false
    @Binding  var showChangeTheme: Bool
    
    var body: some View {
        ZStack() {
            Color.colorbackground1.ignoresSafeArea()
            
            VStack(spacing: 20) {
                UserDetailsView(userProfileViewModel: userProfileViewModel)
                
                VStack(spacing: 30) {
                    UserCurrentlyView(userProfileViewModel: userProfileViewModel)
                    UserBooksView(userProfileViewModel: userProfileViewModel, bookStatusFilter: .wantToRead)
                    
                    UserBooksView(userProfileViewModel: userProfileViewModel, bookStatusFilter: .read)
                }
               
                Spacer()
            }
        }
        .safeAreaInset(edge: .top) {
            CustomNavBarUserProfile(showSettings: $showSettings, showChangeTheme: $showChangeTheme)
        }
        .fullScreenCover(isPresented: $showSettings, onDismiss: { showSettings = false }, content: {
            UserProfileSettingsView3(userProfileViewModel: userProfileViewModel)
        })
        
    }
}



#Preview {
    // Creando un ejemplo de usuario con libros en diferentes estados
    let exampleUser = UserModel(
        uid: "1234",
        displayName: "Axel Alvarez",
        email: "axel@gmail.com",
        emailVerified: true,
        photoURL: "https://lh3.googleusercontent.com/a/ACg8ocIU-w-m16GR3-CJRDSi9sh3OY01pzc9Ixoi5rUu18gWEwhhN-4F=s256-c",
        providerID: .google,
        creationDate: Date(),
        books: [
            // Libro 1: Currently Reading
            UserBookModel(
                id: "234343",
                title: "Un lugar para Mungo",
                authors: ["Douglas Stuart"],
                publishedDate: "2021",
                description: "A description of the book.",
                pagesRead: 10,
                pageCount: 300,
                categories: ["Fiction"],
                averageRating: 4.5,
                myRating: 4.5,
                language: "es",
                imageLinks: ImageLinks(
                    smallThumbnail: "https://m.media-amazon.com/images/I/71TQ+LBCU4L._AC_UF894,1000_QL80_.jpg",
                    thumbnail: "https://m.media-amazon.com/images/I/71TQ+LBCU4L._AC_UF894,1000_QL80_.jpg"
                ),
                bookStatus: .currentlyReading
            ),
            // Libro 2: Want to Read
            UserBookModel(
                id: "234344",
                title: "The Catcher in the Rye",
                authors: ["J.D. Salinger"],
                publishedDate: "1951",
                description: "A story about the experiences of a young man in New York.",
                pagesRead: 0,
                pageCount: 214,
                categories: ["Fiction"],
                averageRating: 4.0,
                myRating: 0.0,
                language: "en",
                imageLinks: ImageLinks(
                    smallThumbnail: "https://m.media-amazon.com/images/I/81OthjkJBuL.jpg",
                    thumbnail: "https://m.media-amazon.com/images/I/81OthjkJBuL.jpg"
                ),
                bookStatus: .wantToRead
            ),
            // Libro 3: Want to Read
            UserBookModel(
                id: "234345",
                title: "1984",
                authors: ["George Orwell"],
                publishedDate: "1949",
                description: "A dystopian novel about totalitarian regime.",
                pagesRead: 0,
                pageCount: 328,
                categories: ["Fiction"],
                averageRating: 4.6,
                myRating: 0.0,
                language: "en",
                imageLinks: ImageLinks(
                    smallThumbnail: "https://m.media-amazon.com/images/I/71kxa1-0F7L.jpg",
                    thumbnail: "https://m.media-amazon.com/images/I/71kxa1-0F7L.jpg"
                ),
                bookStatus: .wantToRead
            ),
            // Libro 4: Read
            UserBookModel(
                id: "234346",
                title: "To Kill a Mockingbird",
                authors: ["Harper Lee"],
                publishedDate: "1960",
                description: "A novel about racial injustice in the Deep South.",
                pagesRead: 281,
                pageCount: 281,
                categories: ["Fiction"],
                averageRating: 4.8,
                myRating: 5.0,
                language: "en",
                imageLinks: ImageLinks(
                    smallThumbnail: "https://m.media-amazon.com/images/I/81dAIzypX6L.jpg",
                    thumbnail: "https://m.media-amazon.com/images/I/81dAIzypX6L.jpg"
                ),
                bookStatus: .read
            ),
            // Libro 5: Read
            UserBookModel(
                id: "234347",
                title: "Brave New World",
                authors: ["Aldous Huxley"],
                publishedDate: "1932",
                description: "A science fiction novel about a dystopian future.",
                pagesRead: 311,
                pageCount: 311,
                categories: ["Science Fiction"],
                averageRating: 4.2,
                myRating: 4.0,
                language: "en",
                imageLinks: ImageLinks(
                    smallThumbnail: "https://m.media-amazon.com/images/I/71e0DSh6MFL.jpg",
                    thumbnail: "https://m.media-amazon.com/images/I/71e0DSh6MFL.jpg"
                ),
                bookStatus: .read
            )
        ],
        yearlyReadingGoal: 10
    )

    // Creando el ViewModel con el usuario de ejemplo
    let viewModel = UserProfileViewModel()
    viewModel.user = exampleUser

    // Retornando la vista de previsualización
    return NavigationStack {
        UserProfileView(userProfileViewModel: viewModel, showChangeTheme: .constant(false))
    }
    .environmentObject(AuthenticationViewModel())
}


#Preview {
    UserProfileView(userProfileViewModel: UserProfileViewModel(), showChangeTheme: .constant(false))
}
