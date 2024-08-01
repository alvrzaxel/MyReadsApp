//
//  HomeView2.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 24/7/24.
//

import SwiftUI

struct MainMenuView: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @ObservedObject var googleApiViewModel: GoogleApiViewModel
    @StateObject private var keyboardManager = KeyboardManager()
    @State var selectedView: TabIcon = .home
    
    var body: some View {
        ZStack {
            Color.backgroundGeneral.ignoresSafeArea()
            
            VStack {
                switch selectedView {
                case .home:
                    HomeView(userProfileViewModel: userProfileViewModel, googleApiViewModel: googleApiViewModel)
                case .book:
                    MyBooksView()
                case .person:
                    UserProfileView(userProfileViewModel: userProfileViewModel)
                        
                }

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(nil, value: selectedView)
            .transition(.identity)
            .overlay(alignment: .bottom) {
                CustomNav(selectedTab: $selectedView)
                    .padding(.bottom, 20).background(.backgroundGeneral.opacity(0.90))
                    
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    MainMenuView(userProfileViewModel: UserProfileViewModel(), googleApiViewModel: GoogleApiViewModel())
}
