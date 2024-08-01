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
    
    var body: some View {
        ZStack {
            Color.backgroundGeneral.ignoresSafeArea()
            
            VStack {
                if googleApiViewModel.booksResultSearch != nil {
                    SearchResultsView(userProfileViewModel: userProfileViewModel, googleApiViewModel: googleApiViewModel)
                    
                } else {
                    
                    HomeWelcome(name: userProfileViewModel.user.displayName)
                    HomeGenres(userProfileViewModel: userProfileViewModel, googleApiViewModel: googleApiViewModel)
                }
            }
        }
        .safeAreaInset(edge: .top, content: {
            NavBarHome(googleApiViewModel: googleApiViewModel)
        })
    }
}

struct NavBarHome: View {
    @ObservedObject var googleApiViewModel: GoogleApiViewModel
    
    var body: some View {
        VStack {
            Image(.iconBar)
                .resizable()
                .scaledToFit()
                .frame(height: 30)
                
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .padding(.bottom, 10)
        .background(.backgroundGeneral.opacity(0.95))
        .overlay {
            CircleMagnifyingGlass(googleApiViewModel: googleApiViewModel)
                .offset(y: 2)
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


