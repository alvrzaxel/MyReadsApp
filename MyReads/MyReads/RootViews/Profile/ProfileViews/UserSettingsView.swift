//
//  UserSettingsView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 21/7/24.
//

import SwiftUI

struct UserSettingsView: View {
    @ObservedObject var authenticationViewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading) {
                    Text("User name: \(authenticationViewModel.user?.uid ?? "000")")
                    Text("Email: \(authenticationViewModel.user?.email ?? "No email")")
                }.foregroundStyle(.gray)
                
                
            }
            
            // Sección ajustes de la cuenta
            Section {
                Button("Reset password") {
                    guard let email = authenticationViewModel.user?.email else {
                        
                        print("Email not available for password reset.")
                        return
                    }
                    authenticationViewModel.resetPassword(email: email)
                }
                
                Button("Update password") {
                    let password = "123456789"
                    authenticationViewModel.updatePassword(newPassword: password)
                }
            } header: {
                Text("settings Account")
            }
            
            // Sección Provider/LogOut
            Section {
                VStack {
                    ProviderView(authenticationViewModel: authenticationViewModel)
                }
                Button("Sign out") {
                    authenticationViewModel.logout()
                }.foregroundStyle(.red)
                
            }header: {
                Text("Connected acounsts")
            }
            
            // Sección DELETE
            Section {
                Button("Delete account") {
                    //TODO
                }.font(.headline)
                    .foregroundStyle(.red)
            }
        }
        .alert(isPresented: $authenticationViewModel.showAlert) {
            Alert(
                title: Text("Password Reset"),
                message: Text(authenticationViewModel.alertMessage ?? "An unknown error occurred."),
                dismissButton: .default(Text("OK"))
            )
        }
        .onChange(of: authenticationViewModel.shouldDismiss) { oldValue, newValue in
            if newValue {
                dismiss()
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
    UserSettingsView(authenticationViewModel: AuthenticationViewModel())
    
}


