//
//  MyBooksPickerBooksList.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 4/8/24.
//

import SwiftUI

struct MyBooksPickerBooksList: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @Binding var selectedList: BookList
    
    var body: some View {
        VStack(spacing: 24) {
            if booksForSelectedList().isEmpty {
                HStack {
                    Text("No books here")
                        .font(.system(size: 14, weight: .thin)).italic()
                        .foregroundStyle(.colortext4)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 110)
            } else {
                ForEach(booksForSelectedList()) { book in
                    HStack {
                        BookInList(userProfileViewModel: userProfileViewModel, book: book)
                        
                    }
                }
                .padding(.vertical, 10)
            }
            
        }
        .padding(.vertical, 15)
        .background {
            UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 10, bottomTrailingRadius: 10, topTrailingRadius: 0, style: .continuous)
                .fill(.colorbackground2)
        }
    }
    
    /// Obtiene los libros filtrados según la lista seleccionada
    private func booksForSelectedList() -> [UserBookModel] {
        let filteredBooks = userProfileViewModel.user.books.filter { $0.bookStatus == selectedList.toBookStatus() }
        return filteredBooks
    }
}
