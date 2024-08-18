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
    @Binding  var showChangeTheme: Bool
    
    var body: some View {
        ZStack {
            Color.colorbackground1.ignoresSafeArea()
            
            VStack(spacing: 50) {
                if googleApiViewModel.booksResultSearch != nil {
                    SearchResultsView(userProfileViewModel: userProfileViewModel, googleApiViewModel: googleApiViewModel)
                    
                } else {
                    HomeWelcome(name: userProfileViewModel.user.displayName)
                    HomeGenres(userProfileViewModel: userProfileViewModel, googleApiViewModel: googleApiViewModel)
                }
            }
        }
        .safeAreaInset(edge: .top, content: {
            CustomNavBarHome(googleApiViewModel: googleApiViewModel, showChangeTheme: $showChangeTheme)
        })
    }
}



#Preview("Ligth") {
    NavigationStack {
        HomeView(userProfileViewModel: UserProfileViewModel(), googleApiViewModel: GoogleApiViewModel(), showChangeTheme: .constant(false))
    }
}

#Preview("Dark") {
    NavigationStack {
        HomeView(userProfileViewModel: UserProfileViewModel(), googleApiViewModel: GoogleApiViewModel(), showChangeTheme: .constant(false))
    }
    .preferredColorScheme(.dark)
}


