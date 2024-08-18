//
//  UserCurrentlyView.swift
//  MyReads
//
//  Created by Axel Álvarez Santos on 5/8/24.
//

import SwiftUI

struct UserCurrentlyView: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Currently reading")
                .font(.footnote)
                .foregroundStyle(.colortext7)
                .padding(.leading, userProfileViewModel.shouldShowCurrentlyReadingView() ? 21 : 0)
            
            if userProfileViewModel.shouldShowCurrentlyReadingView() {
                CurrentlyView(userProfileViewModel: userProfileViewModel)
                
            } else {
                CustomRoundedRectangle(overlayText: "No books here", width: 350, height: 120)
                
            }
        }
    }
}

#Preview {
    UserCurrentlyView(userProfileViewModel: UserProfileViewModel())
}
