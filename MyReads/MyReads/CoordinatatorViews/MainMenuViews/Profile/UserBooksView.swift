//
//  UserBooksView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 5/8/24.
//

import SwiftUI


enum BookStatusFilter {
    case wantToRead
    case read
    
    var title: String {
        switch self {
        case .wantToRead:
            return "Want to read"
        case .read:
            return "Read"
        }
    }
    
    var filter: (UserBookModel) -> Bool {
        switch self {
        case .wantToRead:
            return { $0.bookStatus == .wantToRead }
        case .read:
            return { $0.bookStatus == .read }
        }
    }
}


struct UserBooksView: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @State var filteredBooks: [UserBookModel] = []
    @State var selectedBook: UserBookModel?
    @State var showBookDetails: Bool = false
    @State var showBookList: Bool = false
    @State var selectedList: BookList = .wantToRead
    var bookStatusFilter: BookStatusFilter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(bookStatusFilter.title)
                .font(.footnote)
                .foregroundStyle(.colortext7)
                .padding(.leading, 20)
            
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    if !filteredBooks.isEmpty {
                        ForEach(filteredBooks.indices, id: \.self) { index in
                            UserCoverButton(
                                userProfileViewModel: userProfileViewModel,
                                book: $filteredBooks[index],
                                onDismiss: { updateFilteredBooks() }
                            )
                            .padding(.leading, index == 0 ? 20 : 0)
                        }
                    }
                    VStack {
                        Button(action: {
                            showBookList.toggle()
                            selectedList = bookStatusFilter == .wantToRead ? .wantToRead : .read
                            
                        }, label: {
                            CustomRoundedRectangle(
                                overlayText: !filteredBooks.isEmpty ? "\(filteredBooks.count)\nbooks".uppercased() : "No\nbooks\nhere", width: 60,
                                height: 90,
                                colorBackground: filteredBooks.isEmpty ? .colorbackground3 : .colorAccentOrange,
                                colorText: filteredBooks.isEmpty ? .colortext10 : .colortext3, isItalic: false, isBold: true)
                            .opacity(0.5)
                            
                        })
                        
                    }
                    .padding(.leading, filteredBooks.isEmpty ? 20 : 0)
                }
                
            }
            .scrollIndicators(.never)
        }
        .onAppear {
            updateFilteredBooks()
        }
        
        .fullScreenCover(isPresented: $showBookDetails, onDismiss: { updateFilteredBooks() }, content: {
            if let selectedBook = selectedBook {
                BookDetailsView(userProfileViewModel: userProfileViewModel, book: .constant(selectedBook), bookStatus: .constant(selectedBook.bookStatus))
            }
        })
        
        .sheet(isPresented: $showBookList, onDismiss: { updateFilteredBooks() }, content: {
            MyBooksPickerView(userProfileViewModel: userProfileViewModel, selectedList: $selectedList)
                .padding(.top)
        })
    }
    
    private func updateFilteredBooks() {
        filteredBooks = userProfileViewModel.user.books.filter(bookStatusFilter.filter)
    }
}

#Preview {
    UserBooksView(userProfileViewModel: UserProfileViewModel(), bookStatusFilter: .read)
}
