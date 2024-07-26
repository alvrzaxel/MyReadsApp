//
//  SearchBar2.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 25/7/24.
//

import SwiftUI

struct CircleMagnifyingGlass: View {
    @ObservedObject var googleApiViewModel: GoogleApiViewModel
    @State var showSearchTextField: Bool = false
    @State var textToSearch: String = ""
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: showSearchTextField ? 270 : 35, height: showSearchTextField ? 35 : 35)
                .foregroundStyle(.barSearchBackGround)
                .overlay {
                    SearchTextField(googleApiViewModel: googleApiViewModel, textToSearch: $textToSearch, showSearchTextField: $showSearchTextField)
                }
            
            if showSearchTextField {
                Spacer()
                Button(action: {
                    withAnimation(.snappy) {
                        showSearchTextField.toggle()
                        googleApiViewModel.books = []
                    }
                }, label: {
                    Text("Cancel")
                })
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 45, alignment: .topLeading)
        .padding(.horizontal, 20)
        .background(.generalBackground.opacity(0.5))
    }
}


struct SearchTextField:View {
    @ObservedObject var googleApiViewModel: GoogleApiViewModel
    @Binding var textToSearch: String
    @Binding var showSearchTextField: Bool
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18, weight: .light))
                .padding(.leading, showSearchTextField ? 7 : 18)
                .foregroundStyle(.barSearchMagnifying)
                .onTapGesture {
                    isTextFieldFocused = true
                    withAnimation(.snappy) {
                        showSearchTextField.toggle()
                    }
                }
            HStack {
                if showSearchTextField {
                    TextField("",
                              text: $textToSearch,
                              prompt: Text("Title, author or ISB")
                        .foregroundStyle(.black.opacity(0.5))
                    )
                    .focused($isTextFieldFocused)
                    .frame(width: 205).frame(maxHeight: .infinity)
                    .foregroundStyle(.searchBarText)
                    .onSubmit {
                        Task {
                            await googleApiViewModel.searchBooks(query: textToSearch)
                        }
                    }
                    .overlay {
                        ButtonDeleteTextField(isFocused: _isTextFieldFocused, textToSearch: $textToSearch)
                    }

                }
            }
            Spacer()
            
        }
    }
}

struct ButtonDeleteTextField:View {
    @FocusState var isFocused: Bool
    @Binding var textToSearch: String
    
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            if !textToSearch.isEmpty {
                Button(action: {
                    textToSearch = ""
                }) {
                    Image(systemName: "x.circle.fill")
                        .font(.system(size: 16))
                }
            }
        }.frame(width: 255)
        
    }
}








#Preview("CircleMagnifyingGlass") {
    CircleMagnifyingGlass(googleApiViewModel: GoogleApiViewModel())
}

#Preview("ButtonMenu2") {
    SearchTextField(googleApiViewModel: GoogleApiViewModel(), textToSearch: .constant("ssdsdsdsd"), showSearchTextField: .constant(true))
}



//[GoogleBookModel(id: "123", volumeInfo: VolumeInfo(title: "Un lugar para mungo", authors: ["Duglas Stuart"], publishedDate: "2013", description: "Descripción", industryIdentifiers: [IndustryIdentifiers(type: "tipe", identifier: "123456")], pageCount: 400, categories: ["fiction"], averageRating: 4.5, imageLinks: ImageLinks(smallThumbnail: "", thumbnail: ""), language: "es"), saleInfo: SaleInfo(isEbook: true))]
