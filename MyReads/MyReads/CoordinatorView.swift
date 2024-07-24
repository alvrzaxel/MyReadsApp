//
//  ContentView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 24/7/24.
//

import SwiftUI

struct CoordinatorView: View {
    @StateObject var authenticationViewModel = AuthenticationViewModel ()
    @StateObject var userProfileViewModel = UserProfileViewModel()
    
    var body: some View {
        Group {
            if authenticationViewModel.user != nil {
                MainMenuView(authenticationViewModel: authenticationViewModel, userProfileViewModel: userProfileViewModel)
            } else {
                AuthenticationView(authenticationViewModel: authenticationViewModel)
            }
        }
    }
}

#Preview {
    CoordinatorView(authenticationViewModel: AuthenticationViewModel(), userProfileViewModel: UserProfileViewModel())
    
}
