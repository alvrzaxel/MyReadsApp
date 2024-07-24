//
//  HomeView2.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 24/7/24.
//

import SwiftUI

struct                 MainMenuView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    
    var body: some View {
        VStack {
            
        }
        .onAppear {
            Task {
                await userProfileViewModel.getCurrentUser()
            }
        }
    }
}

#Preview {
                    MainMenuView(authenticationViewModel: AuthenticationViewModel(), userProfileViewModel: UserProfileViewModel())
}
