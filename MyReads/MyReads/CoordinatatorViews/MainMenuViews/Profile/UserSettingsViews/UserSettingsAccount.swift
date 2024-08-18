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
    @State var canChangePassword: Bool = false
    @State private var showDeleteConfirmation: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 20) {
                switch userProfileViewModel.user.providerID {
                case .emailAndPassword:
                    UserSettingsActions(userProfileViewModel: userProfileViewModel, icon: "envelope", title: "Email and Password", description: "Your email is linked and can be used to log in to MyReads.", canChangePassword: false)
                case .google:
                    UserSettingsActions(userProfileViewModel: userProfileViewModel, icon: "google", title: "Google", description: "Your Google account is linked and may be used to sign into MyReads.", canChangePassword: false)
                case .apple:
                    UserSettingsActions(userProfileViewModel: userProfileViewModel, icon: "apple.logo", title: "Apple", description: "Your Apple account is linked and may be used to sign into MyReads.", canChangePassword: false)
                case .unknown:
                    UserSettingsActions(userProfileViewModel: userProfileViewModel, icon: "questionmark", title: "Unkenow", description: "We cannot identify your MyReads account.", canChangePassword: false)
                    
                }
                
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .fill(.colorbackground2)
            }
            
            VStack {
                Button(action: {
                    showDeleteConfirmation.toggle()
                }, label: {
                    HStack {
                        Spacer()
                        Text("Delete account")
                            .font(.callout)
                            .bold()
                            .foregroundColor(.colortext1)
                        Spacer()
                    }
                })
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.red)
                }
            }
        }
        .frame(maxHeight: .infinity)
        .alert(isPresented: $showDeleteConfirmation) { // Configuración de la alerta
            Alert(
                title: Text("Delete Account"),
                message: Text("Are you sure?\nThis action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    // Acción para eliminar la cuenta
                    authenticationViewModel.deleteAccount()
                    userProfileViewModel.deleteUserProfile()
                },
                secondaryButton: .cancel()
            )
        }
    }
}


#Preview {
    UserSettingsAccount(userProfileViewModel: UserProfileViewModel())
        .environmentObject(AuthenticationViewModel())
}



