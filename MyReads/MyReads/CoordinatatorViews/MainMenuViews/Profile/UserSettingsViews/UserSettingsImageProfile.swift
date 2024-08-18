//
//  UserSettingsProfile.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 30/7/24.
//

import SwiftUI
import PhotosUI

struct UserSettingsImageProfile: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @State var selectedItem: PhotosPickerItem? = nil
    @State var showPicker: Bool = false
    
    @State var newDisplayName: String = ""
    @State var newBooksGoal: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            
            VStack {
                if let profileImage = userProfileViewModel.profileImage {
                    UserImageSettingsView(profileImage: profileImage)
                        .frame(width: 120, height: 120)
                } else {
                    UserEmptyImageSettingsView()
                        .frame(width: 120, height: 120)
                }
            }
            .overlay(alignment: .topTrailing) {
                Button(action: {
                    showPicker.toggle()
                }) {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(10)
                        .background(.colorbackground5.opacity(0.6), in: .circle)
                }
                .offset(x: 10, y: 80)
                .foregroundStyle(.colorAccentOrange)
            }
            .photosPicker(isPresented: $showPicker, selection: $selectedItem, matching: .images)
            
            Text(userProfileViewModel.user.displayName)
                .font(.system(size: 24, weight: .semibold))
            
            
            List {
                Section(header: Text("User Name")) {
                    TextField(text: $newDisplayName) {
                        Text(userProfileViewModel.user.displayName)
                    }
                    .onSubmit {
                        userProfileViewModel.updateUserProfileProperty(property: .displayName(newDisplayName))
                    }
                }
                
//                Section(header: Text("Email")) {
//                    TextField(text: $displayName) {
//                        Text(userProfileViewModel.user.email)
//                    }
//                }
                
                Section(header: Text("Goal books read by 2024")) {
                    TextField(text: $newBooksGoal) {
                        Text(String(userProfileViewModel.user.yearlyReadingGoal))
                    }
                    .onSubmit {
                        userProfileViewModel.updateUserProfileProperty(property: .yearlyReadingGoal(Int(newBooksGoal) ?? 1))
                    }
                }
            }.foregroundStyle(.primary)
            .listStyle(.plain)
            .padding(.horizontal)
            Spacer()
        }
        .padding(.top)
    }
}

#Preview {
    UserSettingsImageProfile(userProfileViewModel: UserProfileViewModel())
}
