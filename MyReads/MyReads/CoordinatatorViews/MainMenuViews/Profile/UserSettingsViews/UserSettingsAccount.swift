//
//  UserSettingsAccount.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 30/7/24.
//

import SwiftUI

struct UserSettingsAccount: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    var body: some View {
        VStack {
            List {
                
                Section(header: Text("Profile")) {
                    VStack(alignment: .leading) {
                        Text("User name: \(userProfileViewModel.user.displayName)")
                        Text("User ID: \(userProfileViewModel.user.uid)")
                        Text("Email: \(userProfileViewModel.user.email)")
                    }.foregroundStyle(.gray)
                }
                
                Section(header: Text("Profile Authen")) {
                    VStack(alignment: .leading) {
                        Text("User name: \(authenticationViewModel.user?.displayName ?? "NoUserName")")
                        Text("User name: \(authenticationViewModel.user?.uid ?? "NoUserID")")
                        Text("Email: \(authenticationViewModel.user?.email ?? "NoUserEmail")")
                    }.foregroundStyle(.gray)
                }
                
                Section() {
                    Button("Update password to 123456789") {
                        let password = "123456789"
                        authenticationViewModel.updatePassword(newPassword: password)
                    }
                    
                }
                
                Section() {
                    VStack {
                        UserSettingsProvider(UserProviderID: userProfileViewModel.user.providerID)
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
        }
    }
}

struct UserSettingsProvider: View {
    var UserProviderID: ProviderID
    var body: some View {
        HStack {
            switch UserProviderID {
            case .emailAndPassword:
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
            case .google:
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
            case .apple:
                Text("You signed in with Apple")
                // Aquí puedes agregar opciones específicas para el usuario que se autenticó con Apple
            case .unknown:
                Text("Authentication provider unknown")
                // Aquí puedes manejar el caso en el que el proveedor de autenticación es desconocido
            }
        }
    }
}




#Preview {
    UserSettingsAccount(userProfileViewModel: UserProfileViewModel())
}
