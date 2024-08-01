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
            Genres(name: "music", query: "Music"),
            Genres(name: "psychology", query: "Psychology")
        ]
}

struct HomeGenres: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @ObservedObject var googleApiViewModel: GoogleApiViewModel
    
    let genres = Genres.allGenres
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                ExtractedView(googleApiViewModel: googleApiViewModel, genres: genres)
            }
            
//            ScrollView(.vertical) {
//                
//                    if !googleApiViewModel.booksByCategory.isEmpty {
//                    SearchResultsView(userProfileViewModel: userProfileViewModel, userBooks: userProfileViewModel.convertBooksArray(from: googleApiViewModel.booksByCategory, with: .unkenow))
//                    
//                    
//                } else {
//                    Text("No books available in this category.")
//                }
//                 
//            }
        }
        .scrollIndicators(.never)
    }
}



#Preview {
    HomeGenres(userProfileViewModel: UserProfileViewModel(), googleApiViewModel: GoogleApiViewModel())
}


struct ExtractedView: View {
    @ObservedObject var googleApiViewModel: GoogleApiViewModel
    let genres: [Genres]
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(genres) { genre in
                Button(action: {
                    Task {
                        await googleApiViewModel.loadBooksForCategory(category: genre.query)
                    }
                }) {
                    Text("# \(genre.name)")
                        .foregroundStyle(.textQuaternary)
                }
                .font(.system(size: 20))
                .padding(5)
                .padding(.horizontal)
                .overlay {
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.gray)
                }
                .padding(.leading)
            }
        }
        .padding(.top, 30)
        .padding(.bottom, 30)
    }
}
