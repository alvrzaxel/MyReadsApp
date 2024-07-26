//
//  UserSettingsView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 21/7/24.
//

import SwiftUI

struct UserSettingsView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Profile")) {
                    VStack(alignment: .leading) {
                        Text("User name: \(userProfileViewModel.user?.uid ?? "000")")
                        Text("Email: \(userProfileViewModel.user?.email ?? "No email")")
                    }.foregroundStyle(.gray)
                }
                
                Section(header: Text("Account")) {
                    Button("Update password") {
                        let password = "123456789"
                        authenticationViewModel.updatePassword(newPassword: password)
                    }
                }
                
                Section(header: Text("Settings Account")) {
                    VStack {
                        ProviderView(authenticationViewModel: authenticationViewModel)
                    }
                    Button("Sign out") {
                        authenticationViewModel.logout()
                        
                    }.foregroundStyle(.red)
                }
                
                Section(header: Text("Settings Account")) {
                    Button("Delete account") {
                        authenticationViewModel.deleteAccount()
                        userProfileViewModel.deleteUserProfile()
                        print("Delete!")
                    }.font(.headline)
                        .foregroundStyle(.red)
                }
                
            }
            
            
            
            
            
            
            .onChange(of: authenticationViewModel.shouldDismiss) { oldValue, newValue in
                if newValue {
                    dismiss()
                }
        }
        }
        
    }
}

struct ProviderView:View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        HStack {
            if authenticationViewModel.isEmailAndPasswordLinked() {
                Image(systemName: "envelope")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .padding(5)
                VStack(alignment: .leading) {
                    Text("Email and Password").font(.system(size: 14, weight: .semibold))
                    Text("Your email is linked and can be used to log in to Goodreads.")
                        .font(.system(size: 12))
                }
                .padding(.horizontal, 10)
            }
            if authenticationViewModel.isGoogleLinked() {
                Image(.iconGoogle)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .padding(5)
                VStack(alignment: .leading) {
                    Text("Google").font(.system(size: 14, weight: .semibold))
                    Text("Your Google account is linked and may be used to sign into Goodreads.")
                        .font(.system(size: 12))
                }.padding(.horizontal, 10)
            }
            
            // AppleAccount
            /*
             if authenticationViewModel.isAppleLinked() {
             Image(systemName: "apple.logo")
             .resizable()
             .scaledToFit()
             .padding(5)
             VStack(alignment: .leading) {
             Text("Apple").font(.system(size: 14, weight: .semibold))
             Text("Your Apple account is linked and may be used to sign into Goodreads.")
             .font(.system(size: 12))
             }
             .padding(.horizontal, 10)
             }
             
             
             */
        }
        .task {
            authenticationViewModel.getCurrentProvider()
        }
    }
}

#Preview {
    UserSettingsView(userProfileViewModel: UserProfileViewModel())
        .environmentObject(AuthenticationViewModel())
    
}


