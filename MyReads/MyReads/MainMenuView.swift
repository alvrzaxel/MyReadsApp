//
//  HomeView2.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 24/7/24.
//

import SwiftUI

struct MainMenuView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @StateObject var googleApiViewModel = GoogleApiViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(authenticationViewModel: authenticationViewModel, userProfileViewModel: userProfileViewModel, googleApiViewModel: googleApiViewModel)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
                
            
            
            
            UserProfileView(authenticationViewModel: authenticationViewModel, userProfileViewModel: userProfileViewModel)
                .tabItem {
                    Label("Profile", systemImage: "profile")
                }
            
        }
    }
}


