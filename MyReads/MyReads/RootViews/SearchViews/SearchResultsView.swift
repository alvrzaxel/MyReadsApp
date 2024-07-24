//
//  SearchResultsView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 23/7/24.
//

import SwiftUI

import SwiftUI

struct SearchResultsView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var googleApiViewModel: GoogleApiViewModel
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @Binding var isVisible: Bool
    
    var body: some View {
        VStack {
            if googleApiViewModel.books.isEmpty {
                Text("No results found.")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                ScrollView {
                    ForEach(googleApiViewModel.books) { book in
                        VStack {
                            BookDetailsInListView(userProfileViewModel: userProfileViewModel, book: book)
                            
                            Divider()
                        }
                        .padding(5)
                    }
                }
                .frame(maxWidth: .infinity)
                .scrollIndicators(.never)
            }
        }
    }
}

#Preview {
    SearchResultsView(authenticationViewModel: AuthenticationViewModel(), googleApiViewModel: GoogleApiViewModel(), userProfileViewModel: UserProfileViewModel(), isVisible: .constant(true))
    
}
