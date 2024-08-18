//
//  HomeGenres.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 23/7/24.
//

import SwiftUI

struct Genres: Identifiable {
    var id = UUID()
    var name: String
    var query: String
    
    static let allGenres: [Genres] = [
        Genres(name: "fiction", query: "Fiction"),
        Genres(name: "drama", query: "Drama"),
        Genres(name: "science", query: "Science"),
        Genres(name: "history", query: "History"),
        Genres(name: "juvenile", query: "Juvenile+Fiction"),
        Genres(name: "music", query: "Music")
    ]
}

struct HomeGenres: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @ObservedObject var googleApiViewModel: GoogleApiViewModel
    @State private var selectedGenre: String? = "Fiction"
    let genres = Genres.allGenres
    
    var body: some View {
        VStack(spacing: 6) {
            ScrollView(.horizontal) {
                HomeGenresListButtons(googleApiViewModel: googleApiViewModel, selectedGenre: $selectedGenre, genres: genres)
            }
            
            ScrollView(.vertical) {
                if !googleApiViewModel.booksByCategory.isEmpty {
                    VStack(spacing: 22) {
                        ForEach(googleApiViewModel.booksByCategory) { book in
                            BookInList(
                                userProfileViewModel: userProfileViewModel, book: book)
                        }
                    }
                    .padding(.leading, 4)
                    .padding(.top, 16)
                    .padding(.bottom, 100)
                } else {
                    ProgressView()
                    Text("No books available in this category.")
                }
            }
            
        }
        .scrollIndicators(.never)
        .onAppear {
            Task {
                if googleApiViewModel.booksByCategory.isEmpty {
                    await googleApiViewModel.loadBooksForCategory(category: "fiction")
                }
            }
        }
    }
}



#Preview {
    HomeGenres(userProfileViewModel: UserProfileViewModel(), googleApiViewModel: GoogleApiViewModel())
}


struct HomeGenresListButtons: View {
    @ObservedObject var googleApiViewModel: GoogleApiViewModel
    @Binding var selectedGenre: String?
    @Namespace private var animationGenres
    let genres: [Genres]
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(Array(genres.enumerated()), id: \.element.query) { index, genre in
                Button(action: {
                    selectedGenre = genre.query
                    Task {
                        await googleApiViewModel.loadBooksForCategory(category: genre.query)
                    }
                    
                }, label: {
                    HStack(alignment: .center, spacing: .zero) {
                        Text("#")
                            .foregroundStyle(selectedGenre == genre.query ? .colorAccentOrange : .colortext8)
                        Text(genre.name)
                            .foregroundStyle(selectedGenre == genre.query ? .colortext3 : .colortext8)
                    }
                    .font(.system(size: 16))
                    .frame(width: 90)
                    .padding(.vertical, 8)
                    .background {
                        ZStack {
                            if selectedGenre == genre.query {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.colorbackground3)
                                    .matchedGeometryEffect(id: "ACTIVEGENRE", in: animationGenres)
                            }
                        }
                        .animation(.smooth, value: selectedGenre)
                    }
                })
                .padding(.leading, index == 0 ? 20 : 5)
            }
        }
        .frame(maxHeight: 50)
    }
}
