//
//  SearchBar.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 23/7/24.
//

import SwiftUI

struct SearchBar: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var googleApiViewModel: GoogleApiViewModel
    
    @Binding var textSearch: String
    @Binding var isLoading: Bool
    @Binding var isVisible: Bool
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            HStack {
                LabeledContent {
                    TextField("",
                              text: $textSearch,
                              prompt: Text("Title, author or ISB")
                        .foregroundStyle(.searchBarPlaceHolder.opacity(0.5))
                    )
                    .focused($isFocused)
                    .foregroundStyle(.searchBarText) // color escrito
                    .frame(maxWidth: .infinity, maxHeight: 35)
                    .autocorrectionDisabled()
                    .onSubmit {
                        Task {
                            isLoading = true
                            await googleApiViewModel.searchBooks(query: textSearch)
                            isVisible = true
                            isLoading = false
                        }
                    }
                } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18, weight: .light))
                        .foregroundStyle(.barSearchMagnifying) // color lupa
                        .padding(.leading, 10)
                }
                
                isFocusedTextDelete(isFocused: _isFocused, bookNameSearch: $textSearch)
            }
            .background(.barSearchBackGround) // Color fondo
            .cornerRadius(20)
            .padding(6)
            
            isFocusedTextCancel(isFocused: _isFocused, bookNameSearch: $textSearch, isVisible: $isVisible)
        }
        .padding(.horizontal, 10)
    }
}

// Estructura para mostrar botón de borrar texto
struct isFocusedTextDelete:View {
    @FocusState var isFocused: Bool
    @Binding var bookNameSearch: String
    
    var body: some View {
        
        if !bookNameSearch.isEmpty {
            Button {
                bookNameSearch = ""
            } label: {
                Image(systemName: "x.circle.fill")
                    .font(.system(size: 16))
                    .padding(.trailing, 9)
                    .foregroundColor(.barSearchDelete)
            }
        }
        
        
        
    }
}

// Estructura para mostrar botón de cancelar búsqueda
// Oculta el teclado
struct isFocusedTextCancel: View {
    @FocusState var isFocused: Bool
    @Binding var bookNameSearch: String
    @Binding var isVisible: Bool
    
    var body: some View {
        if isFocused || !bookNameSearch.isEmpty {
            //Spacer()
            Button(action: {
                bookNameSearch = ""
                isFocused = false
                hideKeyboard()
                isVisible = false
            }, label: {
                Text("Cancel")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.searchBarCancel)
                    .padding(.trailing, 16)
            })
        }
    }
    
    // Función para ocultar el teclado
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    SearchBar(authenticationViewModel: AuthenticationViewModel(), googleApiViewModel: GoogleApiViewModel(), textSearch: .constant(""), isLoading: .constant(false), isVisible: .constant(true))
}
