//
//  HomeView2.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 24/7/24.
//

import SwiftUI

struct MainMenuView: View {
    @AppStorage("userTheme") private var userTheme: Theme = .systemDefault
    @Environment(\.colorScheme) private var scheme
    @State private var showChangeTheme: Bool = false
    
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @ObservedObject var googleApiViewModel: GoogleApiViewModel
    @State var selectedView: TabIcon = .home
    
    var body: some View {
        ZStack {
            Color.backgroundGeneral.ignoresSafeArea()
            
            VStack {
                switch selectedView {
                case .home:
                    HomeView(userProfileViewModel: userProfileViewModel, googleApiViewModel: googleApiViewModel, showChangeTheme: $showChangeTheme)
                        .preferredColorScheme(userTheme.colorScheme)
                case .book:
                    MyBooksView(showChangeTheme: $showChangeTheme, userProfileViewModel: userProfileViewModel)
                        .preferredColorScheme(userTheme.colorScheme)
                case .person:
                    UserProfileView(userProfileViewModel: userProfileViewModel, showChangeTheme: $showChangeTheme)
                        .preferredColorScheme(userTheme.colorScheme)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(nil, value: selectedView)
            .transition(.identity)
            .overlay(alignment: .bottom) {
                CustomTabBarView(selectedTab: $selectedView)
            }
        }
        .sheet(isPresented: $showChangeTheme, content: {
            ThemeChangeView(scheme: scheme)
                .presentationDetents([.height(410)])
                .presentationBackground(.clear)
        })
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    MainMenuView(userProfileViewModel: UserProfileViewModel(), googleApiViewModel: GoogleApiViewModel())
        
}



