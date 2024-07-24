//
//  HomeView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 21/7/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @ObservedObject var googleApiViewModel: GoogleApiViewModel
    
    @State var textSearch: String = ""
    @State var isLoading: Bool = false
    @State var isVisible: Bool = false
    
    var body: some View {
        VStack {
            if isVisible {
                SearchResultsView(authenticationViewModel: authenticationViewModel, googleApiViewModel: googleApiViewModel, userProfileViewModel: userProfileViewModel, isVisible: $isVisible)
                
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
                SearchBar(authenticationViewModel: authenticationViewModel, googleApiViewModel: googleApiViewModel, textSearch: $textSearch, isLoading: $isLoading, isVisible: $isVisible)
                    .frame(maxHeight: 50)
            }
            .background(.generalBackground.opacity(0.98))
            
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(authenticationViewModel: AuthenticationViewModel(), userProfileViewModel: UserProfileViewModel(), googleApiViewModel: GoogleApiViewModel())
    }
}
