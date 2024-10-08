//
//  SearchResultsView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 23/7/24.
//

import SwiftUI

struct SearchResultsView: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @ObservedObject var googleApiViewModel: GoogleApiViewModel
    
    var body: some View {
        VStack {
            if let bookSearchResults = googleApiViewModel.booksResultSearch {
                if bookSearchResults.isEmpty {
                    Text("No results found.")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(bookSearchResults, id: \.id) { book in
                                VStack {
                                    BookInList(userProfileViewModel: userProfileViewModel, book: book)
                                    
                                }
                                .padding(5)
                                
                            }
                        }
                        .padding(.bottom, 90)
                    }
                    .frame(maxWidth: .infinity)
                    .scrollIndicators(.never)
                    
                }
            }
        }

        
    }
}

#Preview {
    SearchResultsView(userProfileViewModel: UserProfileViewModel(), googleApiViewModel: GoogleApiViewModel())
}
