//
//  UserProfileDetailsView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 29/7/24.
//

import SwiftUI
import PhotosUI

struct UserDetailsView: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @State var selectedItem: PhotosPickerItem? = nil
    @State var profileImage: UIImage? = nil
    @State var showPicker: Bool = false
    @State var show: Bool = false
    
    var body: some View {
        VStack(spacing: 30) {
            
            HStack(spacing: 30) {
                UserDetailsImage(profileImage: $userProfileViewModel.profileImage)
                UserDetailsResume(user: userProfileViewModel.user)
            }
            .padding(.top, 20)
            
            UserDetailsProgressBar(userProfileViewModel: userProfileViewModel)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
    }
}


#Preview("Sin usuario") {
    UserDetailsView(userProfileViewModel: UserProfileViewModel())
}
