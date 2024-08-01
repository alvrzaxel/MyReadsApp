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
    @StateObject var googleApiViewModel = GoogleApiViewModel()
    
    var body: some View {
        Group {
            if authenticationViewModel.user != nil {
                MainMenuView(userProfileViewModel: userProfileViewModel, googleApiViewModel: googleApiViewModel)
                    .environmentObject(authenticationViewModel)
                    .onAppear {
                        userProfileViewModel.loadCurrentUser()
                        print("Se cargan los datos del usuario")
                    }
                
            } else {
                AuthenticationView(authenticationViewModel: authenticationViewModel)
            }
        }
        .onAppear {
            authenticationViewModel.getCurrentUser()
        }
    }
}

#Preview {
    CoordinatorView(authenticationViewModel: AuthenticationViewModel(), userProfileViewModel: UserProfileViewModel())
    
}
