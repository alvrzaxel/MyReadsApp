//
//  UserSettingsView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 21/7/24.
//

import SwiftUI
import PhotosUI

struct UserProfileSettingsView3: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.colorbackground1.ignoresSafeArea()
                
                VStack(spacing: 36) {
                    UserSettingsImageProfile(userProfileViewModel: userProfileViewModel)
                    UserSettingsDetails(userProfileViewModel: userProfileViewModel)
                    
                    UserSettingsAccount(userProfileViewModel: userProfileViewModel)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        
    }
}

#Preview {
    UserProfileSettingsView3(userProfileViewModel: UserProfileViewModel())
        .environmentObject(AuthenticationViewModel())
}

