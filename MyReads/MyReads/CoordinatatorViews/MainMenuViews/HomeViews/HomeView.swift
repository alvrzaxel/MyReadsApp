//
//  HomeView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 21/7/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @ObservedObject var googleApiViewModel: GoogleApiViewModel

    @State var isLoading: Bool = false
    
    
    var body: some View {
        ZStack {
            Color.generalBackground.ignoresSafeArea()
            
            ScrollView {
                VStack {
                   
                    if !googleApiViewModel.books.isEmpty {
                        ForEach(googleApiViewModel.books, id: \.id) { book in
                            Text(book.volumeInfo.title)
                        }
                    } else {
                        
                    }
                    Spacer()
                   
                }
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .top) {
            VStack(spacing: .zero) {
                Image(.iconBar)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 35)
                    .padding(.vertical, 10)
                CircleMagnifyingGlass(googleApiViewModel: googleApiViewModel)
  
            }.background(.generalBackground.opacity(0.98))
        }
    }
}

#Preview("Ligth") {
    NavigationStack {
        HomeView(userProfileViewModel: UserProfileViewModel(), googleApiViewModel: GoogleApiViewModel())
    }
}

#Preview("Dark") {
    NavigationStack {
        HomeView(userProfileViewModel: UserProfileViewModel(), googleApiViewModel: GoogleApiViewModel())
    }
    .preferredColorScheme(.dark)
}
