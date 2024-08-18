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
            .onChange(of: selectedItem) {
                Task {
                    await loadAndUploadImage()
                }
            }
            
            Text(userProfileViewModel.user.displayName)
                .font(.system(size: 22, weight: .regular))
            
        }
    }
    
    private func loadAndUploadImage() async {
            guard let selectedItem = selectedItem else { return }
            
            do {
                let data = try await selectedItem.loadTransferable(type: Data.self)
                guard let imageData = data else { return }
                await userProfileViewModel.updateProfileImage(imageData: imageData)
                
            } catch {
                print("Failed to load or upload image: \(error.localizedDescription)")
            }
        }
}

#Preview {
    UserSettingsImageProfile(userProfileViewModel: UserProfileViewModel())
}



struct UserImageSettingsView: View {
    var profileImage: UIImage
    
    var body: some View {
        Image(uiImage: profileImage)
            .resizable()
            .scaledToFill()
            .clipShape(Circle()) // Recorta la imagen en forma de círculo
            .overlay(
                Circle().stroke(Color.white, lineWidth: 2) // Agrega un borde blanco alrededor del círculo
            )
        
    }
}

struct UserEmptyImageSettingsView: View {
    var body: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .foregroundStyle(.gray)
        
    }
}
