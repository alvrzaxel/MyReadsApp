//
//  HomeView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 20/7/24.
//

import SwiftUI
import UIKit

struct RootView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @StateObject var googleApiViewModel = GoogleApiViewModel()
    
    @State private var selectedTab: Int = 1
    
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(authenticationViewModel: authenticationViewModel, userProfileViewModel: userProfileViewModel, googleApiViewModel: googleApiViewModel)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            UserProfileView(authenticationViewModel: authenticationViewModel, userProfileViewModel: userProfileViewModel)
                .tabItem {
                    Label("My Reads", systemImage: "book")
                }
                .tag(1)
        }
        .accentColor(.loginRegistrerUnderline)
        .onAppear {
            authenticationViewModel.cleanErrorMessage()
            if let user = authenticationViewModel.user {
                userProfileViewModel.user = user
            }
        }
    }
}

#Preview {
    RootView(authenticationViewModel: AuthenticationViewModel(), userProfileViewModel: UserProfileViewModel())
}


