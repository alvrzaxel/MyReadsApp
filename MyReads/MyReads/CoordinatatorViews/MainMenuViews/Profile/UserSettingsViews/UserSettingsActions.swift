//
//  UserSettingsActions.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 5/8/24.
//

import SwiftUI

struct UserSettingsActions: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    var icon: String
    var title: String
    var description: String
    var canChangePassword: Bool
    var body: some View {
        HStack(spacing: 10) {
            
            VStack {
                if icon == "google" {
                    Image(.iconGoogle)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 26)
                    
                } else {
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                }
            }
            .frame(width: 40)
            
            VStack(alignment: .leading) {
                Text(title).font(.system(size: 14, weight: .semibold))
                Text(description)
                    .font(.system(size: 12))
                    .multilineTextAlignment(.leading)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        
        VStack(spacing: 10) {
            HStack {
                Button(action: {
                    //TODO
                }, label: {
                    Text("Update email").font(.footnote)
                        .foregroundStyle(canChangePassword ? .colortext2 : .gray)
                    
                })
                
                Spacer()
            }
            .disabled(!canChangePassword)
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .fill(.colorbackground3)
                    .shadow(color: .colortext1, radius: 0.5)
            }
            
            Button(action: {
                let password = "123456789"
                authenticationViewModel.updatePassword(newPassword: password)
            }, label: {
                HStack {
                    Text("Update password").font(.footnote)
                        .foregroundStyle(canChangePassword ? .colortext2 : .gray)
                    Spacer()
                }
            })
            .disabled(!canChangePassword)
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .fill(.colorbackground3)
                    .shadow(color: .colortext1, radius: 0.5)
            }
            
            Button(action: {
                authenticationViewModel.logout()
            }, label: {
                HStack {
                    Text("Sign Out").font(.footnote).bold()
                        .foregroundStyle(.red)
                    Spacer()
                }
            })
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .fill(.colorbackground3)
                    .shadow(color: .colortext1, radius: 0.5)
            }
        }
    }
}

#Preview {
    UserSettingsActions(userProfileViewModel: UserProfileViewModel(), icon: "apple.logo", title: "Aple", description: "Your Apple account is linked and may be used to sign into MyReads.", canChangePassword: true)
        .environmentObject(AuthenticationViewModel())
}
