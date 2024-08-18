//
//  UserSettingsView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 21/7/24.
//

import SwiftUI
import PhotosUI

struct UserProfileSettingsView3: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            
            NavigationStack {
                List {
                    Section() {
                        
                        HStack(spacing: 20) {
                            if let profileImage = userProfileViewModel.profileImage {
                                UserImageSettingsView(profileImage: profileImage)
                                    .frame(width: 50, height: 50)
                                
                            } else {
                                UserEmptyImageSettingsView()
                                    .frame(width: 50, height: 50)
                            }
                            
                            Text(userProfileViewModel.user.displayName)
                        }
                        
                    }
                    
                    
                    
                    Section() {
                        NavigationLink {
                            UserSettingsProfile(userProfileViewModel: userProfileViewModel)
                        } label: {
                            Label(
                                title: { Text("Profile") },
                                icon: { Image(systemName: "person") }
                            )
                        }
                        
                        NavigationLink {
                            UserSettingsAccount(userProfileViewModel: userProfileViewModel)
                        } label: {
                            Label(
                                title: { Text("Account") },
                                icon: { Image(systemName: "key") }
                            )
                        }
                        
                    }
                    
                    
                }
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.primary)
                        }
                    }
                }
                
                
            }
            
        }
        
        
    }
}


struct UserImageSettingsView: View {
    var profileImage: UIImage
    
    var body: some View {
        Image(uiImage: profileImage).resizable().scaledToFill()
        //.frame(width: 50, height: 50)
            .clipShape(.rect(cornerRadius: 110))
    }
}

struct UserEmptyImageSettingsView: View {
    var body: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
        //.frame(width: 50, height: 50)
            .foregroundStyle(.gray)
        
    }
}





#Preview {
    UserSettingsProfile(userProfileViewModel: UserProfileViewModel())
}

#Preview {
    UserProfileSettingsView3(userProfileViewModel: UserProfileViewModel())
        .environmentObject(AuthenticationViewModel())
}

