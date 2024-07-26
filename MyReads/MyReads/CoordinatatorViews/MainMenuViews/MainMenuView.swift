//
//  HomeView2.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 24/7/24.
//

import SwiftUI

struct MainMenuView: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @StateObject var googleApiViewModel = GoogleApiViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(userProfileViewModel: userProfileViewModel, googleApiViewModel: googleApiViewModel)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
                
            MyBooksView()
                .tabItem {
                    Label("Profile", systemImage: "book")
                }
                .tag(1)
            
            ProfileImageView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(2)
            
            UserProfileView(userProfileViewModel: userProfileViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(3)
            
        }
    }
}

#Preview {
    MainMenuView(userProfileViewModel: UserProfileViewModel(), googleApiViewModel: GoogleApiViewModel())
}
