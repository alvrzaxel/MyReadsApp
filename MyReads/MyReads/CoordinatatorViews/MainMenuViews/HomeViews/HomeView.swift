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
    
    @State var textSearch: String = ""
    @State var isLoading: Bool = false
    @State var isVisible: Bool = false
    
    var body: some View {
        VStack {
            
            Text(userProfileViewModel.user?.email ?? "noemail")
            Text(userProfileViewModel.user?.email ?? "noemail")
            Text(userProfileViewModel.user?.photoURL ?? "nophoto")
            
            if isVisible {
                SearchResultsView(googleApiViewModel: googleApiViewModel, userProfileViewModel: userProfileViewModel, isVisible: $isVisible)
                
            } else {
                ScrollView {
                    VStack {
                        HomeNew()
                    }
                    HomeGenres()
                }
                .background(.generalBackground)
            }
        }
        .background(.generalBackground)
        .safeAreaInset(edge: .top) {
            VStack(spacing: .zero) {
                Image(.iconBar)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 35)
                    .padding(.vertical, 10)
                SearchBar(googleApiViewModel: googleApiViewModel, textSearch: $textSearch, isLoading: $isLoading, isVisible: $isVisible)
                    .frame(maxHeight: 50)
            }
            .background(.generalBackground.opacity(0.98))
            
        }
        .overlay {
            PlusView()
                
        }
//        .onAppear {
//                userProfileViewModel.loadCurrentUser()
//        }
        
        
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
