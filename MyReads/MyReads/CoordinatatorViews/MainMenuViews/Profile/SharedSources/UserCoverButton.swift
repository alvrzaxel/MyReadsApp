//
//  UserCoverButton.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 5/8/24.
//

import SwiftUI

struct UserCoverButton: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @Binding var book: UserBookModel
    @State var showBookDetails: Bool = false
    var onDismiss: (() -> Void)?
    
    var body: some View {
        VStack {
            Button(action: {
                showBookDetails.toggle()
            }, label: {
                VStack {
                    CustomCoverImage(imageUrl: book.imageLinks?.thumbnail)
                }
            })
            
        }
        .fullScreenCover(isPresented: $showBookDetails, onDismiss: onDismiss) {
            BookDetailsView(userProfileViewModel: userProfileViewModel, book: $book, bookStatus: $book.bookStatus)
        }
    }
}
