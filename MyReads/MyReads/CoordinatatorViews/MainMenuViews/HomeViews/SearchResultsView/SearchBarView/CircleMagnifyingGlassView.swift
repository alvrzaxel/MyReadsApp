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
            RoundedRectangle(cornerRadius: showSearchTextField ? 8 : 20)
                .frame(width: showSearchTextField ? 270 : 32, height: showSearchTextField ? 32 : 32)
                .foregroundStyle(.colorbackground4)
                .overlay {
                    SearchTextField(googleApiViewModel: googleApiViewModel, textToSearch: $textToSearch, showSearchTextField: $showSearchTextField)
                }
            
            if showSearchTextField {
                Spacer()
                Button(action: {
                    withAnimation(.bouncy) {
                        showSearchTextField.toggle()
                        UIApplication.shared.hideKeyboard()
                        googleApiViewModel.booksResultSearch = nil
                        textToSearch = ""
                    }
                }, label: {
                    Text("Cancel").foregroundStyle(.colorAccentOrange)
                })
                Spacer()
            }
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: 45, alignment: .topLeading)
        
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
                .foregroundStyle(.colortext1)
                .onTapGesture {
                    withAnimation(.bouncy) {
                        showSearchTextField.toggle()
                        isTextFieldFocused = true
                        googleApiViewModel.booksResultSearch = nil
                    }
                }
            HStack {
                if showSearchTextField {
                    TextField("",
                              text: $textToSearch,
                              prompt: Text("Title, author or ISB")
                        .foregroundStyle(.colortext8)
                    )
                    .focused($isTextFieldFocused)
                    .frame(width: 205).frame(maxHeight: .infinity)
                    .foregroundStyle(.colortext4)
                    .onSubmit {
                        googleApiViewModel.isLoading = true
                        Task {
                            print(textToSearch)
                            UIApplication.shared.hideKeyboard()
                            await googleApiViewModel.searchBooks(query: textToSearch)
                        }
                        googleApiViewModel.isLoading = false
                    }
                    .overlay {
                        ButtonDeleteTextField(isFocused: _isTextFieldFocused, textToSearch: $textToSearch)
                    }
                    
                }
            }
            Spacer()
            
        }
        .onDisappear {
            googleApiViewModel.booksResultSearch = nil
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
                    isFocused = true
                }) {
                    Image(systemName: "x.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.colortext9)
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
